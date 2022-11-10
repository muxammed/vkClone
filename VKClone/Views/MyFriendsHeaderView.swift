// MyFriendsHeaderView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// кастомный хедер вью с поиском для таблицы друзей
final class MyFriendsHeaderView: UITableViewHeaderFooterView {
    // MARK: - IBOutlets

    @IBOutlet private var friendSearchBar: UISearchBar!
}

/// константы
extension MyFriendsHeaderView {
    enum Constants {
        static let headerViewIdentifier = "MyFriendsHeaderView"
    }
}
