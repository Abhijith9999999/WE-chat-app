//
//  FollowedBoardsViewModel.swift
//  We
//
//

import Foundation
import Combine

class FollowedBoardsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var followedBoards: [Board] = []
    @Published var isLoadingFollowedBoards: Bool = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var searchText: String = "" {
        didSet {
            filterBoards()
        }
    }
    @Published private(set) var filteredBoards: [Board] = []

    private var authViewModel: AuthViewModel
    private var cancellables = Set<AnyCancellable>()

    // Initialize with AuthViewModel to access user authentication context if needed
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        fetchFollowedBoards()
    }
    
    // MARK: - Fetch Followed Boards
    
    func fetchFollowedBoards() {
        isLoadingFollowedBoards = true
        errorMessage = nil
        showAlert = false

        BoardService.shared.fetchFollowedBoards { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingFollowedBoards = false
                switch result {
                case .success(let boards):
                    self?.followedBoards = boards
                    self?.filterBoards()  // Filter after fetching data
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
    
    // MARK: - Toggle Follow Board
    
    func toggleFollowBoard(boardId: String) {
        BoardService.shared.toggleFollowBoard(boardId: boardId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.fetchFollowedBoards()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
    
    // MARK: - Filter Boards

    private func filterBoards() {
        if searchText.isEmpty {
            filteredBoards = followedBoards
        } else {
            filteredBoards = followedBoards.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
