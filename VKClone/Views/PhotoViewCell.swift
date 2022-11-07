// PhotoViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// ячейка фотографии друга
final class PhotoViewCell: UICollectionViewCell {
    // MARK: - IBOutlets

    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var likesView: LikesView!

    // MARK: - Public properties

    static let identifier = Constants.photoViewCellIdentifier

    // MARK: - Public methods

    func configure(with photoName: String, likesCount: Int) {
        photoImageView.image = UIImage(named: photoName)
        likesView.likeCount = likesCount
        likesView.layoutIfNeeded()
    }
}

/// константы
extension PhotoViewCell {
    enum Constants {
        static let photoViewCellIdentifier = "PhotoViewCell"
    }
}
