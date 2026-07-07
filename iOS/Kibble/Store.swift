import Foundation
import Combine

final class KibbleStore: ObservableObject {
    static let freeTierLimit = 20

    @Published var feedings: [Feeding] = [] { didSet { persist() } }
    @Published var pets: [Pet] = [] { didSet { persist() } }

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: support, withIntermediateDirectories: true)
        fileURL = support.appendingPathComponent("kibblestore.json")
        load()
    }

    var isAtFreeLimit: Bool { feedings.count >= Self.freeTierLimit }

    func canAdd(isPro: Bool) -> Bool {
        isPro || feedings.count < Self.freeTierLimit
    }

    func add(_ feeding: Feeding, isPro: Bool) -> Bool {
        guard canAdd(isPro: isPro) else { return false }
        feedings.append(feeding)
        return true
    }

    func remove(at offsets: IndexSet) {
        feedings.remove(atOffsets: offsets)
    }

    func addPet(_ pet: Pet) {
        pets.append(pet)
    }

    func petName(for id: UUID) -> String {
        pets.first(where: { $0.id == id })?.name ?? "Pet"
    }

    private func seedIfNeeded() {
        if pets.isEmpty {
            pets = [Pet(name: "Buddy")]
        }
        if feedings.isEmpty, let first = pets.first {
            feedings = [Feeding(petID: first.id, foodType: "Dry Kibble", portion: "1 cup", time: Date())]
        }
    }

    private func persist() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(PersistedState(feedings: feedings, pets: pets)) {
            try? data.write(to: fileURL)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            seedIfNeeded()
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let state = try? decoder.decode(PersistedState.self, from: data) {
            self.feedings = state.feedings
            self.pets = state.pets
        }
        seedIfNeeded()
    }

    struct PersistedState: Codable {
        var feedings: [Feeding]
        var pets: [Pet] = []
    }

}
