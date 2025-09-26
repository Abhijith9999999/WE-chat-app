//
//  OnboardingViewModel.swift
//  We
//
//

import SwiftUI

func colorForSystemImage(systemName: String) -> Color {
    switch systemName {
    case "dot.circle.viewfinder":
        return .teal
    case "shield.fill":
        return .green
    case "eye.slash.fill":
        return .red
    case "lightbulb.fill":
        return .yellow
    case "hand.raised.fill":
        return .purple
    case "person.3.fill":
        return .orange
    case "book.fill":
        return .brown
    default:
        return .accentColor
    }
}

let onboardingData: [OnboardingInfo] = [
    OnboardingInfo(
        label: "Welcome to We",
        content: "We is your platform for open discussions with fellow university students. Share your thoughts, ask questions, and connect with others in a safe and welcoming environment.",
        systemName: "dot.circle.viewfinder"
    ),
    OnboardingInfo(
        label: "Privacy Protection",
        content: "Your privacy is our priority. We ensures that your identity is protected so you can freely express yourself without any concerns.",
        systemName: "shield.fill"
    ),
    OnboardingInfo(
        label: "Anonymity",
        content: "We hides your identity, allowing you to participate in discussions anonymously. This promotes honest and open conversations while keeping you safe.",
        systemName: "eye.slash.fill"
    ),
    OnboardingInfo(
        label: "Relevant Answers",
        content: "Our platform is built to provide you with relevant answers. Engage with a community of knowledgeable peers to find the information you need.",
        systemName: "lightbulb.fill"
    ),
    OnboardingInfo(
        label: "Integrity",
        content: "We promotes integrity and trust among students. We encourage respectful and honest interactions to build a supportive community.",
        systemName: "hand.raised.fill"
    ),
    OnboardingInfo(
        label: "Collaboration",
        content: "Collaborate with fellow students to share knowledge and ideas. We provides a space for productive discussions and teamwork.",
        systemName: "person.3.fill"
    ),
    OnboardingInfo(
        label: "Community Guidelines",
        content: "Our community guidelines help maintain a positive environment. Respect others' opinions and engage in constructive dialogue.",
        systemName: "book.fill"
    )
]
