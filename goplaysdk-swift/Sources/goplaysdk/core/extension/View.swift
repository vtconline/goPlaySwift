import SwiftUI
extension View {
    // Function to reset navigation when app goes inactive
    public func resetNavigationWhenInActive(navigationManager: NavigationManager, scenePhase: ScenePhase) -> some View {
            self.onChange(of: scenePhase) { phase in
                print("navigationManager.resetNavigation phase = \(phase) ")
                if phase == .inactive {
                    print("navigationManager.resetNavigation call ")
                    navigationManager.resetNavigation()
                }
            }
        }

    public func navigateToDestination(navigationManager: NavigationManager) -> some View {
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
        case .userInfoView:
            return AnyView(RegisterView()) // Replace with actual view
        case .none:
            return AnyView(EmptyView()) // No navigation
        }
    }
}
// Move NavigationDestination outside of NavigationManager
public enum NavigationDestination {
    case goIdAuthenView
    case userInfoView
}
@MainActor
public class NavigationManager: ObservableObject {
    // Track the current destination
    @Published var destination: NavigationDestination?
    @Published var path: [NavigationDestination] = []
    public init() { } // <-- ADD THIS: ensure public this init for use in other app
    
    // Navigation functions to set the destination
    public func navigate(to destination: NavigationDestination) {
        
        self.destination = destination
        path.append(destination)
    }
    public func popToRoot() {
            path.removeAll()
        }
    
    func popBackTo(_ destination: NavigationDestination) {
            while path.last != destination {
                path.removeLast()
            }
        }
        
        func popBackUntil(where shouldStop: (NavigationDestination) -> Bool) {
            while let last = path.last, !shouldStop(last) {
                path.removeLast()
            }
        }
    
    public func resetNavigation() {
        self.destination = nil
    }
}
