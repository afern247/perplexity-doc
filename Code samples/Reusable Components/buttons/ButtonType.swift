//
//  ButtonType.swift
//  Road2Crypto
//
//  Created by Arturo Fernandez Marco on 9/6/22.
//  Copyright © 2022 Road2Crypto. All rights reserved.
//

import SwiftUI

/// Defines the style properties for a custom button.
public struct R2CButtonStyle {
    var buttonSize: ButtonSizes
    var buttonState: ButtonState
    var typography: TypographyType = .labelLarge
    var backgroundColor: Color
    var textColor: Color
    var border: ButtonBorderStyle
    var width: ButtonSizes.ButtonWidth = .medium
}

/// Enumerates various button style variations.
public enum R2CButtonStyleVariations {
    case text
    case clearSmall, clearLarge
    case defaultSmall, defaultLarge
    case disableSmall, disableLarge
    case alternativeSmall, alternativeLarge
    
    /// Returns the corresponding R2CButtonStyle for each variation.
    var buttonStyle: R2CButtonStyle {
        switch self {
        case .text:
            return R2CButtonStyle(buttonSize: .small,
                                  buttonState: .default,
                                  typography: .labelLarge,
                                  backgroundColor: self.backgroundColor,
                                  textColor: self.textColor,
                                  border: .none)
            
        case .clearSmall:
            return R2CButtonStyle(buttonSize: .small,
                                  buttonState: .default,
                                  typography: .labelSmall,
                                  backgroundColor: self.backgroundColor,
                                  textColor: self.textColor,
                                  border: .rounded)
        case .clearLarge:
            return R2CButtonStyle(buttonSize: .large,
                                  buttonState: .default,
                                  typography: .labelLarge,
                                  backgroundColor: self.backgroundColor,
                                  textColor: self.textColor,
                                  border: .rounded)
        case .defaultSmall:
            return R2CButtonStyle(buttonSize: .small,
                                  buttonState: .default,
                                  typography: .labelSmall,
                                  backgroundColor: self.backgroundColor,
                                  textColor: self.textColor,
                                  border: .none)
        case .defaultLarge:
            return R2CButtonStyle(buttonSize: .large,
                                  buttonState: .default,
                                  typography: .labelLarge,
                                  backgroundColor: self.backgroundColor,
                                  textColor: self.textColor,
                                  border: .none)
        case .disableSmall:
            return R2CButtonStyle(buttonSize: .small,
                                  buttonState: .disable,
                                  typography: .labelSmall,
                                  backgroundColor: self.backgroundColor,
                                  textColor: self.textColor,
                                  border: .none)
        case .disableLarge:
            return R2CButtonStyle(buttonSize: .large,
                                  buttonState: .disable,
                                  typography: .labelLarge,
                                  backgroundColor: .fillButtonDisable,
                                  textColor: self.textColor,
                                  border: .none)
        case .alternativeSmall:
            return R2CButtonStyle(buttonSize: .small,
                                  buttonState: .alternative,
                                  typography: .labelSmall,
                                  backgroundColor: self.backgroundColor,
                                  textColor: self.textColor,
                                  border: .none)
        case .alternativeLarge:
            return R2CButtonStyle(buttonSize: .large,
                                  buttonState: .alternative,
                                  typography: .labelLarge,
                                  backgroundColor: self.backgroundColor,
                                  textColor: self.textColor,
                                  border: .none)
        }
    }
    
    /// Returns the background color for each button style variation.
    var backgroundColor: Color {
        switch self {
        case .text: .clear
        case .clearSmall: .clear
        case .clearLarge: .clear
        case .defaultSmall: .brandPrimary
        case .defaultLarge: .brandPrimary
        case .disableSmall: .fillButtonDisable
        case .disableLarge: .fillButtonDisable
        case .alternativeSmall: .fillContrastButton
        case .alternativeLarge: .fillContrastButton
        }
    }
    
    /// Returns the text color for each button style variation.
    var textColor: Color {
        switch self {
        case .text: .brandPrimary
        case .clearSmall: .fillContrastButton
        case .clearLarge: .fillContrastButton
        case .defaultSmall: .fillNeutralElement
        case .defaultLarge: .fillNeutralElement
        case .disableSmall: .fillButtonDisable
        case .disableLarge: .fillButtonDisable
        case .alternativeSmall: .fillExclusive
        case .alternativeLarge: .fillExclusive
        }
    }
}

/// Defines the possible states of a button.
public enum ButtonState {
    case `default`, disable, alternative
}

/// Defines the size options for buttons.
public enum ButtonSizes {
    case small, large
    
    /// Returns the height for each button size.
    var height: CGFloat {
        switch self {
        case .small: return 30
        case .large: return 46
        }
    }
    
    /// Defines width options for buttons.
    public enum ButtonWidth {
        case sameAsText, small, medium, large
        
        /// Returns the width value for each option.
        var value: CGFloat? {
            switch self {
            case .sameAsText: nil
            case .small: 200
            case .medium: 334
            case .large: 400
            }
        }
    }
}

/// Defines the border style options for buttons.
public enum ButtonBorderStyle {
    case rounded, none
    
    /// Returns the border color for each style.
    var color: Color {
        switch self {
        case .rounded: .fillButtonBorder
        case .none: .clear
        }
    }
    
    /// Returns the border line width for each style.
    var lineWidth: CGFloat {
        switch self {
        case .rounded: 1.5
        case .none: 0
        }
    }
}
