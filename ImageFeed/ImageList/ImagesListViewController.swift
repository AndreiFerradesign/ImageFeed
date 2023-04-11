//
//  ViewController.swift
//  ImageFeed
//
//  Created by Andrei on 19.12.2022.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photos: [Photo] = []
    private var imagesListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateTableViewAnimated()
                }
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            if let indexPath = sender as? IndexPath {
                let urlImage = URL(string: photos[indexPath.row].fullImageURL)
                viewController?.fullImageURL = urlImage
                
            } else {
                super.prepare(for: segue, sender: sender)
            }
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
        let imageUrl = photos[IndexPath.row].thumbImageURL
        let url = URL(string: imageUrl)
        let placeholder = UIImage(named: "Stub")
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: placeholder) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [IndexPath], with: .automatic)
            cell.cellImage.kf.indicatorType = .none
        }
        let photo = photos[IndexPath.row]
        if let photoCreatedAt = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: photoCreatedAt)
        } else {
            cell.dateLabel.text = ""
        }
        cell.setIsLiked(isLiked: photos[IndexPath.row].isLiked)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        let photos = imagesListService.photos
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
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
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: !photo.isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
                self.showAlert()
                
            }
        }
    }
    
    private func showAlert() {
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


