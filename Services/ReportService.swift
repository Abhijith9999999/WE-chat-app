//
//  ReportService.swift
//  We
//
//

import Foundation

class ReportService: BaseService {
    static let shared = ReportService()
    private override init() {}
    
    // MARK: - Report Post
    /// Reports a post with a specified reason.
    func reportPost(postId: String, reason: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/reports/posts/\(postId)/report") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(ServiceError.noAccessToken))
            return
        }
        
        let body: [String: Any] = ["reason": reason]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
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
            
            if (200...299).contains(httpResponse.statusCode) {
                completion(.success("Report submitted successfully"))
            } else {
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
}
