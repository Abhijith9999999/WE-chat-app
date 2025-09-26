//
//  EditBoardViewModel.swift
//  We
//
//

import Foundation

class EditBoardViewModel: ObservableObject {
    @Published var title: String
    @Published var description: String
    @Published var symbolColor: String
    @Published var systemImageName: String
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let boardId: String

    init(boardId: String, title: String, description: String, symbolColor: String, systemImageName: String) {
        self.boardId = boardId
        self.title = title
        self.description = description
        self.symbolColor = symbolColor
        self.systemImageName = systemImageName
    }

    func updateBoard(completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        BoardService.shared.updateBoard(
            boardId: boardId,
            title: title,
            description: description,
            symbolColor: symbolColor,
            systemImageName: systemImageName
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(_):
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
}
