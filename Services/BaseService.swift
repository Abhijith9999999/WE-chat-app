//
//  BaseService.swift
//  We
//
//

import Foundation
import Security

class BaseService {
    // Base URL of your backend API
    let baseURL = "http://192.168.5.92:5500/api"
    
    // Keychain keys
    let accessTokenKey = "accessToken"
    let refreshTokenKey = "refreshToken"
    
    // MARK: - Token Management
    
    /// Saves a token to the Keychain.
    func saveToken(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary) // Delete any existing items
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func getToken(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        }
        
        return nil
    }
    
    func deleteToken(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    func getAccessToken() -> String? {
        return getToken(key: accessTokenKey)
    }
    
    /// Checks if the user is logged in by verifying the presence of the access token.
    func isLoggedIn() -> Bool {
        return getToken(key: accessTokenKey) != nil
    }
    
    // MARK: - Helper Methods
    
    /// Parses error messages from the server response.
    func parseErrorMessage(data: Data?) -> String {
        guard let data = data else { return "Unknown error occurred." }
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errorMessage = json["error"] as? String {
                return errorMessage
            } else {
                return "Unknown error occurred."
            }
        } catch {
            return "Unknown error occurred."
        }
    }
    
    /// Clears all cookies from the shared HTTPCookieStorage.
    func clearCookies() {
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                cookieStorage.deleteCookie(cookie)
            }
        }
    }
    
    // MARK: - Error Types
    
    enum ServiceError: LocalizedError {
        case invalidURL
        case invalidResponse
        case invalidData
        case noData
        case serverError(message: String)
        case noAccessToken
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The URL is invalid."
            case .invalidResponse:
                return "Invalid response from the server."
            case .invalidData:
                return "Invalid data received from the server."
            case .noData:
                return "No data received from the server."
            case .serverError(let message):
                return message
            case .noAccessToken:
                return "No access token found. Please log in."
            }
        }
    }
}
