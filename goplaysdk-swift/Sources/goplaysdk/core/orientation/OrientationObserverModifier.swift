/* add .observeOrientation() to any view for observer*/

import SwiftUICore
import UIKit
struct OrientationObserverModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                // Initial orientation check when the view appears
                DeviceOrientation.shared.updateOrientation()
            }
            .onChange(of: UIScreen.main.bounds.size) { _ in
                // Update orientation on size change
                DeviceOrientation.shared.updateOrientation()
            }
    }
}

extension View {
    func observeOrientation() -> some View {
        self.modifier(OrientationObserverModifier())
    }
}
