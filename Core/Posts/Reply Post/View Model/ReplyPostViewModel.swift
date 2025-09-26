//
//  ReplyPostViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 11/14/24.
//

import SwiftUI
import Combine

class ReplyPostViewModel: ObservableObject {    
    @Published var username: String = ""
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var isReplying: Bool = false
    @Published var showAlert: Bool = false
    @Published var errorMessage: String?
    
    private let postService = PostService.shared
    
    func replyToPost(postId: String, completion: @escaping (Bool) -> Void) {
        isReplying = true
        postService.replyToPost(postId: postId, username: username, title: title, content: content) { result in
            DispatchQueue.main.async {
                self.isReplying = false
                switch result {
                case .success(_):
                    completion(true)
                case .failure(let error):
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
}
