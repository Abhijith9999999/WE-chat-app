//
//  FollowingPostsViewModel.swift
//  We
//
//

import Foundation
import Combine

class FollowingPostsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var followingPosts: [Post] = []
    @Published var isLoadingFollowingPosts: Bool = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var lastUpdated: Date?
    @Published var hasMorePosts: Bool = true // To track if more posts are available

    private let postService = PostService.shared
    private var currentPage: Int = 1
    private let limit: Int = 10

    // MARK: - Computed Property for Last Updated Text
    var lastUpdatedText: String {
        return lastUpdated?.timeAgo ?? "Updated a long time ago"
    }

    // MARK: - Fetch Following Posts
    func fetchFollowingPosts() {
        guard !isLoadingFollowingPosts && hasMorePosts else { return }

        isLoadingFollowingPosts = true
        errorMessage = nil
        showAlert = false

        postService.fetchFollowingPosts(page: currentPage, limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingFollowingPosts = false
                self.lastUpdated = Date() // Set last updated time
                switch result {
                case .success(let posts):
                    if posts.count < self.limit {
                        self.hasMorePosts = false
                    }
                    self.followingPosts.append(contentsOf: posts)
                    self.currentPage += 1
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }

    // MARK: - Refresh Posts
    func refreshPosts() {
        currentPage = 1
        hasMorePosts = true
        followingPosts.removeAll()
        fetchFollowingPosts()
    }
}
