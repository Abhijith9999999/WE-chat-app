//
//  Board.swift
//  We
//

import Foundation

struct Board: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let description: String
    let symbolColor: String
    let systemImageName: String
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case symbolColor
        case systemImageName
        case user
    }
}

let sampleBoards: [Board] = [
    Board(
        id: "610cf9e03b0f5a001e86534d",
        title: "Study Board",
        description: "A board dedicated to finding great study spots",
        symbolColor: "#FF5733", // Orange color
        systemImageName: "books.vertical",
        user: sampleUsers[0]
    ),
    Board(
        id: "610cf9e03b0f5a001e86534e",
        title: "Learning",
        description: "A board for learning and sharing tips",
        symbolColor: "#33FF57", // Green color
        systemImageName: "swift",
        user: sampleUsers[1]
    ),
    Board(
        id: "610cf9e03b0f5a001e86534f",
        title: "Student Life",
        description: "Discuss all things related to student life",
        symbolColor: "#FF33A8", // Pink color
        systemImageName: "person.3.fill",
        user: sampleUsers[2]
    ),
    Board(
        id: "610cf9e03b0f5a001e865350",
        title: "Health & Wellness",
        description: "Mental health and wellness resources",
        symbolColor: "#33C1FF", // Blue color
        systemImageName: "heart.fill",
        user: sampleUsers[3]
    ),
    Board(
        id: "610cf9e03b0f5a001e865351",
        title: "Study Abroad",
        description: "For students interested in studying abroad",
        symbolColor: "#FF6B33", // Orange color
        systemImageName: "airplane",
        user: sampleUsers[4]
    ),
    Board(
        id: "610cf9e03b0f5a001e865352",
        title: "Group Projects",
        description: "Vent or share tips about group projects",
        symbolColor: "#8E44AD", // Purple color
        systemImageName: "person.2.fill",
        user: sampleUsers[5]
    ),
    Board(
        id: "610cf9e03b0f5a001e865353",
        title: "Internships & Careers",
        description: "Career tips, internships, and job search discussions",
        symbolColor: "#2980B9", // Dark Blue color
        systemImageName: "briefcase.fill",
        user: sampleUsers[6]
    )
]
