//
//  R2CButton.swift
//  Road2Crypto
//
//  Created by Arturo on 3/2/24.
//  Copyright © 2024 Road2Crypto. All rights reserved.
//

import SwiftUI

/// A customizable button component
///
/// This button supports various styles, loading states, and customizations.
///
/// Example usage:
/// ```swift
/// R2CButton(text: "Login", style: .primaryLarge) {
///     // Handle login action
/// }
/// ```
struct R2CButton: View {
    
    /// The text to display on the button.
    var text: String
    
    /// Optional custom text color. If not provided, uses the default color for the selected style.
    var textColor: Color?
    
    /// Optional haptic feedback type for when the button is tapped.
    var vibration: VibrationType?
    
    /// Indicates whether the button is in a loading state.
    var isLoading: Bool = false
    
    /// The style variation for the button.
    var style: R2CButtonStyleVariations = .defaultLarge
    
    /// The action to perform when the button is tapped.
    var action: () -> Void
    
    /// Optional custom width for the button. Defaults to UIConstants.Button.iPhoneLarge.width.
    var width: CGFloat? = UIConstants.Button.iPhoneLarge.width
    
    /// Optional custom height for the button.
    var height: CGFloat?
    
    var body: some View {
        Button(action: {
            vibrate(vibration ?? .light)
            action()
        }) {
            if isLoading {
                SpinnerImage()
            } else {
                Text(text)
                    .typography(style.buttonStyle.typography, weight: style.buttonStyle.typography.attributes.weight, textAlignment: .center, color: textColor ?? style.textColor)
            }
        }
        .r2cCustomButton(style: style)
        .disabled(isLoading)
        .frame(maxWidth: UIConstants.Layout.maxLargeScreensWidth, alignment: .center)
    }
}

#Preview {
    Group {
        VStack {
            R2CButton(text: "Tap me!") { }
            R2CButton(text: "Tap me!", isLoading: true) { }
        }
        .setBackgroundColor()
    }
}
