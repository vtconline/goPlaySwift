import SwiftUI
import SwiftData

@main
struct SwiftSampleApp: App {
    //add AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
//        .modelContainer(Self.sharedModelContainer)
    }
}
