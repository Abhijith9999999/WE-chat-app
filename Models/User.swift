//
//  User.swift
//  We
//
//

import Foundation

struct User: Codable, Identifiable, Equatable, Hashable {
    let id: String
    var username: String?
    let email: String?
    let role: String? // e.g., "admin", "moderator", "user"

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username
        case email
        case role
    }
}

// Sample Post data with User and Board objects
let sampleUsers: [User] = [
    User(id: "610cd1cf3b0f5a001e86534b", username: "@AnonStudent", email: "anon@student.com", role: "user"),
    User(id: "610cd1cf3b0f5a001e86534a", username: "@SwiftLearner", email: "swift@learner.com", role: "user"),
    User(id: "610cd1cf3b0f5a001e86534c", username: "@HungryStudent", email: "hungry@student.com", role: "user"),
    User(id: "610cd1cf3b0f5a001e86534d", username: "@StressedOut", email: "stressed@student.com", role: "user"),
    User(id: "610cd1cf3b0f5a001e86534e", username: "@Explorer", email: "explorer@student.com", role: "user"),
    User(id: "610cd1cf3b0f5a001e86534f", username: "@SoloWorker", email: "solo@worker.com", role: "user"),
    User(id: "610cd1cf3b0f5a001e865350", username: "@FreshmanFocus", email: "freshman@focus.com", role: "user")
]
