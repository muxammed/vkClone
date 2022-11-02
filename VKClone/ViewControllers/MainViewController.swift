// MainViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// экран с табами
final class MainViewController: UITableViewController {
    // MARK: - Private properties

    private var isLoggedIn = false

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLoggedInAction()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLoggedIn()
    }

    // MARK: - Private methods

    private func checkLoggedIn() {
        if !isLoggedIn {
            performSegue(withIdentifier: Constants.goToLoginSegueIdentifier, sender: self)
        }
    }

    private func checkLoggedInAction() {
        isLoggedIn = UserDefaults.standard.bool(forKey: Constants.isLoggedIn)
    }

    private func setupViews() {
        navigationItem.title = Constants.friendsTitle
        tableView.register(FriendsViewCell.nib(), forCellReuseIdentifier: FriendsViewCell.identifier)
    }
}

/// Constants
extension MainViewController {
    enum Constants {
        static let goToLoginSegueIdentifier = "goToLogin"
        static let isLoggedIn = "isLoggedIn"
        static let goToPhotosText = "goToPhotos"
        static let friendsTitle = "My friends"
    }
}

/// UITableViewDataSourceDelegate, UITableViewDelegate
extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FriendsViewCell.identifier) as? FriendsViewCell {
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.goToPhotosText, sender: self)
    }
}
