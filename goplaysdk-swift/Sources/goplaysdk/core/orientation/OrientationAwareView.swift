import SwiftUI

// Custom View to wrap AnyView and detect orientation changes
// Using OrientationAwareView
       /* OrientationAwareView {
            Text("This is my custom view!")
                .font(.title)
        }
        */
struct OrientationAwareView<Content: View>: View {
    @State private var isLandscape: Bool = false
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            self.content
                .onAppear {
                    // Detect initial orientation when the view appears
                    self.isLandscape = geometry.size.width > geometry.size.height
                }
                .onChange(of: geometry.size) { newSize in
                    // Detect orientation change when the size changes (e.g., on rotation)
                    self.isLandscape = newSize.width > newSize.height
                }
                .environment(\.isLandscape, isLandscape) // Pass the state to child views
        }
        .edgesIgnoringSafeArea(.all) // Optional: To make the view fill the screen
    }
}
