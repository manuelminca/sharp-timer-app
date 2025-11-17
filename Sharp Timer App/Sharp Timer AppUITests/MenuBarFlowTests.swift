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
}
