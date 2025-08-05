

import SwiftUI
import SwiftData
import goplaysdk
enum GoPlaySample: Error {
    case selectLogin
    case userInfo
//    case updateUserInfo
}
struct ContentView: View {
    
    @StateObject private var navigationManager = NavigationManager()
//    @State private var loginDone: Bool = false
    @State private var state : GoPlaySample = GoPlaySample.selectLogin
    @State private var userLogin: GoPlaySession?
    init() {
            // Initialize anything here if needed
        
        }
    var body: some View {
        //NavigationStack(path: $navigationManager.path)
        VStack(spacing: 0) {
            //HeaderView()
            switch(state){
            case .selectLogin:
                MainView()
            case .userInfo:
                userInfoView()
            }
         
        }
        
        .onAppear {
            GenericObserver.shared.observePublisher(
                publisher: AuthManager.shared.loginResultPublisher.eraseToAnyPublisher(),
                id: GoPlayAction.loginResult
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        self.userLogin = user
                        self.state = GoPlaySample.userInfo
//                        navigationManager.popToRoot()
                        print("Login succeeded for user: \(userLogin?.userName ?? "")")
                        
                    case .failure(let error):
                        print("Login failed with error: \(error)")
                        // Handle login error
                    }
                }
                
            }
            //update profile info
            GenericObserver.shared.observePublisher(
                publisher: AuthManager.shared.updateProfilePublisher.eraseToAnyPublisher(),
                id: GoPlayAction.openUpdateProfile
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        self.userLogin = user
                        self.state = GoPlaySample.userInfo
//                        navigationManager.popToRoot()
                        print("update profile: \(userLogin?.userName ?? "")")
                        
                    case .failure(let error):
                        print("Login failed with error: \(error)")
                        // Handle login error
                    }
                }
                
            }
        }
        .onDisappear {
            GenericObserver.shared.cancelSubscriptionByID(for: "loginResult")
        }
        
    }
    
    func userInfoView() -> some View {
            NavigationStack {
                List {
                    if let userLogin = userLogin {
                        Text("Tài khoản: \(userLogin.userName ?? "No User Name")")
                            .font(.system(size: 16))
                            .padding(.vertical, 12)
                        
                        Text("ID: \(userLogin.userId)")
                            .font(.system(size: 16))
                            .padding(.vertical, 12)
                            .autocapitalization(.none)
                        Text("Token: \(userLogin.accessToken ?? "No Access Token")")
                            .font(.system(size: 16))
                            .padding(.vertical, 12)
                            .autocapitalization(.none)
                        
                        GoButton(
                            text: "Change Account",
                            color: .white,
                            borderColor: .gray.opacity(0.75),
                            textColor: .black,
//                            iconName: "images/ic_user_focused",
//                            isSystemIcon: false,
                            iconSize: 24,
                            action:{ state = GoPlaySample.selectLogin}
                        )
                        GoNavigationLink(
                            text: "Update Account",
                            destination: GuestLoginUpdateProfileView(),
//                            systemImageName: "phone.fill",
                            imageSize: CGSize(width: 16, height: 16),
                            font: .system(size: 16, weight: .semibold),
                            textColor: .black,
                            backgroundColor: .white
                        )
                        
                    } else {
                        Text("Loading...")
                            .font(.system(size: 16))
                            .padding(.vertical, 12)
                    }
                }
                .padding()
            }
        }
    
}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
