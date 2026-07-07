import XCTest
@testable import Kibble

final class KibbleTests: XCTestCase {
    var store: KibbleStore!

    override func setUp() {
        super.setUp()
        store = KibbleStore()
    }

    func testSeedDataIsBelowFreeLimit() {
        XCTAssertLessThan(store.feedings.count, KibbleStore.freeTierLimit)
    }

    func testAddIncreasesCount() {
        let before = store.feedings.count
        let added = store.add(Feeding(petID: store.pets.first!.id, foodType: "F", portion: "1"), isPro: false)
        XCTAssertTrue(added)
        XCTAssertEqual(store.feedings.count, before + 1)
    }

    func testAddRespectsFreeLimitWhenNotPro() {
        while store.feedings.count < KibbleStore.freeTierLimit {
            _ = store.add(Feeding(petID: store.pets.first!.id, foodType: "F", portion: "1"), isPro: false)
        }
        let blocked = store.add(Feeding(petID: store.pets.first!.id, foodType: "F", portion: "1"), isPro: false)
        XCTAssertFalse(blocked)
    }

    func testProBypassesFreeLimit() {
        while store.feedings.count < KibbleStore.freeTierLimit {
            _ = store.add(Feeding(petID: store.pets.first!.id, foodType: "F", portion: "1"), isPro: false)
        }
        let allowed = store.add(Feeding(petID: store.pets.first!.id, foodType: "F", portion: "1"), isPro: true)
        XCTAssertTrue(allowed)
    }

    func testCanAddReflectsLimit() {
        while store.feedings.count < KibbleStore.freeTierLimit {
            _ = store.add(Feeding(petID: store.pets.first!.id, foodType: "F", portion: "1"), isPro: false)
        }
        XCTAssertFalse(store.canAdd(isPro: false))
        XCTAssertTrue(store.canAdd(isPro: true))
    }

    func testRemoveDecreasesCount() {
        _ = store.add(Feeding(petID: store.pets.first!.id, foodType: "F", portion: "1"), isPro: false)
        let before = store.feedings.count
        store.remove(at: IndexSet(integer: 0))
        XCTAssertEqual(store.feedings.count, before - 1)
    }

    func testIsAtFreeLimitFalseInitially() {
        XCTAssertFalse(store.isAtFreeLimit)
    }

    func testPersistedStateRoundTrips() {
        let count = store.feedings.count
        let reloaded = KibbleStore()
        XCTAssertEqual(reloaded.feedings.count, count)
    }
}
