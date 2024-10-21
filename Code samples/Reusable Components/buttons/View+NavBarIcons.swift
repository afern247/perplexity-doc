//
//  View+NavBarIcons.swift
//  Road2Crypto
//
//  Created by Arturo on 5/27/24.
//  Copyright © 2024 Road2Crypto. All rights reserved.
//

import SwiftUI

extension View {
    /// Sets an optional left button on the navigation bar.
    /// - Parameters:
    ///   - backButton: Optional icon for the left button.
    ///   - action: Optional action for the left button.
    ///   - shouldShow: Condition to show the left button, default is true.
    /// - Returns: A view with the specified left button.
    ///
    /// Usage Example:
    /// ```
    /// struct ContentView: View {
    ///     var body: some View {
    ///         Text("Hello, World!")
    ///             .set(backButton: .arrowLeft, action: { print("Left button tapped") }, shouldShow: true)
    ///     }
    /// }
    /// ```
    func set(backButton: TintableIcon? = nil, action: @escaping () -> Void, shouldShow: Bool = true) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(backButton != nil && shouldShow)
            .toolbar {
                if let backButton = backButton, shouldShow {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: action) {
                            Icon(size: .size28, icon: backButton)
                        }
                    }
                }
            }
    }

    /// Sets an optional right button on the navigation bar.
    /// - Parameters:
    ///   - rightButton: Optional icon for the right button.
    ///   - action: Optional action for the right button.
    ///   - shouldShow: Condition to show the right button, default is true.
    /// - Returns: A view with the specified right button.
    ///
    /// Usage Example:
    /// ```
    /// struct ContentView: View {
    ///     var body: some View {
    ///         Text("Hello, World!")
    ///             .set(rightButton: .settings, action: { print("Right button tapped") }, shouldShow: true)
    ///     }
    /// }
    /// ```
    func set(rightButton: ColoredIcon? = nil, action: @escaping () -> Void, shouldShow: Bool = true) -> some View {
        self
            .toolbar {
                if let rightButton = rightButton, shouldShow {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: action) {
                            Image(icon: rightButton)
                                .resizable()
                        }
                    }
                }
            }
    }
    
    func setNavigationTitle(_ title: String) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .typography(.headerSmall, textAlignment: .center, color: .fillPrimary, multiline: false)
                }
            }
    }
}
