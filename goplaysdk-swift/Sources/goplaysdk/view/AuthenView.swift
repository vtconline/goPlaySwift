//
//  Authen.swift
//  goplaysdk
//
//  Created by Ngô Đồng on 17/4/25.
//
// Sources/LoginSDK/LoginView.swift

import SwiftUI

public struct AuthenView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 20) {
            Text("Login222")
                .font(.largeTitle)

            TextField("Email", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Log In") {
                // Login logic here
            }
            .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            
        }
        .padding()
    }
}

