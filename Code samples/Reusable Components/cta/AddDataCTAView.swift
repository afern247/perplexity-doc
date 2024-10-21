//
//  AddDataCTAView.swift
//  Road2Crypto
//
//  Created by Arturo on 5/10/24.
//  Copyright © 2024 Road2Crypto. All rights reserved.
//

import SwiftUI

/// A view component that displays a call-to-action for adding data.
///
/// This view presents a title, message, and a customizable button.
/// It's typically used to prompt users to add content when a section is empty.
///
/// Example usage:
/// ```swift
/// AddDataCTAView(
///     title: "Add Wallet",
///     message: "Start tracking your crypto by adding a wallet",
///     buttonText: "Add Wallet",
///     buttonStyle: .alternativeLarge,
///     action: { /* Handle add wallet action */ }
/// )
/// ```
struct AddDataCTAView: View {
    
    /// The title displayed at the top of the view.
    let title: String
    
    /// The message displayed below the title.
    let message: String
    
    /// The text displayed on the call-to-action button.
    let buttonText: String
    
    /// The style variation for the call-to-action button.
    let buttonStyle: R2CButtonStyleVariations
    
    /// The action to perform when the button is tapped.
    let action: () -> Void
    
    var body: some View {
        VStack {
            VStack(spacing: .spacing12) {
                Image(icon: .addWallet)
                    .scaledToFit()
                    .padding(.bottom, .spacing4)
                
                Text(title)
                    .typography(.headerSmall, textAlignment: .center, color: .fillPrimary)
                
                Text(message)
                    .typography(.bodySmall, textAlignment: .center, color: .fillSecondary, multiline: true)
                
                R2CButton(
                    text: buttonText,
                    vibration: .light,
                    style: buttonStyle
                ) {
                    action()
                }
                .frame(maxWidth: 134)
                .padding(.top, .spacing8)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.bgProminentArea)
            .cornerRadius(Radius.default)
        }
        .padding(.horizontal)
    }
}

#Preview {
    AddDataCTAView(
        title: "empty_portfolio_screen_button_cta".localized(),
        message: "subheader_portfolio_main_screen_empty".localized(),
        buttonText: "empty_portfolio_screen_button_cta".localized(),
        buttonStyle: .alternativeLarge,
        action: { }
    )
}
