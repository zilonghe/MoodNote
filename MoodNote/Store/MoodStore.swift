import Foundation
import Combine

@MainActor
final class MoodStore: ObservableObject {
    @Published private(set) var checkIns: [MoodCheckIn] = []
    @Published private(set) var entries: [JournalEntry] = []

    private let checkInsURL: URL
    private let entriesURL: URL
    private let calendar = Calendar.current

    init(useSampleData: Bool = false) {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        checkInsURL = dir.appendingPathComponent("mood_checkins.json")
        entriesURL = dir.appendingPathComponent("journal_entries.json")

        if useSampleData {
            loadSamples()
        } else {
            load()
            if checkIns.isEmpty && entries.isEmpty {
                loadSamples()
                save()
            }
        }
    }

    var todayCheckIn: MoodCheckIn? {
        checkIns.first { calendar.isDateInToday($0.date) }
    }

    var streakDays: Int {
        var streak = 0
        var day = calendar.startOfDay(for: Date())
        let daysWithCheckIn = Set(checkIns.map { calendar.startOfDay(for: $0.date) })
        while daysWithCheckIn.contains(day) {
            streak += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = prev
        }
        return streak
    }

    var weeklyAverage: Double? {
        guard let weekAgo = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: Date())) else {
            return nil
        }
        let recent = checkIns.filter { $0.date >= weekAgo }
        guard !recent.isEmpty else { return nil }
        let sum = recent.reduce(0) { $0 + $1.score.rawValue }
        return Double(sum) / Double(recent.count)
    }

    func saveCheckIn(score: MoodScore, note: String) {
        if let existing = todayCheckIn, let idx = checkIns.firstIndex(of: existing) {
            checkIns[idx].score = score
            checkIns[idx].note = note
            checkIns[idx].date = Date()
        } else {
            checkIns.insert(MoodCheckIn(score: score, note: note), at: 0)
        }
        save()
    }

    func upsertEntry(_ entry: JournalEntry) {
        if let idx = entries.firstIndex(where: { $0.id == entry.id }) {
            var updated = entry
            updated.updatedAt = Date()
            entries[idx] = updated
        } else {
            entries.insert(entry, at: 0)
        }
        entries.sort { $0.createdAt > $1.createdAt }
        save()
    }

    func deleteEntry(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func entries(filteredBy mood: MoodScore?) -> [JournalEntry] {
        guard let mood else { return entries }
        return entries.filter { $0.mood == mood }
    }

    private func load() {
        checkIns = Self.decode([MoodCheckIn].self, from: checkInsURL) ?? []
        entries = Self.decode([JournalEntry].self, from: entriesURL) ?? []
        entries.sort { $0.createdAt > $1.createdAt }
    }

    private func save() {
        Self.encode(checkIns, to: checkInsURL)
        Self.encode(entries, to: entriesURL)
    }

    private func loadSamples() {
        let today = Date()
        checkIns = [
            MoodCheckIn(date: today, score: .three, note: "今天还算平稳"),
            MoodCheckIn(date: calendar.date(byAdding: .day, value: -1, to: today)!, score: .four, note: ""),
            MoodCheckIn(date: calendar.date(byAdding: .day, value: -2, to: today)!, score: .two, note: "有点累")
        ]
        entries = [
            JournalEntry(title: "散步十分钟", body: "下楼走了一圈，空气不错。", mood: .four),
            JournalEntry(
                createdAt: calendar.date(byAdding: .day, value: -1, to: today)!,
                updatedAt: calendar.date(byAdding: .day, value: -1, to: today)!,
                title: "睡得晚",
                body: "夜里有点胡思乱想，记一下就好。",
                mood: .two
            )
        ]
    }

    private static func decode<T: Decodable>(_ type: T.Type, from url: URL) -> T? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    private static func encode<T: Encodable>(_ value: T, to url: URL) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        try? data.write(to: url, options: [.atomic])
    }
}
