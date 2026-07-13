import SwiftUI

@main
struct TravlsApp: App {
    @StateObject private var appSession = AppSession()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appSession)
        }
    }
}
