//
//  View+ConditionalScaleEffect.swift
//  Road2Crypto
//
//  Created by Arturo Fernandez Marco on 4/10/23.
//  Copyright © 2023 Road2Crypto. All rights reserved.
//

import SwiftUI

// A custom ViewModifier that conditionally applies a scale effect and animation based on the provided flags.
struct ConditionalScaleEffect: ViewModifier {
    let isPressed: Bool
    let pushDownAnimation: Bool
    
    // The body function applies the scale effect and animation if pushDownAnimation is true.
    func body(content: Content) -> some View {
        if pushDownAnimation {
            return content
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
                .eraseToAnyView()
        } else {
            return content.eraseToAnyView()
        }
    }
}

// View extension to provide convenience methods for applying the ConditionalScaleEffect modifier.
extension View {
    /// Applies the ConditionalScaleEffect modifier to the view with the given isPressed and pushDownAnimation flags.
    /// Usage:
    /// ```
    /// Button(action: {
    ///     // Perform some action
    /// }) {
    ///     Text("Press Me")
    /// }
    /// .conditionalScaleEffect(isPressed: isButtonPressed, pushDownAnimation: true)
    /// ```
    func conditionalScaleEffect(isPressed: Bool, pushDownAnimation: Bool) -> some View {
        self.modifier(ConditionalScaleEffect(isPressed: isPressed, pushDownAnimation: pushDownAnimation))
    }
    
    // Wraps the view in an AnyView, allowing for type erasure and easier combination of different view types.
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
