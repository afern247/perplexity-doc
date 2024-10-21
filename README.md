# perplexity.ai - Technical Submission

This submission includes code samples from Road2Crypto, my personal project which is a cryptocurrency portfolio tracker and analytics tool. The code demonstrates my approach to building scalable, modular, and maintainable software, with a focus on reusable components, efficient API handling, and CI/CD automation.

## What's Inside

- **Reusable Components**: A set of modular UI components, such as customizable buttons and CTAs, designed for flexibility and reusability across the app.
- **HTTP Service**: A robust service layer for handling API requests, ensuring scalability and maintainability in a high-traffic environment.
- **Utilities**: Helper functions like `DecodableDefault` to handle default values when decoding JSON responses, improving resilience when dealing with inconsistent data.
- **CI/CD Workflow**: A GitHub Actions workflow that automates the release process to the App Store, ensuring a streamlined and reliable deployment pipeline.

Each section reflects my focus on writing clean, maintainable code that can scale with the needs of the application.

## Published App

- **[Road2Crypto](https://apps.apple.com/us/app/road2crypto-crypto-tracker/id1580265927)**: A multi-platform cryptocurrency portfolio tracker and analytics platform with over 100 blockchain integrations, including support for newly minted DeFi tokens.

## Presentation Experience

At my previous company, WeightWatchers, I led the iOS development of a member-to-member chat feature from scratch. This feature enabled members to communicate directly within the app, enhancing community engagement. I presented this feature at a company-wide event, showcasing the technical architecture, challenges faced, and the impact it had on user interaction. This event was more like a 1-2 days hackathon, which demonstrated my ability to create fast iteration of features ready for production, communicate technical concepts to a broad audience, and deliver impactful features that align with business goals.

## Data Analysis of a Problem I've Solved

One of the most impactful problems I recently solved was implementing **server-side push notifications** for iOS users in the Road2Crypto app. The challenge was to ensure that users receive timely and relevant alerts based on their custom preferences, such as price movements, volume spikes, or breaking news in the cryptocurrency market.

### Problem

The primary issue was managing the complexity of delivering personalized notifications to users across different devices and platforms, while ensuring scalability and reliability. Users needed to be able to set custom alerts based on various conditions (e.g., price above/below a threshold, percentage changes, etc.), and the system had to handle both **custom alerts** and **topic-based alerts** (e.g., breaking news or significant market moves).

### Solution

I designed and implemented a **server-side push notification system** that integrates with apple devices. The system allows users to set up custom alerts based on their preferences, which are stored in a backend database. The backend processes these alerts and sends push notifications to the appropriate devices using AWS Pinpoint for scalability.

Key components of the solution:

- **Custom Alerts**: Users can set alerts based on specific conditions (e.g., price above a certain threshold), which are stored in the backend and evaluated periodically.
- **Topic-Based Alerts**: Users can subscribe to predefined topics like "Breaking News" or "Volume Spikes," and receive notifications when relevant events occur.
- **Device Management**: Each user device is registered with a unique token, allowing the system to send notifications to the correct device. The system supports multiple platforms, including iOS and iPadOS.
- **Scalability**: The system is designed to handle a large number of users and alerts, ensuring that notifications are delivered in real-time without delays.
