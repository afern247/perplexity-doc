# DecodableDefault Property Wrapper

## Overview

I've created a `DecodableDefault` property wrapper to elegantly handle missing or null fields when decoding JSON data in Swift. This solution provides a clean, type-safe way to set default values for various data types, reducing boilerplate code and improving the robustness of my data models.

## Key Features

1. **Type-Safe Defaults**: I've implemented default values for common types like numbers, booleans, strings, arrays, dates, and dictionaries.
2. **Custom Defaults**: The design allows for easy creation of custom default values for any `Decodable` type.
3. **Codable Compatibility**: The property wrapper works seamlessly with Swift's `Codable` protocol.
4. **Equatable and Hashable**: I've made the wrapper `Equatable` and `Hashable` when the wrapped value conforms to these protocols.

## Implementation Details

- `DecodableDefault`: The main property wrapper that handles the decoding logic.
- `DefaultDecodableValue`: A protocol that defines types that can provide default values.
- Specific implementations for common types: `DefaultZero`, `DefaultFalse`, `DefaultTrue`, `DefaultEmptyString`, `DefaultEmptyArray`, `DefaultCurrentDate`, and `DefaultEmptyDictionary`.

## Usage Example

Here's how I use the `DecodableDefault` property wrapper in a real-world scenario:

```swift
struct GlobalMarketDataResult: Codable {
    let data: GlobalMarketData?
    @DecodableDefault<DefaultEmptyString> var currency: String
    @DecodableDefault<DefaultZero<Int>> var timestamp: Int
}

struct GlobalMarketData: Codable {
    @DecodableDefault<DefaultZero<Double>> var totalMarketCap: Double
    @DecodableDefault<DefaultZero<Double>> var totalVolume24h: Double
    @DecodableDefault<DefaultZero<Double>> var defiMarketCap: Double
    @DecodableDefault<DefaultZero<Double>> var defiVolume24h: Double
    @DecodableDefault<DefaultZero<Double>> var defiDominance: Double
    @DecodableDefault<DefaultEmptyString> var defiTopCoinName: String
    @DecodableDefault<DefaultZero<Double>> var defiTopCoinDominance: Double
    @DecodableDefault<DefaultZero<Double>> var fearGreedIndex: Double
    @DecodableDefault<DefaultZero<Double>> var totalMarketCapChange24h: Double
    @DecodableDefault<DefaultZero<Double>> var totalVolumeChange24h: Double
    @DecodableDefault<DefaultZero<Double>> var defiMarketCapChange24h: Double
    @DecodableDefault<DefaultZero<Double>> var defiVolumeChange24h: Double
    @DecodableDefault<DefaultZero<Double>> var defiDominanceChange24h: Double
    @DecodableDefault<DefaultZero<Double>> var bitcoinDominance: Double
    @DecodableDefault<DefaultZero<Double>> var bitcoinDominanceChange24h: Double

    enum CodingKeys: String, CodingKey {
        // ... (CodingKeys implementation)
    }
}
