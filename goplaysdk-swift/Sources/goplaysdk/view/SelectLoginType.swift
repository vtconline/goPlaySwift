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
                NavigationLink(destination: GoIdAuthenView()) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Phone Login")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width/2)
                    .background(AppTheme.Colors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                NavigationLink(destination: GoIdAuthenView()) {
                    HStack {
                        Image(systemName: "person.fill")
                        Text("GoID")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width/2)
                    .background(AppTheme.Colors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                Text(responseMessage)
                .padding()
                .background(Color.white)
            }
            .padding()
            .background(Color.white)
            .foregroundColor(.white)
        }
    }
    
    func loginTest(){
//        let requestBody: [String: Any] = [
//                            "username": "john_doe",
//                            "password": "password123"
//                        ]
//
//                        ApiService.shared.request(method: "POST", path: "/login", body: requestBody) { result in
//                            switch result {
//                            case .success(let data):
//                                // Convert response data to string for display
//                                if let responseString = String(data: data, encoding: .utf8) {
//                                    DispatchQueue.main.async {
//                                        responseMessage = "POST Response: \(responseString)"
//                                    }
//                                }
//                            case .failure(let error):
//                                DispatchQueue.main.async {
//                                    responseMessage = "Error: \(error.localizedDescription)"
//                                }
//                            }
//                        }
//    }
}

