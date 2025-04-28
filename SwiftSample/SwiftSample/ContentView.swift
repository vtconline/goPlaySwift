

import SwiftUI
import SwiftData
import goplaysdk
enum GoPlaySample: Error {
    case selectLogin
    case userInfo
    case updateUserInfo
}
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @StateObject private var navigationManager = NavigationManager()
//    @State private var loginDone: Bool = false
    @State private var state : GoPlaySample = GoPlaySample.selectLogin
    @State private var userLogin: GoPlaySession?
    init() {
            // Initialize anything here if needed
        }
    var body: some View {
        //NavigationStack(path: $navigationManager.path)
        NavigationStack(path: $navigationManager.path) {
            VStack(spacing: 0) {
                //HeaderView()
                switch(state){
                case .selectLogin:
                    MainView()
                case .userInfo:
                    userInfoView()
                case .updateUserInfo:
                    GuestLoginUpdateProfileView {
                        state = GoPlaySample.userInfo
                        // You can trigger any logic you want here, e.g., analytics, saving data, etc.
                    }
                }
             
            }
        }
        .navigateToDestination(navigationManager: navigationManager)  // Using the extension method
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
                publisher: AuthManager.shared.loginResultPublisher.eraseToAnyPublisher(),
                id: GoPlayAction.openUpdateProfile
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
        }
        .onDisappear {
            print("View disappeared")
            GenericObserver.shared.cancelSubscriptionByID(for: "loginResult")
        }
        
    }
    
    func userInfoView() -> some View {
            NavigationStack {
                VStack {
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
//                        if userLogin.accountType == AccountType.guest.rawValue{
                            GoButton(
                                text: "Update Account",
                                color: .white,
                                borderColor: .gray.opacity(0.75),
                                textColor: .black,
                                //                            iconName: "images/ic_user_focused",
                                //                            isSystemIcon: false,
                                iconSize: 24,
                                action:{
                                    state = GoPlaySample.updateUserInfo
//                                    navigationManager.navigate(to: NavigationDestination.goIdAuthenView)

                                }
                           )
//                        }
                    } else {
                        Text("Loading...")
                            .font(.system(size: 16))
                            .padding(.vertical, 12)
                    }
                }
                .padding()
            }
        }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
