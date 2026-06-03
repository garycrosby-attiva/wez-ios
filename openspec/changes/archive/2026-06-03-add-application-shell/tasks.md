## 1. Tab root views

- [x] 1.1 Add `SavedView` — honest placeholder stating nothing is saved yet (draft copy from design; comment-flag as pending creative voice review)
- [x] 1.2 Add `ProfileView` — honest placeholder stating the user's feed and future spots will live here (draft copy; flag as pending review)
- [x] 1.3 Add `HomeView` — minimal navigable empty state, no feature content, no live data
- [x] 1.4 Add `SpottedView` — minimal navigable empty state, no capture/feed content, no live data

## 2. Shell assembly

- [x] 2.1 Add `MainTabView` carrying four tabs (Home, Spotted, Saved, Profile), each wrapping its tab root in its own `NavigationStack`
- [x] 2.2 Give each tab a label and SF Symbol; confirm the four tabs render in the tab bar
- [x] 2.3 Apply `.toolbar(.hidden, for: .tabBar)` on pushed destinations (demonstrated via a throwaway/sample push) so the bar hides when pushed and reappears on pop — with no central hide-the-nav route list

## 3. Mount as app root and remove the probe

- [x] 3.1 Rewire `WheresEzApp` to mount `MainTabView()` as the sole root; remove the `HTTPBackendProbe`/`PingView` `@main` wiring
- [x] 3.1a Confirm the Swift↔Worker round-trip is covered without the probe — verify the WezImplementations integration test actually exercises the app-to-Worker hop. If it doesn't, stop and raise it before deleting PingView.
- [x] 3.2 Delete `PingView.swift`
- [x] 3.3 Delete the unused Xcode-template `ContentView.swift` if present
- [x] 3.4 Update the `WheresEz.xcodeproj` target membership so new files build and removed files are dropped

## 4. Verify

- [x] 4.1 Build the `WheresEz` target clean (Swift 6 strict concurrency, no warnings introduced)
- [x] 4.2 Launch in the simulator: app opens directly into the four-tab shell; probe is gone
- [x] 4.3 Confirm per-tab navigation isolation: push in one tab, switch tabs, switch back — pushed place is preserved and other tabs are unaffected
- [x] 4.4 Confirm Saved and Profile show their placeholder screens; Home and Spotted are navigable empty states with no live data
- [x] 4.5 Confirm the tab bar hides on a pushed destination and reappears on pop
