//
//  HTTPService.swift
//  Road2Crypto
//
//  Created by Arturo Fernandez Marco on 10/25/23.
//  Copyright © 2023 Road2Crypto. All rights reserved.
//

import Alamofire
import Foundation

public enum ParameterRepresentation {
    case url
    case urlNoBrackets
    case json
}

public struct ResponseResult {
    let urlRequest: URLRequest
    let urlResponse: HTTPURLResponse?
    let parsedData: Any?
    let error: Error?
}

public protocol HTTPServiceProtocol {
    func request<T: Codable>(_ method: Alamofire.HTTPMethod,
                             api: ServiceType,
                             path: String,
                             parameters: Encodable?,
                             encoding: HTTPService.ParameterRepresentation,
                             headers: HttpHeadersConvertible?,
                             responseType: HTTPService.ResponseType) async -> Result<T, HTTPError>
    func request<T: Decodable>(modelToDecode: T.Type,
                               url: String,
                               headers: HttpHeadersConvertible?) async -> Result<T, HTTPError>
}

extension HTTPServiceProtocol {
    func request<T: Codable>(_ method: Alamofire.HTTPMethod,
                             api: ServiceType = .r2cAPI,
                             path: String,
                             parameters: Encodable? = nil,
                             encoding: HTTPService.ParameterRepresentation = .json,
                             headers: HttpHeadersConvertible? = nil,
                             responseType: HTTPService.ResponseType = .responseRaw) async -> Result<T, HTTPError> {
        return await request(method, api: api, path: path, parameters: parameters, encoding: encoding, headers: headers, responseType: responseType)
    }

    func request<T: Decodable>(modelToDecode: T.Type,
                               url: String,
                               headers: HttpHeadersConvertible? = nil) async -> Result<T, HTTPError> {
        return await request(modelToDecode: modelToDecode, url: url, headers: headers)
    }
}

public class HTTPService: HTTPServiceProtocol {
    
    public static let shared: HTTPServiceProtocol = HTTPService()
    private let parser = HTTPResponseParser()
    private let apiEndpoints: ApiEndpointsProtocol = ApiEndpoints()
    
    private func completeURL(api: ServiceType, path: String) -> String {
        return "\(api.urlPrefix)\(api.subdomain)\(api.domain)\(path)"
    }
    
    private init() { }
    
    /// Performs an HTTP request and returns a Result containing the decoded response or an error.
    ///
    /// - Parameters:
    ///   - method: The HTTP method for the request (e.g., .get, .post).
    ///   - api: The service type for the API (default is .r2cAPI).
    ///   - path: The path of the API endpoint.
    ///   - parameters: Optional parameters to be sent with the request.
    ///   - encoding: The parameter representation (default is .json).
    ///   - headers: Optional custom headers for the request.
    ///   - responseType: The type of response expected (default is .responseRaw).
    ///
    /// - Returns: A Result containing the decoded response of type T or an HTTPError.
    ///
    /// - Example usage:
    ///   ```
    ///   let response: Result<UserDevice, HTTPError> = await service.request(.post, path: "/api/v1/user/push/create-endpoint", parameters: parameters)
    ///   ```
    public func request<T: Codable>(_ method: Alamofire.HTTPMethod,
                                    api: ServiceType = .r2cAPI,
                                    path: String = "",
                                    parameters: Encodable? = nil,
                                    encoding: ParameterRepresentation = .json,
                                    headers: HttpHeadersConvertible? = nil,
                                    responseType: ResponseType = .responseRaw) async -> Result<T, HTTPError> {
        
        let completePath = completeURL(api: api, path: path)
        var finalHeaders = headers?.httpHeaders ?? HttpHeaders()
        
        let key = apiEndpoints.getKey(for: .ios_client_key)
        finalHeaders.add(name: "x-client-token-ios", value: key)
        
        if api.isAccessTokenRequired {
            if await addTokenIfNeeded(for: path, headers: &finalHeaders) {
                var accessTokenSuccess = false
                for _ in 0..<2 {
                    if await AuthManager.shared.doesRefreshTokenNeedsUpdate() {
                        log.error("Access Token expired, logging out user. Path: ", path)
                        await AppEventNotifier.shared.post(.userShouldLogout)
                        return .failure(.clientError(401, "Access Token expired"))
                    } else {
                        let isAccessTokenExpired = await isAccessTokenExpired(for: path)
                        if isAccessTokenExpired {
                            // Try to refresh the token
                            let result = await AuthManager.shared.updateAccessToken()
                            switch result {
                            case .success(let token):
                                await AuthManager.shared.saveAccessToken(token.accessToken)
                                // Replace the Authorization header with the new token
                                finalHeaders.remove(name: "Authorization")
                                finalHeaders.add(name: "Authorization", value: token.accessToken)
                                accessTokenSuccess = true
                            case .failure(let error):
                                log.warn("Failed refreshing the Access Token, trying again. Error: ", error)
                                continue // Retry
                            }
                        } else {
                            accessTokenSuccess = true
                            // If the token is not expired, continue with the request
                            break
                        }
                    }
                }
                if !accessTokenSuccess {
                    // If both attempts fail, log out the user
                    log.error("Failed refreshing the Access Token after retries.")
                    await AppEventNotifier.shared.post(.userShouldLogout)
                    return .failure(.clientError(401, "🛑 Unauthorized: Missing or invalid access token."))
                }
            }
        }
        
        return await withCheckedContinuation { continuation in
            self.executeRequest(method, path: completePath, parameters: parameters, encoding: encoding, headers: finalHeaders) { (result: Result<Data, HTTPError>) in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
                    do {
                        let decodedData = try decoder.decode(T.self, from: data)
                        continuation.resume(returning: .success(decodedData))
                    } catch {
                        continuation.resume(returning: .failure(.dataCorruption(0, "Decoding error: \(error)")))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(error))
                }
            }
        }
    }
    
    private func executeRequest(_ method: Alamofire.HTTPMethod,
                                path: String,
                                parameters: Encodable? = nil,
                                encoding: ParameterRepresentation,
                                headers: HttpHeadersConvertible? = nil,
                                completionHandler: @escaping (Result<Data, HTTPError>) -> Void) {
        guard let url = URL(string: path) else {
            completionHandler(.failure(.errorDomain("Invalid url construct")))
            return
        }
        
        let finalHeaders: HTTPHeaders = headers?.httpHeaders ?? [:]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = finalHeaders
        
        if let parameters = parameters {
            do {
                let encodedParameters = try encodeParameters(parameters: parameters, encoding: encoding)
                urlRequest.httpBody = encodedParameters.data
                if let contentType = encodedParameters.contentType {
                    urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
                }
            } catch {
                completionHandler(.failure(.errorDomain("Parameters encoding failed")))
                return
            }
        }
        
        AF.request(urlRequest)
            .validate(statusCode: 200..<300)
            .responseData { [weak self] response in
                DispatchQueue.main.async { [weak self] in
                    let statusCode = response.response?.statusCode ?? response.error?.responseCode ?? 0
                    
                    if 200..<300 ~= statusCode {
                        if let data = response.data {
                            completionHandler(.success(data))
                        } else {
                            self?.logError(statusCode: statusCode, error: response.error, url: path)
                            completionHandler(.failure(.dataCorruption(statusCode, "No data")))
                        }
                    } else {
                        if case .failure = response.result {
                            self?.logError(statusCode: statusCode, error: response.error, url: path)
                        }
                        
                        if let data = response.data {
                            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                            let message = errorResponse?.message ?? "No message"
                            switch statusCode {
                            case 400..<500:
                                // If unauthorized, logout the user
                                if statusCode == 401 || statusCode == 403 {
                                    self?.logError(statusCode: statusCode, error: response.error, message: "Loging out user, auth error.", url: path)
                                    AppEventNotifier.shared.post(.userShouldLogout)
                                }
                                completionHandler(.failure(.clientError(statusCode, message)))
                            case 500..<600:
                                completionHandler(.failure(.serverError(statusCode, message)))
                            default:
                                completionHandler(.failure(.unknownStatus(statusCode, message)))
                            }
                        } else {
                            completionHandler(.failure(.unknownStatus(statusCode, "No data")))
                        }
                    }
                }
            }
    }
    
    @MainActor internal func logError(statusCode: Int, error: AFError? = nil, message: String = "", url: String) {
        // If the request wasn't canceled, because of user going back or other external factor
        if statusCode >= 500 {
            let errorMessage = error?.errorDescription ?? message
            
            // If unauthorized
            var userDetails = ""
            if statusCode == 401 {
                let isRefreshTokenEmpty: Bool = AuthManager.shared.getRefreshToken(shouldLog: true)?.isEmpty ?? true
                let isAccessTokenEmpty: Bool = AuthManager.shared.getAccessToken(shouldLog: true)?.isEmpty ?? true
                userDetails = " - User: \(User.current.email) - Is refresh token empty? \(isRefreshTokenEmpty) - Is access token empty? \(isAccessTokenEmpty)"
            }
            
            log.error("Status code: \(statusCode) - \(errorMessage) - URL path: " + url + userDetails)
        } else if statusCode >= 300 && statusCode < 500 {
            let errorMessage = error?.errorDescription ?? message
            log.warn("Request failed with Status code: \(statusCode) - \(errorMessage) - URL path: " + url)
        }
    }
    
    private func encodeParameters(parameters: Encodable, encoding: ParameterRepresentation) throws -> (data: Data, contentType: String?) {
        switch encoding {
        case .json:
            let jsonData = try JSONEncoder().encode(parameters)
            return (jsonData, "application/json")
        case .url, .urlNoBrackets:
            // Implement URL encoding if needed
            throw HTTPError.errorDomain("URL encoding not implemented")
        }
    }
}

extension HTTPService {
    public enum ResponseType: String {
        case responseRaw = "raw"
        case responseString = "string"
    }
    
    public enum ParameterRepresentation {
        case url
        case urlNoBrackets
        case json
    }
}

public class HTTPResponseParser {
    
    private let serializer = StringResponseSerializer()
    
    // swiftlint:disable large_tuple
    internal func requestComplete(_ data: Data?,
                                  responseType: HTTPService.ResponseType,
                                  urlRequest: URLRequest,
                                  urlResponse: HTTPURLResponse?,
                                  error: Error?) throws -> (URLRequest, HTTPURLResponse?, Any?, Error?) {
        switch responseType {
        case .responseRaw:
            return (urlRequest, urlResponse, data, error)
            
        case .responseString:
            let result = try serializer.serialize(request: urlRequest, response: urlResponse, data: data, error: nil)
            let validatingError = validateResponse(urlResponse, data: data)
            return (urlRequest, urlResponse, result, validatingError)
        }
    }
    // swiftlint:enable large_tuple
    
    private func validateResponse(_ actualResponse: HTTPURLResponse?, data: Data?) -> Error? {
        guard let actualResponse = actualResponse else {
            return HTTPError.canceled
        }
        
        switch actualResponse.statusCode {
        case 200..<300:
            return nil
            
        case 400..<500:
            let message = decodeErrorMessage(data: data)
            return HTTPError.clientError(actualResponse.statusCode, message)
            
        case 500..<600:
            let message = decodeErrorMessage(data: data)
            return HTTPError.serverError(actualResponse.statusCode, message)
            
        default:
            let message = decodeErrorMessage(data: data)
            return HTTPError.unknownStatus(actualResponse.statusCode, message)
        }
    }
    
    private func decodeErrorMessage(data: Data?) -> String {
        guard let data = data else { return "No message" }
        let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
        return errorResponse?.message ?? "No message"
    }
}

// Access token management
extension HTTPService {
    @MainActor private func addTokenIfNeeded(for path: String, headers: inout HttpHeaders) -> Bool {
        let isPathExcluded = pathsExcludingToken.contains(where: { path.starts(with: $0) })
        guard !isPathExcluded else { return false }
        
        if let accessToken = KeychainService.getCredentials(UserDefaultsUtil.Keys.cognitoUserAccessToken, shouldLog: true) {
            headers.add(name: "Authorization", value: accessToken)
            return true
        }
        return false
    }
    
    private func isAccessTokenExpired(for path: String) async -> Bool {
        guard !pathsExcludingToken.contains(path) else { return false }
        return await AuthManager.shared.doesAccessTokenNeedsUpdate()
    }
    
    // These paths do not require the auth token
    private var pathsExcludingToken: Set<String> {
        return [
            "/auth/login",
            // rest removed for privacy
        ]
    }
}

// Ensure that the ParameterRepresentation is the one defined in HTTPService
private func encodeParameters(parameters: Encodable, encoding: HTTPService.ParameterRepresentation) throws -> (data: Data, contentType: String?) {
    switch encoding {
    case .json:
        let jsonData = try JSONEncoder().encode(parameters)
        return (jsonData, "application/json")
    case .url, .urlNoBrackets:
        // Implement URL encoding if needed
        throw HTTPError.errorDomain("URL encoding not implemented")
    }
}

extension HTTPService {
    /// Stops all async requests
    static func stopAllFetchRequests() {
        Alamofire.Session.default.session.getTasksWithCompletionHandler({ dataTasks, uploadTasks, downloadTasks in
            // Checking if the task exists otherwise the app would crash when trying to stop them and it's empty
            if !dataTasks.isEmpty {
                log.debug("⏹ Stopping all dataTasks requests")
                dataTasks.forEach { $0.cancel() }
                log.debug("⏹ Stopped all dataTasks requests")
            }
            if !downloadTasks.isEmpty {
                log.debug("⏹ Stopping all downloadTasks requests")
                downloadTasks.forEach { $0.cancel() }
                log.debug("⏹ Stopped all downloadTasks requests")
            }
            if !uploadTasks.isEmpty {
                log.debug("⏹ Stopping all uploadTasks requests")
                uploadTasks.forEach { $0.cancel() }
                log.debug("⏹ Stopped all uploadTasks requests")
            }
        })
    }
}
