//
//  WhatsNewViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 11/3/24.
//

import SwiftUI

let whatsNewData: [WhatsNew] = [
    WhatsNew(version: "1.0 Beta", features: [
        Feature(title: "New Design", content: "We have completely revamped the app design for a more modern and user-friendly experience."),
        Feature(title: "Bug Fixes", content: "Fixed several bugs reported by users to improve overall stability."),
        Feature(title: "User Onboarding", content: "Enhanced onboarding process to help new users get started quickly."),
        Feature(title: "Performance Optimization", content: "Improved app performance for smoother navigation and faster load times.")
    ]),
    WhatsNew(version: "1.0.1 Beta", features: [
        Feature(title: "Performance Improvements", content: "App is now faster and more responsive with reduced loading times."),
        Feature(title: "Dark Mode", content: "Added support for dark mode to enhance usability in low-light environments."),
        Feature(title: "Enhanced Search Functionality", content: "Improved search capabilities to help users find content more easily.")
    ]),
    WhatsNew(version: "1.0.2 Beta", features: [
        Feature(title: "New Features", content: "Introducing exciting new features for enhanced user experience."),
        Feature(title: "User Feedback Integration", content: "We have integrated user feedback to improve functionality and usability."),
        Feature(title: "Enhanced Security", content: "Improved security measures to protect user data and privacy."),
        Feature(title: "Beta Testing Program", content: "Join our beta testing program to get early access to new features and provide feedback."),
        Feature(title: "Improved Navigation", content: "Streamlined navigation for easier access to key features and content."),
        Feature(title: "In-App Tutorials", content: "New in-app tutorials to help users navigate the app effectively and utilize new features."),
        Feature(title: "Bug Reporting Tool", content: "Easily report bugs and issues directly from the app for quicker resolutions."),
        Feature(title: "Community Feedback Forum", content: "Participate in our community forum to share ideas, suggestions, and feedback.")
    ]),
    WhatsNew(version: "1.0.3 Beta", features: [
        Feature(title: "Content Personalization", content: "Enhanced algorithms for personalized content recommendations based on user behavior."),
        Feature(title: "Accessibility Improvements", content: "Added features to improve accessibility for all users, including voice commands and screen reader support.")
    ])
]
