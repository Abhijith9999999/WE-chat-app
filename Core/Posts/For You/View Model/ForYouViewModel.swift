//
//  ForYouViewModel.swift
//  We
//
//

import Foundation
import Combine

class ForYouViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var forYouPosts: [Post] = []
    @Published var isLoadingForYouPosts: Bool = false
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

    // MARK: - Fetch For You Posts
    func fetchForYouPosts() {
        guard !isLoadingForYouPosts && hasMorePosts else { return }

        isLoadingForYouPosts = true
        errorMessage = nil
        showAlert = false

        postService.fetchForYouPosts(page: currentPage, limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingForYouPosts = false
                self.lastUpdated = Date() // Set last updated time
                switch result {
                case .success(let posts):
                    if posts.count < self.limit {
                        self.hasMorePosts = false
                    }
                    self.forYouPosts.append(contentsOf: posts)
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
        forYouPosts.removeAll()
        fetchForYouPosts()
    }
}
