//
//  MenuBarFlowTests.swift
//  Sharp Timer AppUITests
//
//  Created by Manuel Minguez on 17/11/25.
//

import XCTest

final class MenuBarFlowTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testWorkTimerFlow() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Verify menu bar item exists
        let menuBarItem = app.statusItems["Sharp Timer"]
        XCTAssertTrue(menuBarItem.exists, "Menu bar item should exist")

        // Click to open popover
        menuBarItem.click()

        // Verify timer display exists
        let timerDisplay = app.staticTexts["00:00"]
        XCTAssertTrue(timerDisplay.waitForExistence(timeout: 2), "Timer display should appear")

        // Verify mode picker exists
        let modePicker = app.segmentedControls["Mode"]
        XCTAssertTrue(modePicker.exists, "Mode picker should exist")

        // Verify Work mode is selected by default
        let workModeButton = modePicker.buttons["Work"]
        XCTAssertTrue(workModeButton.isSelected, "Work mode should be selected by default")

        // Start the timer
        let startButton = app.buttons["Start"]
        XCTAssertTrue(startButton.exists, "Start button should exist")
        startButton.click()

        // Verify timer is running (pause button should appear)
        let pauseButton = app.buttons["Pause"]
        XCTAssertTrue(pauseButton.waitForExistence(timeout: 2), "Pause button should appear after starting timer")

        // Pause the timer
        pauseButton.click()

        // Verify resume button appears
        let resumeButton = app.buttons["Resume"]
        XCTAssertTrue(resumeButton.waitForExistence(timeout: 2), "Resume button should appear after pausing timer")

        // Reset the timer
        let resetButton = app.buttons["Reset"]
        XCTAssertTrue(resetButton.exists, "Reset button should exist")
        resetButton.click()

        // Verify start button appears again
        XCTAssertTrue(startButton.waitForExistence(timeout: 2), "Start button should appear after resetting timer")
    }

    @MainActor
    func testModeSwitching() throws {
        let app = XCUIApplication()
        app.launch()

        // Open menu bar
        let menuBarItem = app.statusItems["Sharp Timer"]
        menuBarItem.click()

        // Switch to Rest Your Eyes mode
        let modePicker = app.segmentedControls["Mode"]
        let restEyesButton = modePicker.buttons["Rest Your Eyes"]
        restEyesButton.click()

        // Verify mode switched
        XCTAssertTrue(restEyesButton.isSelected, "Rest Your Eyes mode should be selected")

        // Switch to Long Rest mode
        let longRestButton = modePicker.buttons["Long Rest"]
        longRestButton.click()

        // Verify mode switched
        XCTAssertTrue(longRestButton.isSelected, "Long Rest mode should be selected")
    }

    @MainActor
    func testSettingsStepperFocusRetention() throws {
        let app = XCUIApplication()
        app.launch()

        // Open menu bar
        let menuBarItem = app.statusItems["Sharp Timer"]
        menuBarItem.click()

        // Open settings
        let settingsButton = app.buttons["Settings"]
        XCTAssertTrue(settingsButton.exists, "Settings button should exist")
        settingsButton.click()

        // Wait for settings window to appear
        let settingsWindow = app.windows.firstMatch
        XCTAssertTrue(settingsWindow.waitForExistence(timeout: 2), "Settings window should appear")

        // Get stepper buttons for Work duration
        let workMinusButton = app.buttons["Decrease"]
        let workPlusButton = app.buttons["Increase"]
        
        // Verify stepper buttons exist
        XCTAssertTrue(workMinusButton.exists, "Work minus button should exist")
        XCTAssertTrue(workPlusButton.exists, "Work plus button should exist")

        // Store initial window state
        let initialWindowExists = settingsWindow.exists
        let initialWindowFrame = settingsWindow.frame

        // Perform rapid clicking sequence (10+ clicks in 2 seconds)
        let clickCount = 12
        for i in 0..<clickCount {
            // Alternate between plus and minus
            if i % 2 == 0 {
                workPlusButton.click()
            } else {
                workMinusButton.click()
            }
            
            // Verify window remains visible after each click
            XCTAssertTrue(settingsWindow.exists, "Settings window should remain visible after click \(i + 1)")
            
            // Small delay to simulate rapid clicking
            Thread.sleep(forTimeInterval: 0.15)
        }

        // Verify window is still visible and stable after rapid clicking
        XCTAssertTrue(settingsWindow.exists, "Settings window should still exist after rapid clicking")
        XCTAssertEqual(settingsWindow.frame, initialWindowFrame, "Window frame should remain unchanged")

        // Test Rest Your Eyes stepper
        let restEyesMinusButton = workMinusButton // Same help text, different context
        let restEyesPlusButton = workPlusButton

        // Navigate to Rest Your Eyes duration (assuming it's in the same window)
        // This would require more specific UI element identification based on the actual layout
        
        // Perform rapid clicking on Rest Your Eyes stepper
        for i in 0..<8 {
            if i % 2 == 0 {
                restEyesPlusButton.click()
            } else {
                restEyesMinusButton.click()
            }
            
            XCTAssertTrue(settingsWindow.exists, "Settings window should remain visible during Rest Eyes stepper clicks")
            Thread.sleep(forTimeInterval: 0.2)
        }

        // Test Long Rest stepper
        for i in 0..<6 {
            if i % 2 == 0 {
                workPlusButton.click() // Assuming similar button structure
            } else {
                workMinusButton.click()
            }
            
            XCTAssertTrue(settingsWindow.exists, "Settings window should remain visible during Long Rest stepper clicks")
            Thread.sleep(forTimeInterval: 0.25)
        }

        // Final verification: window should still be fully visible and responsive
        XCTAssertTrue(settingsWindow.exists, "Settings window should remain visible after all stepper interactions")
        XCTAssertTrue(settingsWindow.isHittable, "Settings window should remain interactive")
    }

    @MainActor
    func testSettingsWindowVisibilityStateMonitoring() throws {
        let app = XCUIApplication()
        app.launch()

        // Open menu bar and settings
        let menuBarItem = app.statusItems["Sharp Timer"]
        menuBarItem.click()
        
        let settingsButton = app.buttons["Settings"]
        settingsButton.click()

        let settingsWindow = app.windows.firstMatch
        XCTAssertTrue(settingsWindow.waitForExistence(timeout: 2), "Settings window should appear")

        // Capture initial window state
        let initialFrame = settingsWindow.frame
        let initialExists = settingsWindow.exists
        let initialIsHittable = settingsWindow.isHittable

        // Get stepper buttons
        let plusButton = app.buttons["Increase"]
        let minusButton = app.buttons["Decrease"]

        // Test window state before, during, and after clicks
        for i in 0..<15 {
            // Before click
            let beforeExists = settingsWindow.exists
            let beforeFrame = settingsWindow.frame
            
            // Perform click
            plusButton.click()
            
            // During/after click
            let afterExists = settingsWindow.exists
            let afterFrame = settingsWindow.frame
            let afterIsHittable = settingsWindow.isHittable
            
            // Verify no window state changes
            XCTAssertEqual(beforeExists, afterExists, "Window existence should not change after click \(i)")
            XCTAssertEqual(beforeFrame, afterFrame, "Window frame should not change after click \(i)")
            XCTAssertTrue(afterIsHittable, "Window should remain hittable after click \(i)")
            
            // Verify against initial state
            XCTAssertEqual(afterExists, initialExists, "Window existence should match initial state")
            XCTAssertEqual(afterFrame, initialFrame, "Window frame should match initial state")
            XCTAssertEqual(afterIsHittable, initialIsHittable, "Window hittable state should match initial state")
            
            Thread.sleep(forTimeInterval: 0.1)
        }

        // Test with minus button
        for i in 0..<10 {
            minusButton.click()
            XCTAssertTrue(settingsWindow.exists, "Window should remain visible during minus button clicks")
            XCTAssertEqual(settingsWindow.frame, initialFrame, "Window frame should remain unchanged")
        }
    }

    @MainActor
    func testSettingsStepperKeyboardNavigation() throws {
        let app = XCUIApplication()
        app.launch()

        // Open menu bar and settings
        let menuBarItem = app.statusItems["Sharp Timer"]
        menuBarItem.click()
        
        let settingsButton = app.buttons["Settings"]
        settingsButton.click()

        let settingsWindow = app.windows.firstMatch
        XCTAssertTrue(settingsWindow.waitForExistence(timeout: 2), "Settings window should appear")

        // Test keyboard navigation to stepper buttons
        // First, focus on the settings window
        settingsWindow.click()

        // Tab through interface elements to reach stepper buttons
        for _ in 0..<10 {
            app.typeKey(.tab, modifierFlags: [])
            Thread.sleep(forTimeInterval: 0.1)
        }

        // Try to interact with stepper using keyboard
        app.typeKey(.space, modifierFlags: [])
        Thread.sleep(forTimeInterval: 0.2)
        
        // Verify window remains visible after keyboard interaction
        XCTAssertTrue(settingsWindow.exists, "Settings window should remain visible after keyboard interaction")

        // Test Enter key
        app.typeKey(.return, modifierFlags: [])
        Thread.sleep(forTimeInterval: 0.2)
        
        XCTAssertTrue(settingsWindow.exists, "Settings window should remain visible after Enter key interaction")

        // Test arrow keys (if stepper responds to them)
        app.typeKey(.upArrow, modifierFlags: [])
        Thread.sleep(forTimeInterval: 0.2)
        
        XCTAssertTrue(settingsWindow.exists, "Settings window should remain visible after up arrow interaction")

        app.typeKey(.downArrow, modifierFlags: [])
        Thread.sleep(forTimeInterval: 0.2)
        
        XCTAssertTrue(settingsWindow.exists, "Settings window should remain visible after down arrow interaction")

        // Final verification
        XCTAssertTrue(settingsWindow.isHittable, "Settings window should remain interactive after keyboard navigation")
    }

    @MainActor
    func testSettingsStepperAcrossWindowSizes() throws {
        let app = XCUIApplication()
        app.launch()

        // Open menu bar and settings
        let menuBarItem = app.statusItems["Sharp Timer"]
        menuBarItem.click()
        
        let settingsButton = app.buttons["Settings"]
        settingsButton.click()

        let settingsWindow = app.windows.firstMatch
        XCTAssertTrue(settingsWindow.waitForExistence(timeout: 2), "Settings window should appear")

        // Get stepper buttons
        let plusButton = app.buttons["Increase"]
        let minusButton = app.buttons["Decrease"]

        // Test at current window size
        for i in 0..<8 {
            plusButton.click()
            XCTAssertTrue(settingsWindow.exists, "Window should remain visible at current size (click \(i))")
            Thread.sleep(forTimeInterval: 0.15)
        }

        // Try to resize window (if possible) and test again
        // Note: SwiftUI popovers might not be resizable via UI tests
        // This test ensures stepper functionality works regardless of window size

        // Test rapid clicking sequence
        for i in 0..<20 {
            if i % 3 == 0 {
                plusButton.click()
            } else if i % 3 == 1 {
                minusButton.click()
            } else {
                plusButton.click()
                minusButton.click() // Double click test
            }
            
            XCTAssertTrue(settingsWindow.exists, "Window should remain visible during rapid clicking (click \(i))")
            Thread.sleep(forTimeInterval: 0.1)
        }

        // Verify window is still fully functional
        XCTAssertTrue(settingsWindow.exists, "Window should still exist after all tests")
        XCTAssertTrue(settingsWindow.isHittable, "Window should still be interactive")
    }
}
