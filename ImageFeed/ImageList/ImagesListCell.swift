//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Andrei on 29.12.2022.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
        @IBAction private func likeButtonClicked() {
       delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(isLiked: Bool) {
             let likeImage = isLiked ? UIImage(named: "ActiveHeart") : UIImage(named: "NoActiveHeart")
             likeButton.setImage(likeImage, for: .normal)
         }
}
