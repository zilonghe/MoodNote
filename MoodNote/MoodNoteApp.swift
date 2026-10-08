import SwiftUI

@main
struct MoodNoteApp: App {
    @StateObject private var store = MoodStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)
                .tint(MoodTheme.primary)
        }
    }
}
