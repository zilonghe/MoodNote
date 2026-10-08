import SwiftUI

struct JournalEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: JournalEntry
    let onSave: (JournalEntry) -> Void

    init(entry: JournalEntry, onSave: @escaping (JournalEntry) -> Void) {
        _draft = State(initialValue: entry)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("标题") {
                    TextField("给这篇日记起个名字", text: $draft.title)
                }
                Section("心情（可选）") {
                    Picker("心情", selection: Binding(
                        get: { draft.mood },
                        set: { draft.mood = $0 }
                    )) {
                        Text("不选").tag(Optional<MoodScore>.none)
                        ForEach(MoodScore.allCases) { score in
                            Text("\(score.emoji) \(score.label)").tag(Optional(score))
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section("正文") {
                    TextField("写点什么…", text: $draft.body, axis: .vertical)
                        .lineLimit(8...20)
                }
            }
            .navigationTitle(draft.title.isEmpty ? "新日记" : "编辑日记")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        onSave(draft)
                        dismiss()
                    }
                    .disabled(draft.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                              && draft.body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
