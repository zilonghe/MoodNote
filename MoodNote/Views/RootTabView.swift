import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("今日", systemImage: "sun.max") }
            JournalListView()
                .tabItem { Label("日记", systemImage: "book") }
            ProfileView()
                .tabItem { Label("我的", systemImage: "person") }
        }
        .background(MoodTheme.softBackground.ignoresSafeArea())
    }
}

#Preview {
    RootTabView()
        .environmentObject(MoodStore(useSampleData: true))
}
