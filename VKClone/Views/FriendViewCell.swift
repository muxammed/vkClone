// FriendViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// ячейка друга
final class FriendViewCell: UITableViewCell {
    // MARK: - IBOutlets

    @IBOutlet private var friendImageView: UIImageView!
    @IBOutlet private var friendNickLabel: UILabel!
    @IBOutlet private var friendGroupLabel: UILabel!

    // MARK: - Public properties

    static let identifier = Constants.FriendsViewCellIdentifier

    // MARK: - Public methods

    func configure(with friend: Friend) {
        guard let friendNickLabel = friendNickLabel,
              let friendImageView = friendImageView else { return }
        friendNickLabel.text = friend.friendNickName
        friendImageView.image = UIImage(named: friend.friendImageName)
        if friend.friendGroupName.isEmpty {
            friendGroupLabel.removeFromSuperview()
        } else {
            friendGroupLabel.text = friend.friendGroupName
        }
    }
}

/// Константы
extension FriendViewCell {
    enum Constants {
        static let FriendsViewCellIdentifier = "FriendViewCell"
    }
}
