// FriendViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// ячейка друга
@IBDesignable final class FriendViewCell: UITableViewCell {
    // MARK: - IBOutlets

    @IBOutlet private var friendImageView: UIImageView!
    @IBOutlet private var friendNickLabel: UILabel!
    @IBOutlet private var friendGroupLabel: UILabel!
    @IBOutlet private var callButton: UIButton!
    @IBOutlet private var messageButton: UIButton!

    // MARK: - Public properties

    static let identifier = Constants.FriendsViewCellIdentifier

    // MARK: - Private properties

    private var currentFriend: Friend?
    private var currentVKFriend: VKFriend?
    private var hasButtons: Bool?

    // MARK: - Public methods

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let currentFriend = currentFriend,
              let hasButtons = hasButtons else { return }
        configure(with: currentFriend, hasButtons: hasButtons)
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        guard let currentFriend = currentFriend,
              let hasButtons = hasButtons else { return }
        configure(with: currentFriend, hasButtons: hasButtons)
    }

    func configure(with friend: Friend, hasButtons: Bool = true) {
        currentFriend = friend
        self.hasButtons = hasButtons
        guard let friendNickLabel = friendNickLabel,
              let friendImageView = friendImageView else { return }
        friendNickLabel.text = friend.friendNickName
        friendImageView.image = UIImage(named: friend.friendImageName)
        if friend.friendGroupName.isEmpty {
            friendGroupLabel.removeFromSuperview()
        } else {
            friendGroupLabel.text = friend.friendGroupName
        }

        callButton.isHidden = !hasButtons
        messageButton.isHidden = !hasButtons
    }

    func configure(with friend: VKFriend, hasButtons: Bool = true) {
        currentVKFriend = friend
        self.hasButtons = hasButtons
        guard let friendNickLabel = friendNickLabel,
              let friendImageView = friendImageView else { return }
        friendNickLabel.text = friend.firstName
        friendGroupLabel.removeFromSuperview()
        callButton.isHidden = !hasButtons
        messageButton.isHidden = !hasButtons
        guard let imageUrl = URL(string: friend.photo100) else { return }
        friendImageView.downloadImageInto(from: imageUrl)
    }
}

/// Константы
extension FriendViewCell {
    enum Constants {
        static let FriendsViewCellIdentifier = "FriendViewCell"
    }
}
