import Foundation

enum MoodScore: Int, Codable, CaseIterable, Identifiable {
    case one = 1, two, three, four, five

    var id: Int { rawValue }

    var emoji: String {
        switch self {
        case .one: return "😞"
        case .two: return "😕"
        case .three: return "😐"
        case .four: return "🙂"
        case .five: return "😊"
        }
    }

    var label: String {
        switch self {
        case .one: return "很难受"
        case .two: return "有点低落"
        case .three: return "还好"
        case .four: return "不错"
        case .five: return "很好"
        }
    }
}

struct MoodCheckIn: Identifiable, Codable, Equatable {
    var id: UUID
    var date: Date
    var score: MoodScore
    var note: String

    init(id: UUID = UUID(), date: Date = .now, score: MoodScore, note: String = "") {
        self.id = id
        self.date = date
        self.score = score
        self.note = note
    }
}

struct JournalEntry: Identifiable, Codable, Equatable {
    var id: UUID
    var createdAt: Date
    var updatedAt: Date
    var title: String
    var body: String
    var mood: MoodScore?

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        updatedAt: Date = .now,
        title: String,
        body: String,
        mood: MoodScore? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.title = title
        self.body = body
        self.mood = mood
    }
}
