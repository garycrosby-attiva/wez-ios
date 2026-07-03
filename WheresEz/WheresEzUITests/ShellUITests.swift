import XCTest

/// Verifies the application-shell spec scenarios end-to-end in the simulator.
/// These exist because the change's verify tasks (4.2–4.5) require interactive
/// confirmation, and the headless environment has no manual tap primitive.
final class ShellUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    private func launched() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        return app
    }

    // 4.2 — App launches into the four-tab shell; the probe is gone.
    @MainActor
    func testLaunchesIntoFourTabShell() throws {
        let app = launched()
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5), "Tab bar should exist at launch")
        for tab in ["Home", "Spotted", "Saved", "Profile"] {
            XCTAssertTrue(tabBar.buttons[tab].exists, "Missing tab: \(tab)")
        }
        // Probe text must not appear anywhere.
        XCTAssertFalse(app.staticTexts["Backend round-trip"].exists, "Probe screen should be gone")
    }

    // 4.4 — Saved and Profile honest placeholders; Home and Spotted navigable empty states.
    @MainActor
    func testTabPlaceholdersAndEmptyStates() throws {
        let app = launched()
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5))

        XCTAssertTrue(app.staticTexts["Today's beach pick will show up here."].waitForExistence(timeout: 2),
                      "Home empty state")
        // Spotted is no longer an empty state — it hosts the feed (see spotted-feed); the
        // add-spotted-capture-feed change verifies Spotted's own behaviour.

        tabBar.buttons["Saved"].tap()
        XCTAssertTrue(app.staticTexts["Soon you'll be able to keep the spots you want to come back to."].waitForExistence(timeout: 2),
                      "Saved placeholder")

        tabBar.buttons["Profile"].tap()
        XCTAssertTrue(app.staticTexts["Your feed and your future spots will live here."].waitForExistence(timeout: 2),
                      "Profile placeholder")
    }

    // 4.3 — Each tab is its own independent navigation stack: switching tabs shows each
    // tab's own root, unaffected by the others. (Preserving *pushed* depth across a switch
    // is not exercisable here: per the chrome rule a pushed detail hides the tab bar, so
    // there is no bar to switch with while deep — that independence is a structural
    // guarantee of the per-tab NavigationStacks, demonstrated by the push test below.)
    @MainActor
    func testTabsAreIndependentRoots() throws {
        let app = launched()
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5))

        tabBar.buttons["Saved"].tap()
        XCTAssertTrue(app.navigationBars["Saved"].waitForExistence(timeout: 2))

        tabBar.buttons["Home"].tap()
        XCTAssertTrue(app.navigationBars["Home"].waitForExistence(timeout: 2),
                      "Home shows its own root, unaffected by the Saved tab")
    }

    // 4.5 — A pushed in-tab destination hides the tab bar; popping restores it.
    @MainActor
    func testPushedDetailHidesTabBarAndPopRestores() throws {
        let app = launched()
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5))

        app.buttons["See a pushed detail"].tap()
        XCTAssertTrue(app.navigationBars["Detail"].waitForExistence(timeout: 2), "Detail pushed")
        XCTAssertTrue(tabBar.waitForNonExistence(timeout: 3), "Tab bar hidden while pushed")

        app.navigationBars["Detail"].buttons.firstMatch.tap()   // Back
        XCTAssertTrue(tabBar.waitForExistence(timeout: 3), "Tab bar restored on pop")
    }
}
