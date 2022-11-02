// FriendsViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// ячейка таблицы друзей
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

/// Константы
extension FriendsViewCell {
    enum Constants {
        static let FriendsViewCellIdentifier = "FriendsViewCell"
    }
}
