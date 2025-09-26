//
//  BoardService.swift
//  We
//
//

import Foundation

class BoardService: BaseService {
    static let shared = BoardService()
    private override init() {}
    
    // MARK: - Create Board
    
    /// Creates a new board.
    func createBoard(title: String, description: String, symbolColor: String, systemImageName: String, completion: @escaping (Result<Board, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/create") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
            "title": title,
            "description": description,
            "symbolColor": symbolColor,
            "systemImageName": systemImageName
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
                // Parse the Board object from the response
                do {
                    if let data = data {
                        let board = try JSONDecoder().decode(Board.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(board))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Update Board
    
    /// Updates a board with the given boardId and new details.
    func updateBoard(boardId: String, title: String, description: String, symbolColor: String, systemImageName: String, completion: @escaping (Result<Board, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/\(boardId)") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(ServiceError.noAccessToken))
            return
        }
        
        // Prepare the request body
        let body: [String: Any] = [
            "title": title,
            "description": description,
            "symbolColor": symbolColor,
            "systemImageName": systemImageName
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
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
                // Parse the updated Board object from the response
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let updatedBoard = try decoder.decode(Board.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(updatedBoard))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch All Boards
    
    /// Fetches all available boards.
    func fetchAllBoards(completion: @escaping (Result<[Board], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include access token if required
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
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
                // Parse the array of Board objects from the response
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let boards = try decoder.decode([Board].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(boards))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Boards Created by User
    
    /// Fetches the boards created by the authenticated user.
    func fetchUserBoards(completion: @escaping (Result<[Board], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/myboards") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(ServiceError.noAccessToken))
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
                // Parse the array of Board objects from the response
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let boards = try decoder.decode([Board].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(boards))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Toggle Follow Board

    /// Toggles following or unfollowing a board with the given boardId.
    func toggleFollowBoard(boardId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/\(boardId)/toggleFollow") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(ServiceError.noAccessToken))
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

            // Handle server response
            if (200...299).contains(httpResponse.statusCode) {
                // Parse the message from the response
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let message = json["message"] as? String {
                            DispatchQueue.main.async {
                                completion(.success(message))
                            }
                        } else {
                            completion(.failure(ServiceError.invalidData))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(ServiceError.noData))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // Add this method to BoardService
    func isBoardFollowedByUser(boardId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/\(boardId)/isFollowed") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(ServiceError.noAccessToken))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ServiceError.invalidResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode), let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let isFollowed = json["isFollowed"] as? Bool {
                        DispatchQueue.main.async {
                            completion(.success(isFollowed))
                        }
                    } else {
                        completion(.failure(ServiceError.invalidData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Followed Boards
    
    /// Fetches the boards followed by the authenticated user.
    func fetchFollowedBoards(completion: @escaping (Result<[Board], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/following") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(ServiceError.noAccessToken))
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
                // Parse the array of Board objects from the response
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let boards = try decoder.decode([Board].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(boards))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Board by ID
    
    /// Fetches a specific board by its ID.
    func fetchBoardById(boardId: String, completion: @escaping (Result<Board, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/\(boardId)") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include the access token in the Authorization header if required
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
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
                // Parse the Board object from the response
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let board = try decoder.decode(Board.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(board))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Board Posts
    
    /// Fetches posts from a specific board by its ID.
    func fetchBoardPosts(for boardId: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/board/\(boardId)") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(ServiceError.noAccessToken))
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
                // Parse the Post array from the response
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(customISO8601Formatter)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let posts = try decoder.decode([Post].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(posts))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
}
