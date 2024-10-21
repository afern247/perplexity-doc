//
//  Button+Customizable.swift
//  Road2Crypto
//
//  Created by Arturo on 3/2/24.
//  Copyright © 2024 Road2Crypto. All rights reserved.
//

import SwiftUI

/// Custom button style conforming to ButtonStyle protocol.
/// Provides a configurable appearance based on R2CButtonStyleVariations.
struct R2CCustomButtonStyle: ButtonStyle {
    var style: R2CButtonStyleVariations
    var width: CGFloat?
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: width ?? .infinity)
            .frame(height: style.buttonStyle.buttonSize.height)
            .contentShape(Rectangle())
            .background(style.buttonStyle.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.large.rawValue)
                    .inset(by: 0.75)
                    .stroke(style.buttonStyle.border.color, lineWidth: style.buttonStyle.border.lineWidth)
            )
            .cornerRadius(Radius.large.rawValue)
            .conditionalScaleEffect(isPressed: configuration.isPressed, pushDownAnimation: UIConstants.Button.pushDownAnimation)
    }
}

/// ViewModifier to apply custom button styling.
/// Encapsulates R2CCustomButtonStyle for easy application to any View.
struct CustomizableButton: ViewModifier {
    var style: R2CButtonStyleVariations
    var width: CGFloat?
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(
                R2CCustomButtonStyle(
                    style: style,
                    width: width
                )
            )
    }
}

extension Button {
    /// Convenience method to apply custom R2C button styling.
    /// Allows for easy application of custom styles to Button instances.
    func r2cCustomButton(
        style: R2CButtonStyleVariations,
        width: CGFloat? = nil
    ) -> some View {
        self.modifier(
            CustomizableButton(
                style: style,
                width: width
            )
        )
    }
}
