//
//  AuthService.swift
//  We
//

import Foundation
import Security

class AuthService: BaseService {
    static let shared = AuthService()
    private override init() {}
    
    // MARK: - Registration
    
    /// Requests a verification code to be sent to the user's email.
    func requestVerificationCode(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/requestverificationcode") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the request body
        let body: [String: String] = ["email": email]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Create the data task
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle networking errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ServiceError.invalidResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                // Success
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    /// Registers a new user using the verification code, username, and password.
    func registerUser(code: String, username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/register") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the request body
        let body: [String: String] = [
            "code": code,
            "username": username,
            "password": password
        ]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Create the data task
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle networking errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ServiceError.invalidResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                // Success
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Login
    
    /// Logs in the user with the provided credentials.
    func login(email: String, username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true // Ensure cookies are handled
        
        let body: [String: String] = [
            "email": email,
            "username": username,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(false, "Failed to encode request body")
            return
        }
        
        // Configure cookie storage
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.cookieAcceptPolicy = .always
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpCookieStorage = cookieStorage
        sessionConfig.httpShouldSetCookies = true
        
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Invalid response")
                return
            }
            
            if httpResponse.statusCode == 200 {
                // Extract tokens from cookies
                if let headers = httpResponse.allHeaderFields as? [String: String],
                   let url = request.url {
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
                    for cookie in cookies {
                        if cookie.name == "accessToken" {
                            _ = self.saveToken(key: "accessToken", value: cookie.value)
                        }
                        if cookie.name == "refreshToken" {
                            _ = self.saveToken(key: "refreshToken", value: cookie.value)
                        }
                    }
                }
                completion(true, nil)
            } else {
                let message = self.parseErrorMessage(data: data)
                completion(false, message)
            }
        }.resume()
    }
    
    // MARK: - Logout
    
    /// Logs out the user by clearing tokens and cookies.
    func logout() {
        // Delete tokens from Keychain
        deleteToken(key: accessTokenKey)
        deleteToken(key: refreshTokenKey)
        
        // Clear cookies
        clearCookies()
    }
    
    // MARK: - Change Password
    
    /// Changes the user's password.
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/change-password") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(ServiceError.noAccessToken))
            return
        }
        
        // Prepare the request body
        let body: [String: String] = [
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Configure the session
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpCookieStorage = HTTPCookieStorage.shared
        sessionConfig.httpShouldSetCookies = true
        let session = URLSession(configuration: sessionConfig)
        
        // Create the data task
        session.dataTask(with: request) { data, response, error in
            // Handle networking errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ServiceError.invalidResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                // Success
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
}
