//
//  AllBoardsViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 11/9/24.
//

import Foundation
import Combine

class AllBoardsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var allBoards: [Board] = []
    @Published var isLoadingAllBoards: Bool = false
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
        fetchAllBoards()
    }
    
    // MARK: - Fetch All Boards
    
    func fetchAllBoards() {
        isLoadingAllBoards = true
        errorMessage = nil
        showAlert = false

        BoardService.shared.fetchAllBoards { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingAllBoards = false
                switch result {
                case .success(let boards):
                    self?.allBoards = boards
                    self?.filterBoards()  // Apply filtering after fetching data
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
            filteredBoards = allBoards
        } else {
            filteredBoards = allBoards.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
