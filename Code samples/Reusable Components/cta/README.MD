# AddDataCTAView Component

## Overview

I've designed the `AddDataCTAView` as a highly reusable SwiftUI component to provide a consistent and visually appealing call-to-action (CTA) interface across the application. I created this component specifically for empty states, onboarding processes, or any scenario where I need to prompt users to add data or take a specific action.

## Key Features

1. **Customizability**: I've made the view highly customizable, allowing for different titles, messages, button texts, and button styles to be passed in, making it versatile for various use cases.

2. **Consistent Design Language**: I've utilized the custom typography and color system, ensuring consistency with the app's design guidelines.

3. **Accessibility**: I've implemented proper text alignment and multiline support, enhancing readability and accessibility.

4. **Haptic Feedback**: I've incorporated haptic feedback for button presses, improving the tactile user experience.

5. **Responsive Layout**: I've designed it to adapt to different screen sizes with flexible width and appropriate padding.

## Technical Highlights

1. **SwiftUI Best Practices**:
   - I've utilized `@ViewBuilder` for composing the view hierarchy.
   - I've leveraged SwiftUI's declarative syntax for concise and readable code.

2. **Custom Button Implementation**:
   - I've used the `R2CButton` component, which allows for consistent button styling across the app.
   - I've implemented custom button styles through the `R2CButtonStyleVariations` enum.

3. **Performance Considerations**:
   - I've minimized view hierarchy depth to optimize rendering performance.
   - I've used appropriate view modifiers to prevent unnecessary view updates.

4. **Extensibility**:
   - I've designed it with potential future requirements in mind, allowing for easy addition of new features or modifications.

## Usage Example

```swift
AddDataCTAView(
    title: "Add New Wallet",
    message: "Start tracking your crypto portfolio by adding a wallet address.",
    buttonText: "Add Wallet",
    buttonStyle: .alternativeLarge,
    action: {
        // logic goes here
    }
)
