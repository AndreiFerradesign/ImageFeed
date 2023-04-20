//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Andrei on 19.12.2022.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()

    override func setUpWithError() throws {
    
        continueAfterFailure = false
        app.launch()

    }

    func testAuth() throws {

        app.buttons["Войти"].tap()

        let webView = app.webViews["UnsplashWebView"]

        XCTAssertTrue(webView.waitForExistence(timeout: 10))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))

        loginTextField.tap()
        loginTextField.typeText("Your e-mail")
        app.toolbars.buttons["Done"].tap()

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        passwordTextField.tap()
        passwordTextField.typeText("Your password")
        app.toolbars.buttons["Done"].tap()

        webView.buttons["Login"].tap()

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        XCTAssertTrue(cell.waitForExistence(timeout: 5))

    }
    
    func testFeed() throws {
        sleep(3)
        
        let tablesQuery = app.tables

        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 2)

        cellToLike.buttons["Like Button"].tap()
        
        sleep(5)
        
        cellToLike.buttons["Like Button"].tap()
        
        sleep(5)
    
        cellToLike.tap()

        sleep(2)

        let image = app.scrollViews.images.element(boundBy: 0)

        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["Back Button"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts["Andrei Kashin"].exists)
        XCTAssertTrue(app.staticTexts["@andreiferradesign"].exists)

        app.buttons["ipad.and.arrow.forward"].tap()

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()

    sleep(2)

    XCTAssertTrue(app.buttons["Войти"].exists)
    }

}
