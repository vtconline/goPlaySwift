//
//  Authen.swift
//  goplaysdk
//
//  Created by Ngô Đồng on 17/4/25.
//
// Sources/LoginSDK/LoginView.swift

import SwiftUI

public struct GoIdAuthenView: View {
    // Accessing the presentation mode to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var navigationManager = NavigationManager()
    
    @State private var username = ""  // Store the username
    @State private var password = ""  // Store the password
    
    @State private var usernameFocus = false
    @State private var passwordFocus = false
    
    
    @State private var rememberMe = true  // 🔐 Toggle for remembering credentials
    
    @StateObject private var usernameValidator = UsernameValidator()
    @StateObject private var pwdValidator = PasswordValidator()
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .center, spacing: 20 ) {
           
            GoTextField<UsernameValidator>(text: $username, placeholder:"Tên đăng nhập", isPwd: false, validator: usernameValidator,leftIconName: "images/ic_user_focused",  // This should be the name of your image in Resources/Images
                                           isSystemIcon: false,
                                           //                                           keyBoardFocused: $usernameFocus
            )
            .keyboardType(.asciiCapable)
            
            GoTextField<PasswordValidator>(
                text: $password,
                placeholder: "Enter Password",
                isPwd: true,
                validator: pwdValidator,
                leftIconName: "images/ic_lock_focused",  // This should be the name of your image in Resources/Images
                isSystemIcon: false,
                //                keyBoardFocused: $passwordFocus
            )
            .keyboardType(.default)
            
            Toggle("Ghi nhớ đăng nhập", isOn: $rememberMe)
//                .padding(.horizontal, 32)
                .frame(maxWidth: min(
                    UIScreen.main.bounds.width - 2 * AppTheme.Paddings.horizontal,
                    300
                ), alignment: .center)
            
            GoButton(text: "Đăng nhập", action:{
                let validation = usernameValidator.validate(text: username)
                let validationPwd = pwdValidator.validate(text: password)
                if(validation.isValid == false || validationPwd.isValid == false){
                    //                    usernameFocus = true
                    return
                }
                if rememberMe {
                    UserDefaults.standard.set(username, forKey: "savedUsername")
                    if let pwdData = password.data(using: .utf8) {
                        KeychainHelper.save(key: "savedPassword", data: pwdData)
                    }
                }
                
            }
            )
            
            // HStack for buttons in a row
            // HStack for buttons in a row, centered horizontally
            HStack(spacing: 10) {
                // Register Button using NavigationLink
                NavigationLink(destination: RegisterView()) {
                    Text("Đăng ký")
                        .foregroundColor(.blue)  // Text color for the text button
                        .padding(.horizontal, 10) // Horizontal padding for the button
                }
                
                // Forgot Password Button using NavigationLink
                NavigationLink(destination: ForgotPasswordView()) {
                    Text("Quên mật khẩu?")
                        .foregroundColor(.blue)  // Text color for the text button
                        .padding(.horizontal, 10) // Horizontal padding for the button
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)  // Center the buttons horizontally
            .padding(.top, 10) // Space between login and buttons in row
            
        }
        .padding()
        .onAppear {
            if let savedUsername = UserDefaults.standard.string(forKey: "savedUsername") {
                username = savedUsername
            }
            if let pwdData = KeychainHelper.load(key: "savedPassword"),
               let pwd = String(data: pwdData, encoding: .utf8) {
                password = pwd
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) //topLeading
        .background(Color.white)
        .observeOrientation()
        .navigateToDestination(navigationManager: navigationManager)  // Using the extension method
        .resetNavigationWhenInActive(navigationManager: navigationManager, scenePhase: scenePhase)
        .navigationTitle("Đăng nhập GoID")
        //                .navigationBarBackButtonHidden(false) // Show back button (default)
        
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Quay lại") // ← Custom back button text
                    }
                }
            }
        }
    }
}

