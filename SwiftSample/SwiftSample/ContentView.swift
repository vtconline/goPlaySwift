//
//  ContentView.swift
//  SwiftSample
//
//  Created by Ngô Đồng on 23/4/25.
//

import SwiftUI
import SwiftData
import goplaysdk
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @StateObject private var navigationManager = NavigationManager()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                //            HeaderView()
                MainView()
                //            GoIdAuthenView()
                //            Spacer()
            }
        }
        
        .navigateToDestination(navigationManager: navigationManager)  // Using the extension method
        .onAppear {
            GenericObserver.shared.observePublisher(
                publisher: AuthManager.shared.loginResultPublisher.eraseToAnyPublisher(),
                id: "loginResult"
            ) { result in
                switch result {
                case .success(let user):
                    print("Login succeeded for user: \(user.userName ?? "")")
                    // Handle successful login
                    DispatchQueue.main.async {
                        navigationManager.navigate(to: NavigationDestination.userInfoView)
                    }
                    
                case .failure(let error):
                    print("Login failed with error: \(error)")
                    // Handle login error
                }
            }
        }
        .onDisappear {
            print("View disappeared")
            GenericObserver.shared.cancelSubscriptionByID(for: "loginResult")
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
