//
//  AuthViewModel.swift
//  We
//
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var currentUser: User?
    @Published var isUsernameUpdated: Bool = false
    
    // Registration properties
    @Published var emailAddress: String = ""
    @Published var verificationCode: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isCodeSent: Bool = false
    @Published var isAccountCreated: Bool = false
    
    // Login properties
    @Published var loginEmail: String = ""
    @Published var loginUsername: String = ""
    @Published var loginPassword: String = ""
    @Published var isLoggedIn: Bool = false
    
    // MARK: - Change Password Properties
    
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var isPasswordChangeSuccessful: Bool = false
    
    // MARK: - All Boards
    
    @Published var allBoards: [Board] = []
    @Published var isLoadingAllBoards: Bool = false
    
    // MARK: - Boards Created by User
    
    @Published var userBoards: [Board] = []
    @Published var isLoadingBoards: Bool = false
    
    // MARK: - Followed Boards
    
    @Published var followedBoards: [Board] = []
    @Published var isLoadingFollowedBoards: Bool = false
    @Published var isTogglingFollow: Bool = false
    
    // MARK: - Selected Board
    
    @Published var selectedBoard: Board?
    @Published var isLoadingSelectedBoard: Bool = false
    @Published var boardErrorMessage: String?
    
    // MARK: - Following Posts
    
    @Published var followingPosts: [Post] = []
    @Published var isLoadingFollowingPosts: Bool = false

    // MARK: - Board Posts
    
    @Published var boardPosts: [Post] = []
    @Published var isLoadingBoardPosts: Bool = false

    // Common properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    
    // MARK: - Validation Properties
    
    // Registration validation
    var isEmailValid: Bool {
        // Validate email ending with @islander.tamucc.edu
        let emailRegex = "^[A-Z0-9a-z._%+-]+@islander\\.tamucc\\.edu$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: emailAddress)
    }
    
    var isVerificationCodeValid: Bool {
        let codeRegex = "^[0-9]{6}$"
        let codePredicate = NSPredicate(format: "SELF MATCHES %@", codeRegex)
        return codePredicate.evaluate(with: verificationCode)
    }
    
    var isUsernameValid: Bool {
        return username.count >= 4
    }
    
    var isPasswordValid: Bool {
        // Password must be at least 8 characters, with at least one uppercase, one lowercase, one number, and one special character
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#$@!%&*?])[A-Za-z\\d#$@!%&*?]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    var doPasswordsMatch: Bool {
        return password == confirmPassword
    }
    
    var isRegisterButtonDisabled: Bool {
        return isLoading || !isVerificationCodeValid || !isUsernameValid || !isPasswordValid || !doPasswordsMatch
    }
    
    // Login validation
    var isLoginEmailValid: Bool {
        // Validate email ending with @islander.tamucc.edu
        let emailRegex = "^[A-Z0-9a-z._%+-]+@islander\\.tamucc\\.edu$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: loginEmail)
    }
    
    var isLoginButtonDisabled: Bool {
        return isLoading || !isLoginEmailValid || loginUsername.isEmpty || loginPassword.isEmpty
    }
    
    // Send code button disabled state
    var isSendCodeButtonDisabled: Bool {
        return isLoading || !isEmailValid
    }
    
    
    /// Validates the new password.
    var isNewPasswordValid: Bool {
        // Use your existing password validation logic
        return isPasswordValid(newPassword)
    }
    
    /// Checks if the change password button should be disabled.
    var isChangePasswordButtonDisabled: Bool {
        return isLoading ||
        currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty ||
        newPassword != confirmPassword ||
        !isNewPasswordValid
    }
    
    // MARK: - Registration Methods
    
    /// Requests a verification code to be sent to the user's email.
    func requestVerificationCode() {
        // Ensure the email is valid before proceeding
        guard !isSendCodeButtonDisabled else { return }
        
        isLoading = true
        errorMessage = nil
        
        AuthService.shared.requestVerificationCode(email: emailAddress) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success():
                    self?.isCodeSent = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Registers a new user using the verification code, username, and password.
    func registerUser() {
        // Ensure inputs are valid before proceeding
        guard !isRegisterButtonDisabled else { return }
        
        isLoading = true
        errorMessage = nil
        
        AuthService.shared.registerUser(code: verificationCode, username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success():
                    self?.isAccountCreated = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Login Methods
    
    /// Logs in the user with the provided credentials.
    func loginUser() {
        // Ensure inputs are valid before proceeding
        guard !isLoginButtonDisabled else { return }
        
        isLoading = true
        errorMessage = nil
        
        AuthService.shared.login(email: loginEmail, username: loginUsername, password: loginPassword) { [weak self] success, errorMessage in
            DispatchQueue.main.async {
                self?.isLoading = false
                if success {
                    self?.isLoggedIn = true
                    // Clear login fields
                    self?.loginEmail = ""
                    self?.loginUsername = ""
                    self?.loginPassword = ""
                } else {
                    self?.errorMessage = errorMessage
                }
            }
        }
    }
    
    /// Checks if the user is logged in by verifying the presence of the access token.
    func checkLoginStatus() {
        isLoggedIn = AuthService.shared.isLoggedIn() && AuthService.shared.getAccessToken() != nil
    }
    
    /// Logs out the user by clearing tokens and updating the login status.
    func logout() {
        AuthService.shared.logout()
        isLoggedIn = false
    }
    
    /// Changes the user's password.
    func changePassword() {
        // Ensure inputs are valid before proceeding
        guard !isChangePasswordButtonDisabled else {
            self.errorMessage = "Please ensure all fields are filled, passwords match, and meet the criteria."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        AuthService.shared.changePassword(oldPassword: currentPassword, newPassword: newPassword) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success():
                    self?.isPasswordChangeSuccessful = true
                    self?.currentPassword = ""
                    self?.newPassword = ""
                    self?.confirmPassword = ""
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Fetches the current authenticated user.
    func fetchCurrentUser() {
        isLoading = true
        errorMessage = nil
        
        UserService.shared.fetchCurrentUser { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    self?.currentUser = user
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Update Username Method
    
    /// Updates the user's username.
    func updateUsername(newUsername: String) {
        isLoading = true
        errorMessage = nil
        
        UserService.shared.updateUsername(newUsername: newUsername) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success():
                    self?.currentUser?.username = newUsername
                    self?.isUsernameUpdated = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Fetch All Boards
    
    /// Fetches all available boards.
    func fetchAllBoards() {
        isLoadingAllBoards = true
        errorMessage = nil
        
        BoardService.shared.fetchAllBoards { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingAllBoards = false
                switch result {
                case .success(let boards):
                    self?.allBoards = boards
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
        
    // MARK: - Fetch Followed Boards
    
    func fetchFollowedBoards(completion: (() -> Void)? = nil) {
        isLoadingFollowedBoards = true
        errorMessage = nil

        BoardService.shared.fetchFollowedBoards { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingFollowedBoards = false
                switch result {
                case .success(let boards):
                    self?.followedBoards = boards
                    completion?()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion?()
                }
            }
        }
    }
    
    // MARK: - Fetch Board by ID
    
    /// Fetches a board by its ID.
    func fetchBoard(by id: String) {
        isLoadingSelectedBoard = true
        errorMessage = nil
        
        BoardService.shared.fetchBoardById(boardId: id) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingSelectedBoard = false
                switch result {
                case .success(let board):
                    self?.selectedBoard = board
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Toggle Follow Board

    /// Toggles following or unfollowing a board with the given boardId.
    func toggleFollowBoard(boardId: String) {
        isTogglingFollow = true
        errorMessage = nil

        BoardService.shared.toggleFollowBoard(boardId: boardId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isTogglingFollow = false
                switch result {
                case .success(let message):
                    // Update the followed boards list
                    self?.fetchFollowedBoards()
                    // Optionally, you can use the message to inform the user
                    print(message)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
            
    // MARK: - Fetch Board Posts
    func fetchBoardPosts(for boardId: String) {
        isLoadingBoardPosts = true
        errorMessage = nil
        
        BoardService.shared.fetchBoardPosts(for: boardId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingBoardPosts = false
                switch result {
                case .success(let posts):
                    self?.boardPosts = posts
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Existing password validation method
    func isPasswordValid(_ password: String) -> Bool {
        // Password validation logic (same as before)
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#$@!%&*?])[A-Za-z\\d#$@!%&*?]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    // MARK: - Helper Methods
    
    /// Resets registration properties.
    func resetRegistration() {
        emailAddress = ""
        verificationCode = ""
        username = ""
        password = ""
        isCodeSent = false
        isAccountCreated = false
        errorMessage = nil
    }
    
    /// Resets login properties.
    func resetLogin() {
        loginEmail = ""
        loginUsername = ""
        loginPassword = ""
        isLoggedIn = false
        errorMessage = nil
    }
}
