//
//  MyBoardsViewModel.swift
//  We
//
//

import Foundation
import Combine

class MyBoardsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var userBoards: [Board] = []
    @Published var isLoadingUserBoards: Bool = false
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

    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        fetchUserBoards()
    }
    
    // MARK: - Fetch User Boards
    
    func fetchUserBoards() {
        isLoadingUserBoards = true
        errorMessage = nil
        showAlert = false

        BoardService.shared.fetchUserBoards { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingUserBoards = false
                switch result {
                case .success(let boards):
                    self?.userBoards = boards
                    self?.filterBoards()
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
            filteredBoards = userBoards
        } else {
            filteredBoards = userBoards.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
