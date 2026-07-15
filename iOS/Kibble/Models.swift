import Foundation

struct Pet: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
}

struct Feeding: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var petID: UUID = UUID()
    var foodType: String
    var portion: String
    var time: Date = Date()
    var notes: String = ""
}
