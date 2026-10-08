import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var store: MoodStore
    @State private var selected: MoodScore = .three
    @State private var note: String = ""
    @State private var savedFlash = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    moodPicker
                    noteField
                    saveButton
                    if let today = store.todayCheckIn {
                        todayCard(today)
                    }
                }
                .padding(20)
            }
            .background(MoodTheme.softBackground.ignoresSafeArea())
            .navigationTitle("今日")
            .onAppear {
                if let today = store.todayCheckIn {
                    selected = today.score
                    note = today.note
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("现在感觉怎么样？")
                .font(.title2.weight(.semibold))
            Text("轻轻选一个就好，写不写备注都行。")
                .font(.subheadline)
                .foregroundStyle(MoodTheme.mutedText)
        }
    }

    private var moodPicker: some View {
        HStack(spacing: 12) {
            ForEach(MoodScore.allCases) { score in
                Button {
                    selected = score
                } label: {
                    VStack(spacing: 6) {
                        Text(score.emoji).font(.largeTitle)
                        Text(score.label)
                            .font(.caption2)
                            .foregroundStyle(selected == score ? MoodTheme.primary : MoodTheme.mutedText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(selected == score ? MoodTheme.primary.opacity(0.12) : MoodTheme.card)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(selected == score ? MoodTheme.primary.opacity(0.5) : Color.clear, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var noteField: some View {
        TextField("可选：写一句给今天的自己", text: $note, axis: .vertical)
            .lineLimit(3...6)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(MoodTheme.card))
    }

    private var saveButton: some View {
        Button {
            store.saveCheckIn(score: selected, note: note.trimmingCharacters(in: .whitespacesAndNewlines))
            savedFlash = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { savedFlash = false }
        } label: {
            Text(store.todayCheckIn == nil ? "保存今日打卡" : "更新今日打卡")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .tint(MoodTheme.primary)
        .overlay(alignment: .trailing) {
            if savedFlash {
                Text("已保存")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(MoodTheme.primary)
                    .padding(.trailing, 16)
            }
        }
    }

    private func todayCard(_ item: MoodCheckIn) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("今天已打卡").font(.headline)
            HStack {
                Text(item.score.emoji)
                Text(item.score.label)
                Spacer()
            }
            if !item.note.isEmpty {
                Text(item.note).foregroundStyle(MoodTheme.mutedText)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(MoodTheme.card))
    }
}

#Preview {
    TodayView()
        .environmentObject(MoodStore(useSampleData: true))
}
