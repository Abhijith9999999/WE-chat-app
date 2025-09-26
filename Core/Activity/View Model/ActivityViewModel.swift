//
//  ActivityViewModel.swift
//  We
//
//

import Foundation
import Combine

class ActivityViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var userPosts: [Post] = []
    @Published var userReplies: [Post] = []
    @Published var userUpvotedPosts: [Post] = []
    @Published var userDownvotedPosts: [Post] = []
    
    @Published var isLoadingUserPosts: Bool = false
    @Published var isLoadingUserReplies: Bool = false
    @Published var isLoadingUserUpvotedPosts: Bool = false
    @Published var isLoadingUserDownvotedPosts: Bool = false
    
    @Published var errorMessage: String?
    
    // MARK: - Methods for Fetching Data
    
    func fetchUserPosts(userId: String) {
        isLoadingUserPosts = true
        errorMessage = nil
        
        UserService.shared.fetchUserPosts(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingUserPosts = false
                switch result {
                case .success(let posts):
                    self?.userPosts = posts
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchUserReplies(userId: String) {
        isLoadingUserReplies = true
        errorMessage = nil
        
        UserService.shared.fetchUserReplies(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingUserReplies = false
                switch result {
                case .success(let replies):
                    self?.userReplies = replies
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchUserUpvotedPosts(userId: String) {
        isLoadingUserUpvotedPosts = true
        errorMessage = nil
        
        UserService.shared.fetchUserUpvotes(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingUserUpvotedPosts = false
                switch result {
                case .success(let posts):
                    self?.userUpvotedPosts = posts
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchUserDownvotedPosts(userId: String) {
        isLoadingUserDownvotedPosts = true
        errorMessage = nil
        
        UserService.shared.fetchUserDownvotes(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingUserDownvotedPosts = false
                switch result {
                case .success(let posts):
                    self?.userDownvotedPosts = posts
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
