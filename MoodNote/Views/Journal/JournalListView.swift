import SwiftUI

struct JournalListView: View {
    @EnvironmentObject private var store: MoodStore
    @State private var filter: MoodScore?
    @State private var editing: JournalEntry?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar
                List {
                    ForEach(store.entries(filteredBy: filter)) { entry in
                        Button {
                            editing = entry
                        } label: {
                            JournalRow(entry: entry)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete { indexSet in
                        let list = store.entries(filteredBy: filter)
                        for i in indexSet { store.deleteEntry(list[i]) }
                    }
                }
                .listStyle(.plain)
            }
            .background(MoodTheme.softBackground.ignoresSafeArea())
            .navigationTitle("日记")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        editing = JournalEntry(title: "", body: "")
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(item: $editing) { entry in
                JournalEditorView(entry: entry) { saved in
                    store.upsertEntry(saved)
                }
            }
        }
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(title: "全部", score: nil)
                ForEach(MoodScore.allCases) { score in
                    filterChip(title: "\(score.emoji) \(score.label)", score: score)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }

    private func filterChip(title: String, score: MoodScore?) -> some View {
        Button {
            filter = score
        } label: {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule().fill(filter == score ? MoodTheme.primary.opacity(0.15) : MoodTheme.card)
                )
                .overlay(
                    Capsule().stroke(filter == score ? MoodTheme.primary : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .foregroundStyle(filter == score ? MoodTheme.primary : .primary)
    }
}

private struct JournalRow: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(entry.title.isEmpty ? "无标题" : entry.title)
                    .font(.headline)
                Spacer()
                if let mood = entry.mood {
                    Text(mood.emoji)
                }
            }
            Text(entry.body.isEmpty ? "（空）" : entry.body)
                .font(.subheadline)
                .foregroundStyle(MoodTheme.mutedText)
                .lineLimit(2)
            Text(entry.createdAt.formatted(date: .abbreviated, time: .omitted))
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    JournalListView()
        .environmentObject(MoodStore(useSampleData: true))
}
