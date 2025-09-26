//
//  BookmarksViewModel.swift
//  We
//
//

import Foundation
import SwiftUI

class BookmarksViewModel: ObservableObject {
    @Published var bookmarkPosts: [Post] = []
    @Published var isLoadingBookmarkPosts: Bool = false
    @Published var lastUpdated: Date?
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    
    private let postService = PostService.shared
    
    // MARK: - Computed Property for Last Updated Text
    var lastUpdatedText: String {
        return lastUpdated?.timeAgo ?? "Updated a long time ago"
    }
    
    /// Fetches bookmarked posts for the user.
    func fetchBookmarkPosts() {
        isLoadingBookmarkPosts = true
        errorMessage = nil
        
        postService.fetchBookmarkPosts { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingBookmarkPosts = false
                self?.lastUpdated = Date() // Set last updated time
                switch result {
                case .success(let posts):
                    self?.bookmarkPosts = posts
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
}
