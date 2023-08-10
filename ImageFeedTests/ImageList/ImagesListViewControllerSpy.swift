//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Andrei Kashin on 20.04.2023.
//

import Foundation
@testable import ImageFeed
import UIKit

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    
    var presenter: ImagesListPresenterProtocol?
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
    }
    
    func showAlert() {
    }
    
    
}
