import Foundation

struct StayEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var stayDatesText: String
    var notes: String

    init(id: UUID = UUID(), createdAt: Date = Date(), stayDatesText: String = "", notes: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.stayDatesText = stayDatesText
        self.notes = notes
    }
}
