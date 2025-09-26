//
//  Post.swift
//  We
//
//

import Foundation

struct Post: Identifiable, Codable, Equatable {
    var id: String
    var title: String
    var content: String
    var user: User
    var username: String
    var parentPost: String?
    var path: String
    var upvoteCount: Int
    var downvoteCount: Int
    var commentCount: Int
    var viewCount: Int
    var board: Board
    var createdAt: Date
    var updatedAt: Date
    var image: String? // Optional image URL

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case content
        case user
        case username
        case parentPost
        case path
        case upvoteCount
        case downvoteCount
        case commentCount
        case viewCount
        case board
        case createdAt
        case updatedAt
        case image // Add image to coding keys
    }
    
    func lhs (_ lhs: Post, _ rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}

// Sample Post data with User and Board objects
let samplePosts: [Post] = [
    Post(
        id: "620cde403b1f1b002e865a4c",
        title: "Tips for Freshmen?",
        content: "Starting college can be overwhelming, and I'm sure many of us have been there. Any veterans out there willing to share some valuable tips, tricks, or even common pitfalls to avoid during the first year? Anything from study tips, best coffee spots, to dealing with homesickness would be appreciated!",
        user: sampleUsers[1],
        username: "@SophomoreGuide",
        parentPost: nil,
        path: ",",
        upvoteCount: 950,
        downvoteCount: 15,
        commentCount: 80,
        viewCount: 500,
        board: sampleBoards[1],
        createdAt: Date(),
        updatedAt: Date(),
        image: nil // No image for this post
    ),
    Post(
        id: "630cda503b0f5a001f865b4c",
        title: "Late Night Eats",
        content: "It's midnight and you just finished a grueling study session. You're hungry, but unsure where to go. Let's compile a list of the best places to grab some food late at night, whether on campus or within a short drive. Bonus points for 24/7 options!",
        user: sampleUsers[2],
        username: "@NightOwl",
        parentPost: "nil",
        path: ",",
        upvoteCount: 780,
        downvoteCount: 5,
        commentCount: 45,
        viewCount: 300,
        board: sampleBoards[2],
        createdAt: Date(),
        updatedAt: Date(),
        image: "https://www.tamucc.edu/images/icons/home-social-2.jpg" // No image for this post
    ),
    Post(
        id: "640cda603b0f5a002e865c4d",
        title: "Exam Prep Groups",
        content: "Exams are around the corner and it's crunch time. I'm looking to join or start a study group for BIO101, CHEM201, and MATH350. If you're interested or know any existing groups, please reach out. Sharing resources, tips, and mutual support can make a big difference!",
        user: sampleUsers[3],
        username: "@ExamAce",
        parentPost: nil,
        path: ",",
        upvoteCount: 600,
        downvoteCount: 10,
        commentCount: 50,
        viewCount: 800,
        board: sampleBoards[3],
        createdAt: Date(),
        updatedAt: Date(),
        image: "https://res.cloudinary.com/de0b2myhz/image/upload/v1731766810/ckodjjb0wabajzdzyrs7.png" // No image for this post
    ),
    Post(
        id: "650cda703b0f5a003e865d4e",
        title: "Gym Partners",
        content: "Getting in shape isn't easy, and it's often more fun and effective with a partner. I'm at the campus gym every morning at 7 AM sharp. Looking for someone to join me for regular workouts. We can help keep each other motivated and accountable!",
        user: sampleUsers[4],
        username: "@FitFam",
        parentPost: nil,
        path: ",",
        upvoteCount: 320,
        downvoteCount: 2,
        commentCount: 30,
        viewCount: 200,
        board: sampleBoards[4],
        createdAt: Date(),
        updatedAt: Date(),
        image: nil // No image for this post
    ),
    // You can add more posts with similar expanded content for greater realism and engagement
]
