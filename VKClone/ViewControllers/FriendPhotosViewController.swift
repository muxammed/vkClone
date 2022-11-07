// FriendPhotosViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// экран коллекции фотографий друга
final class FriendPhotosViewController: UICollectionViewController {
    // MARK: - Public properties

    var currentFriend: Friend?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configNav()
    }

    // MARK: - Private methods

    private func configNav() {
        guard let currentFriend = currentFriend else {
            return
        }
        navigationItem.title = currentFriend.friendNickName
    }
}

/// UICollectionViewDelegate, UICollectionViewDataSource
extension FriendPhotosViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentFriend?.photos.count ?? 0
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoViewCell.identifier,
            for: indexPath
        ) as? PhotoViewCell,
            let currentFriend = currentFriend else { return UICollectionViewCell() }
        cell.configure(
            with: currentFriend.photos[indexPath.item].photoName,
            likesCount: currentFriend.photos[indexPath.item].likesCount
        )
        return cell
    }
}

/// UICollectionViewDelegateFlowLayout
extension FriendPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellWidthHeight = (collectionView.frame.width - 3) / 2
        return CGSize(width: cellWidthHeight, height: cellWidthHeight)
    }
}
