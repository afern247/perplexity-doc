//
//  DecodableDefault.swift
//  Road2Crypto
//
//  Created by Arturo Fernandez Marco on 9/6/22.
//  Copyright © 2022 Road2Crypto. All rights reserved.
//

import Foundation

/// Property wrapper for setting a default value for missing or null fields during decoding.
/// Usage: @DecodableDefault<DefaultZero<Double>> var value: Double
@propertyWrapper
public struct DecodableDefault<Default: DefaultDecodableValue>: Decodable {
    public var wrappedValue: Default.Value

    public init(wrappedValue: Default.Value) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try? container.decode(Default.Value.self)) ?? Default.defaultValue
    }
}

extension KeyedDecodingContainer {
    /// Decodes a DecodableDefault value, using the default if the key is missing or null.
    /// Usage: let value = try container.decode(DecodableDefault<DefaultZero<Int>>.self, forKey: .someKey)
    public func decode<T>(_: DecodableDefault<T>.Type,
                          forKey key: KeyedDecodingContainer<K>.Key) throws -> DecodableDefault<T> {
        if let value = try decodeIfPresent(DecodableDefault<T>.self, forKey: key) {
            return value
        }
        return DecodableDefault(wrappedValue: T.defaultValue)
    }
}

extension DecodableDefault: Encodable where Default.Value: Encodable {
    /// Encodes the wrapped value.
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension DecodableDefault: Equatable where Default.Value: Equatable { }
extension DecodableDefault: Hashable where Default.Value: Hashable { }

// MARK: - Default value types

/// A Decodable type that can provide a default value for a missing or null field.
public protocol DefaultDecodableValue {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

/// Defaults numeric types to `0` when decoding a missing or null field.
/// Usage: @DecodableDefault<DefaultZero<Int>> var count: Int
public enum DefaultZero<T: Numeric & Decodable>: DefaultDecodableValue {
    public typealias Value = T
    public static var defaultValue: Value { 0 }
}

/// Defaults a Bool to `false` when decoding a missing or null field.
/// Usage: @DecodableDefault<DefaultFalse> var isEnabled: Bool
public enum DefaultFalse: DefaultDecodableValue {
    public static var defaultValue: Bool { false }
}

/// Defaults a Bool to `true` when decoding a missing or null field.
/// Usage: @DecodableDefault<DefaultTrue> var isAvailable: Bool
public enum DefaultTrue: DefaultDecodableValue {
    public static var defaultValue: Bool { true }
}

/// Defaults a String to `""` when decoding a missing or null field.
/// Usage: @DecodableDefault<DefaultEmptyString> var name: String
public enum DefaultEmptyString: DefaultDecodableValue {
    public static var defaultValue: String { "" }
}

/// Defaults an Array to `[]` when decoding a missing or null field.
/// Usage: @DecodableDefault<DefaultEmptyArray<String>> var tags: [String]
public enum DefaultEmptyArray<T: Decodable>: DefaultDecodableValue {
    public static var defaultValue: [T] { [] }
}

/// Defaults a Date to `Date()` when decoding a missing or null field.
/// Usage: @DecodableDefault<DefaultCurrentDate> var createdAt: Date
public enum DefaultCurrentDate: DefaultDecodableValue {
    public static var defaultValue: Date { Date() }
}

/// Defaults a Dictionary to `[:]` when decoding a missing or null field.
/// Usage: @DecodableDefault<DefaultEmptyDictionary<String, Int>> var scores: [String: Int]
public enum DefaultEmptyDictionary<K: Hashable & Decodable, V: Decodable>: DefaultDecodableValue {
    public static var defaultValue: [K: V] { [:] }
}
