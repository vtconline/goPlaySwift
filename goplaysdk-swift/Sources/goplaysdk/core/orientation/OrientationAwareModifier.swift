import SwiftUI

// View Modifier to detect orientation changes
//Text("This is a text inside a custom view!")
//            .font(.title)
//            .orientationAware() // Apply the orientation aware modifier
struct OrientationAwareModifier: ViewModifier {
    @State private var isLandscape: Bool = false

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .onAppear {
                    self.isLandscape = geometry.size.width > geometry.size.height
                }
                .onChange(of: geometry.size) { newSize in
                    self.isLandscape = newSize.width > newSize.height
                }
                .environment(\.isLandscape, isLandscape)
        }
    }
}

extension View {
    // Apply the modifier to any view
    func orientationAware() -> some View {
        self.modifier(OrientationAwareModifier())
    }
}
