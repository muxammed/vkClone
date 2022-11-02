// FriendsViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// FriendsViewCellTableViewCell ячейка таблицы друзей
final class FriendsViewCell: UITableViewCell {
    // MARK: - Public properties

    static let identifier = Constants.FriendsViewCellIdentifier

    // MARK: - Public methods

    static func nib() -> UINib {
        UINib(nibName: FriendsViewCell.identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension FriendsViewCell {
    enum Constants {
        static let FriendsViewCellIdentifier = "FriendsViewCell"
    }
}
