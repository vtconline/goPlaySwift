import SwiftUI
import SwiftData

@main
struct SwiftSampleApp: App {
    //gắn AppDelegate để sử dụng trong swift giống object-c
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()


    var body: some Scene {
        WindowGroup {
            ContentView()
        }
//        .modelContainer(Self.sharedModelContainer)
    }
}
