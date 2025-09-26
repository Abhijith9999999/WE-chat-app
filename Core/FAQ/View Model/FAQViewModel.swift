//
//  FAQViewModel.swift
//  We
//
//

import SwiftUI

class FAQViewModel: ObservableObject {
    @Published var faqs: [FAQ] = []
    
    init() {
        loadFAQs()
    }
    
    func loadFAQs() {
        self.faqs = [
            FAQ(question: "How do I create an account?", answer: "To create an account, use your university email ID. A verification code will be sent to your email, and once entered, your account will be created. Remember, we hash, salt, and encrypt your email for security purposes."),
            FAQ(question: "Can I create multiple accounts with the same email?", answer: "Yes, you can use the same university email to create multiple accounts. This is to maintain anonymity, and each account will have separate data and posts."),
            FAQ(question: "Why isn't there a 'forgot password' option?", answer: "We do not offer a 'forgot password' option to maintain security. Once an account is created, we do not store email data in a retrievable format."),
            FAQ(question: "What type of posts are allowed?", answer: "The platform is a space for students to express themselves freely. However, harassment, hate speech, or any form of discrimination will not be tolerated and can lead to account suspension."),
            FAQ(question: "What boards can I post on?", answer: "Each university has specific boards. You can post on your university boards and the general board. Please respect the rules of each board."),
            FAQ(question: "Can the university see my posts or account?", answer: "No, due to encryption and hashing, the university cannot link any specific email to an account. They can only see general activity, not the identity of users.")
        ]
    }
}
