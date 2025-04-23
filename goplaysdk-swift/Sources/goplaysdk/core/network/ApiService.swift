//
//  ApiService.swift
//  goplaysdk
//
//  Created by Ngô Đồng on 23/4/25.
//

// ApiService.swift

import Foundation
@MainActor
class ApiService {
    // Step 1: Base URL constant
    private let baseURL = "https://api.example.com"
    
    // Step 2: Shared instance for singleton pattern
    static let shared = ApiService()
    
    // Step 3: Private initializer to prevent instantiation
    private init() {}
    
    // Step 4: Generic function for GET and POST requests
    func request(
        method: String, // GET or POST
        path: String,   // Specific API endpoint path
        body: [String: Any]? = nil, // Optional request body for POST requests
        completion: @escaping (Result<Data, Error>) -> Void // Completion callback
    ) {
        // Construct the full URL by appending the path to the base URL
        guard let url = URL(string: "\(baseURL)\(path)") else {
            print("Invalid URL")
            return
        }
        
        // Create a URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // If the method is POST and we have a body, encode it
        if method == "POST", let bodyData = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: bodyData, options: [])
                request.httpBody = jsonData
            } catch {
                print("Error encoding body data: \(error)")
                return
            }
        }
        
        // Step 5: Make the network request using URLSession
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check if data is available and return it
            if let data = data {
                completion(.success(data))
            } else {
                // Handle case where no data is returned
                let error = NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                completion(.failure(error))
            }
        }
        
        // Start the network request
        task.resume()
    }
}
