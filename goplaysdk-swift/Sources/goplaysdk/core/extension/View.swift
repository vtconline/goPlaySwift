import SwiftUI
extension View {
    // Function to reset navigation when app goes inactive
        func resetNavigationWhenInActive(navigationManager: NavigationManager, scenePhase: ScenePhase) -> some View {
            self.onChange(of: scenePhase) { phase in
                print("navigationManager.resetNavigation phase = \(phase) ")
                if phase == .inactive {
                    print("navigationManager.resetNavigation call ")
                    navigationManager.resetNavigation()
                }
            }
        }

    func navigateToDestination(navigationManager: NavigationManager) -> some View {
        // Use background modifier with NavigationLink that is triggered based on the NavigationManager state
        self.background(
            NavigationLink(
                destination: navigateToDestinationView(destination: navigationManager.destination),
                isActive: Binding(
                    get: { navigationManager.destination != nil },
                    set: { _ in }
                )
            ) {
                EmptyView()
            }
        )
    }
    
    
    // Helper function to return the appropriate view based on the navigation destination
    private func navigateToDestinationView(destination: NavigationDestination?) -> some View {
        switch destination {
        case .goIdAuthenView:
            return AnyView(GoIdAuthenView()) // Replace with actual view
//        case .anotherView:
//            return AnyView(AnotherView()) // Replace with actual view
        case .none:
            return AnyView(EmptyView()) // No navigation
        }
    }
}
// Move NavigationDestination outside of NavigationManager
 enum NavigationDestination {
    case goIdAuthenView
//    case anotherView
}
 class NavigationManager: ObservableObject {
    // Track the current destination
    @Published var destination: NavigationDestination?

    
    // Navigation functions to set the destination
    func navigate(to destination: NavigationDestination) {
        self.destination = destination
    }
    
    func resetNavigation() {
        self.destination = nil
    }
}
