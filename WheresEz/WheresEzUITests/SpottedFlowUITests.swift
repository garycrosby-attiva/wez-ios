import XCTest

/// End-to-end verification of the Spotted capture flow and feed in the simulator.
/// Preconditions (set up outside the test): the local Worker is running, location is
/// pre-granted (`simctl privacy grant location`), and the simulated location is set
/// (`simctl location set`). The capture step uses the simulator's faithful live surface.
final class SpottedFlowUITests: XCTestCase {

    override func setUpWithError() throws { continueAfterFailure = false }

    @MainActor
    private func openSpotted() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5))
        tabBar.buttons["Spotted"].tap()
        return app
    }

    // 6.2 + 6.4 (join-me) + 6.5: capture with the simulated location near Moffat Beach,
    // confirm the resolved beach, post, and see it land in the feed.
    @MainActor
    func testCaptureLandsInFeed() throws {
        let app = openSpotted()

        app.buttons["New capture"].tap()

        // Live surface (not a library picker).
        XCTAssertTrue(app.staticTexts["LIVE"].waitForExistence(timeout: 5), "Live capture surface")
        app.buttons["Take photo"].tap()

        // Auto-tag resolves the seeded beach near the simulated location.
        XCTAssertTrue(app.staticTexts["Moffat Beach"].waitForExistence(timeout: 15),
                      "GPS resolves to the nearest seeded beach")
        app.buttons["That's the spot"].tap()

        // Join-me step is present and honestly non-sending.
        XCTAssertTrue(app.staticTexts["Delivery is coming in a later update — this won't send a notification yet."]
            .waitForExistence(timeout: 5), "Join-me is honest about not sending")
        app.buttons["Post to the feed"].tap()

        // Post lands in the feed.
        XCTAssertTrue(app.staticTexts["Spotted by Ez"].waitForExistence(timeout: 15),
                      "New post appears in the feed, authored by Ez")
    }

    // 6.4: "Try this spot" → coming-soon placeholder (requires at least one post to exist).
    @MainActor
    func testTryThisSpotShowsComingSoon() throws {
        let app = openSpotted()
        let tryButton = app.buttons["Try this spot"]
        guard tryButton.waitForExistence(timeout: 8) else {
            throw XCTSkip("No posts in feed to exercise 'Try this spot'")
        }
        tryButton.tap()
        XCTAssertTrue(app.staticTexts["Beach detail coming soon"].waitForExistence(timeout: 5))
    }

    // 6.3 (out-of-range): with the simulated location far from any seeded beach, capture
    // refuses to tag and says so honestly. Run with location set far away.
    @MainActor
    func testOutOfRangeIsHonest() throws {
        let app = openSpotted()
        app.buttons["New capture"].tap()
        XCTAssertTrue(app.staticTexts["LIVE"].waitForExistence(timeout: 5))
        app.buttons["Take photo"].tap()
        XCTAssertTrue(app.staticTexts["No known beach nearby"].waitForExistence(timeout: 15),
                      "Out-of-range is honest; no arbitrary beach tagged")
    }
}
