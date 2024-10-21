# Custom Button Component - R2CButton.swift

The  `R2CButton` simplifies button creation with customizable properties and built-in features, enhancing code maintainability and user experience.

- Reusability: Centralizes button logic and styling to keep the feel and look of the app consistent.
- Customization: Offers flexible parameters for different use cases.
- User Feedback: Improves interactivity with haptic feedback and loading indicators.


### Features

- **Customizable Text and Style**: Easily set button text, color, and style variations.
- **Loading State Management**: Displays a loading spinner when operations are in progress.
- **Haptic Feedback Integration**: Optional vibration feedback on user interaction.
- **Adaptive Layout**: Adjustable width and height to accommodate different screen sizes.
- **Accessibility**: Supports dynamic text sizes and ensures readability.

### Code

I've included the relevant `Swift` files in this folder for the reusable button module.

## Code Snippet

```swift
import SwiftUI

struct R2CButton: View {
    var text: String
    var textColor: Color?
    var vibration: VibrationType?
    var isLoading: Bool = false
    var style: R2CButtonStyleVariations = .defaultLarge
    var action: () -> Void

    var width: CGFloat? = UIConstants.Button.iPhoneLarge.width
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
                    .typography(
                        style.buttonStyle.typography,
                        weight: style.buttonStyle.typography.attributes.weight,
                        textAlignment: .center,
                        color: textColor ?? style.textColor
                    )
            }
        }
        .r2cCustomButton(style: style)
        .disabled(isLoading)
        .frame(maxWidth: UIConstants.Layout.maxLargeScreensWidth, alignment: .center)
    }
}
```

## Usage Example

```swift
# Preview {
    VStack {
        R2CButton(text: "Tap me!") { }
        R2CButton(text: "Loading...", isLoading: true) { }
    }
}
```

