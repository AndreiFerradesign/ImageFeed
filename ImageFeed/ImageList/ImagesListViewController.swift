//
//  ViewController.swift
//  ImageFeed
//
//  Created by Andrei on 19.12.2022.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func showAlert()
}

class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    var presenter: ImagesListPresenterProtocol?
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController else { return }
            guard let indexPath = sender as? IndexPath else { return }
            let urlImage = URL(string: presenter?.photos[indexPath.row].fullImageURL ?? "")
            viewController.fullImageURL = urlImage
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

extension ImagesListViewController  {
    
    func configCell(for cell: ImagesListCell, with IndexPath: IndexPath) {
        
        guard let url = presenter?.makePhotoUrl(photoNumber: IndexPath.row) else { return }
        let placeholder = UIImage(named: "Stub")
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: placeholder) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [IndexPath], with: .automatic)
            cell.cellImage.kf.indicatorType = .none
        }
        
        let date = presenter?.makePhotoDate(row: IndexPath.row)
        cell.dateLabel.text = date
        
        guard let photoIsLiked = presenter?.photos[IndexPath.row].isLiked else { return }
        cell.setIsLiked(isLiked: photoIsLiked)
        
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        let photos = imagesListService.photos
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.photos.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.changeLike(cell: cell, row: indexPath.row)
        
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось поставить лайк",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Ок",
            style: .default))
        self.present(alert, animated: true)
        
    }
}


