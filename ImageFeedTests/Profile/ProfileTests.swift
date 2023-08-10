//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Andrei Kashin on 19.04.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
            //Given
            let viewController = ProfileViewController()
            let presenter = ProfilePresenterSpy()
            viewController.presenter = presenter
            presenter.view = viewController
            
            //When
            _ = viewController.view
            
            //Then
            XCTAssertTrue(presenter.viewDidLoadCalled)
        }
        
    func testProfileViewCallsLogout() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.logOut()
        
        XCTAssertTrue(presenter.logOutCalled)
    }

}
