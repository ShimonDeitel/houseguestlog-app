import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [StayEntry] = []
    @Published var settings: AppSettings = AppSettings()

    /// Free tier allows this many entries. Kept comfortably above seed data
    /// so a fresh install never trips the paywall immediately.
    static let freeEntryLimit = 12

    private let fileURL: URL
    private let settingsURL: URL

    init() {
        let supportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: supportDir, withIntermediateDirectories: true)
        fileURL = supportDir.appendingPathComponent("houseguestlog_entries.json")
        settingsURL = supportDir.appendingPathComponent("houseguestlog_settings.json")
        load()
    }

    var isAtFreeLimit: Bool {
        entries.count >= Store.freeEntryLimit
    }

    func canAdd(isPro: Bool) -> Bool {
        isPro || entries.count < Store.freeEntryLimit
    }

    func add(_ entry: StayEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: StayEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: StayEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func seedIfNeeded() {
        guard entries.isEmpty else { return }
        entries = [
        StayEntry(stayDatesText: "Mar 3-5, 2025", notes: "Prefers firm pillow, allergic to cats"),
        StayEntry(stayDatesText: "Dec 24-27, 2024", notes: "Early riser, likes black coffee")
        ]
        save()
    }

    func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([StayEntry].self, from: data) {
            entries = decoded
        }
        seedIfNeeded()
        if let data = try? Data(contentsOf: settingsURL),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = decoded
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    func saveSettings() {
        if let data = try? JSONEncoder().encode(settings) {
            try? data.write(to: settingsURL, options: .atomic)
        }
    }
}

struct AppSettings: Codable, Equatable {
    var remindersEnabled: Bool = true
    var compactList: Bool = false
    var showNotesInline: Bool = true
}
