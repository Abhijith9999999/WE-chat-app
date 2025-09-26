//
//  CreatePostViewModel.swift
//  We
//
//

import Foundation
import Combine
import UIKit

class CreatePostViewModel: ObservableObject {
    @Published var selectedBoard: Board?
    @Published var username: String = ""
    @Published var subject: String = ""
    @Published var content: String = ""
    @Published var isSubmitting: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var selectedImage: UIImage? // <-- Add this line

    init(selectedBoard: Board? = nil, username: String? = nil) {
        self.selectedBoard = selectedBoard
        self.username = username ?? ""
    }

    func validateFields() -> Bool {
        guard !subject.isEmpty, !content.isEmpty, selectedBoard != nil else {
            alertMessage = "All fields must be filled and a board selected."
            showAlert = true
            return false
        }
        return true
    }

    func createPost(completion: @escaping () -> Void) {
        guard let board = selectedBoard else {
            self.alertMessage = "Please select a board."
            self.showAlert = true
            return
        }

        self.isSubmitting = true

        // Prepare the data to send
        let title = self.subject
        let content = self.content
        let boardId = board.id
        let username = self.username

        // Now call the createPost function in the service layer
        PostService.shared.createPost(username: username, title: title, content: content, boardId: boardId, image: selectedImage) { result in
            DispatchQueue.main.async {
                self.isSubmitting = false
                switch result {
                case .success(_):
                    // Post created successfully
                    completion()
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
