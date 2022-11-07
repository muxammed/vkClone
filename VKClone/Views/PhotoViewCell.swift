// PhotoViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// ячейка фотографии друга
final class PhotoViewCell: UICollectionViewCell {
    // MARK: - IBOutlets

    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var likesView: LikesView!

    // MARK: - Public properties

    static let identifier = "PhotoViewCell"

    // MARK: - Public methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(with photoName: String, likesCount: Int) {
        photoImageView.image = UIImage(named: photoName)
        likesView.likeCount = likesCount
        likesView.layoutIfNeeded()
    }
}
