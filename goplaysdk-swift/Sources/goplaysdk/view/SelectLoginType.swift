//
//  Authen.swift
//  goplaysdk
//
//  Created by Ngô Đồng on 17/4/25.
//
// Sources/LoginSDK/LoginView.swift

import SwiftUI

public struct SelectLoginType: View {
    @State private var responseMessage: String = ""
    public init() {}

    public var body: some View {
        VStack(spacing: 20) {
                    Button("PhoneLogin") {
                        print("PhoneLogin")
                    }
                    .frame(width: UIScreen.main.bounds.width/3)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("GoID") {
                        loginTest()
                    }
                    .frame(width: UIScreen.main.bounds.width/3)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            
                    Text(responseMessage)
                            .padding()
                            .background(Color.gray.opacity(0.2))
        }
        
        .padding()
    }
    
    func loginTest(){
        let requestBody: [String: Any] = [
                            "username": "john_doe",
                            "password": "password123"
                        ]
                        
                        ApiService.shared.request(method: "POST", path: "/login", body: requestBody) { result in
                            switch result {
                            case .success(let data):
                                // Convert response data to string for display
                                if let responseString = String(data: data, encoding: .utf8) {
                                    DispatchQueue.main.async {
                                        responseMessage = "POST Response: \(responseString)"
                                    }
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    responseMessage = "Error: \(error.localizedDescription)"
                                }
                            }
                        }
    }
}

