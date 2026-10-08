import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var store: MoodStore
    @State private var showPrivacy = false

    var body: some View {
        NavigationStack {
            List {
                Section("本周") {
                    HStack {
                        Label("连续打卡", systemImage: "flame")
                        Spacer()
                        Text("\(store.streakDays) 天")
                            .foregroundStyle(MoodTheme.primary)
                            .fontWeight(.semibold)
                    }
                    HStack {
                        Label("平均情绪", systemImage: "chart.line.uptrend.xyaxis")
                        Spacer()
                        if let avg = store.weeklyAverage {
                            Text(String(format: "%.1f / 5", avg))
                                .foregroundStyle(MoodTheme.primary)
                                .fontWeight(.semibold)
                        } else {
                            Text("暂无数据").foregroundStyle(MoodTheme.mutedText)
                        }
                    }
                }

                Section("关于") {
                    Button {
                        showPrivacy = true
                    } label: {
                        Label("隐私说明", systemImage: "lock.shield")
                    }
                }

                Section {
                    Text("心记只把数据存在本机，不会上传。它不能替代专业心理帮助；若你正经历严重困扰，请寻求可信赖的人与专业支持。")
                        .font(.footnote)
                        .foregroundStyle(MoodTheme.mutedText)
                }
            }
            .scrollContentBackground(.hidden)
            .background(MoodTheme.softBackground.ignoresSafeArea())
            .navigationTitle("我的")
            .sheet(isPresented: $showPrivacy) {
                NavigationStack {
                    ScrollView {
                        Text("""
                        隐私说明

                        • 情绪打卡与日记保存在本机 Documents，仅供你自己查看。
                        • 本应用不联网同步、不收集账号。
                        • 卸载应用会删除本地数据。
                        • 若需要备份，可后续自行导出（下一版可加）。
                        """)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                    .navigationTitle("隐私说明")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("完成") { showPrivacy = false }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(MoodStore(useSampleData: true))
}
