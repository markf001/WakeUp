import Foundation

struct DayStatus: Identifiable, Codable {
    let id = UUID()
    let name: String
    var completed: Bool
}
