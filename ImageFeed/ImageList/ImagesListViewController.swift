//
//  ViewController.swift
//  ImageFeed
//
//  Created by Andrei on 19.12.2022.
//

import UIKit

final class ImagesListViewController: UIViewController, ImagesListCellDelegate {
    
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
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
                //let image = UIImage(named: photos[indexPath.row].fullImageURL)
                //viewController.image = image
            viewController.imageURL = photos[indexPath.row].fullImageURL
                
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
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
                
                let photo = photos[indexPath.row]
                UIBlockingProgressHUD.show()
                
                ImagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success:
                        self.photos[indexPath.row].isLiked.toggle()
                        cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                    case .failure(let error):
                        print(error)
                    }
                    UIBlockingProgressHUD.dismiss()
            }
    }
    
    func configCell(for cell: ImagesListCell, with IndexPath: IndexPath) {
        let imageUrl = photos[IndexPath.row].thumbImageURL
        let url = URL(string: imageUrl)
        let placeholder = UIImage(named: "Stub")
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: placeholder) { _ in
            self.tableView.reloadRows(at: [IndexPath], with: .automatic)
            cell.cellImage.kf.indicatorType = .none
        }
        cell.dateLabel.text = dateFormatter.string(from: photos[IndexPath.row].createdAt ?? Date())
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        
        return imageListCell
    }
}



