//
//  CloseButton.swift
//  Road2Crypto
//
//  Created by Arturo on 4/10/24.
//  Copyright © 2024 Road2Crypto. All rights reserved.
//

import SwiftUI

enum CloseButtonStyle {
    case `default`
}

struct R2CXButton: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var theme: Theme
    
    var buttonStyle: CloseButtonStyle = .default
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            AnalyticService.Portfolio.close.track()
            
            dismiss()
            action?()
        }) {
            Icon(icon: .xClose)
        }
    }
}

#Preview {
    R2CXButton() { }
        .environmentObject(Theme())
}
