//
//  AccountViewModel.swift
//  We
//
//

import Foundation
import Combine

class AccountViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false

    // MARK: - Methods

    /// Fetches the current authenticated user.
    func fetchCurrentUser() {
        errorMessage = nil
        
        UserService.shared.fetchCurrentUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.currentUser = user
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Logs out the user by clearing tokens and updating the login status.
    func logout() {
        AuthService.shared.logout()
        self.currentUser = nil
    }
    
    /// Checks if the current user has admin or moderator role.
    var isAdminOrModerator: Bool {
        guard let role = currentUser?.role else { return false }
        return role.lowercased() == "admin" || role.lowercased() == "moderator"
    }
}
