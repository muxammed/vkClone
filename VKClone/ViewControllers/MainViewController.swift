// MainViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// экран с табами
final class MainViewController: UITableViewController {
    // MARK: - Private properties

    private var isLoggedIn = false
    private var myFriends: [Friend] = []
    private var selectedFriend: Friend?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadDummyFriends()
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

    private func loadDummyFriends() {
        var friend = Friend(
            friendNickName: "Friend",
            friendImageName: Constants.friendImageNameText,
            friendGroupName: "",
            photos: [
                Photo(photoName: "photo1", likesCount: 10),
                Photo(photoName: "photo2", likesCount: 1),
                Photo(photoName: "photo3", likesCount: 12)
            ]
        )
        myFriends.append(friend)
        friend = Friend(
            friendNickName: "Friend2",
            friendImageName: Constants.friendImageNameText,
            friendGroupName: "",
            photos: [
                Photo(photoName: "photo4", likesCount: 10),
                Photo(photoName: "photo5", likesCount: 14),
                Photo(photoName: "photo6", likesCount: 13)
            ]
        )
        myFriends.append(friend)
        friend = Friend(
            friendNickName: "Friend3",
            friendImageName: Constants.friendImageNameText,
            friendGroupName: "Команда ВКонтакте",
            photos: [
                Photo(photoName: "photo7", likesCount: 11),
                Photo(photoName: "photo1", likesCount: 16),
                Photo(photoName: "photo2", likesCount: 18)
            ]
        )
        myFriends.append(friend)
        friend = Friend(
            friendNickName: "Friend4",
            friendImageName: Constants.friendImageNameText,
            friendGroupName: "",
            photos: [
                Photo(photoName: "photo3", likesCount: 15),
                Photo(photoName: "photo4", likesCount: 15),
                Photo(photoName: "photo5", likesCount: 19)
            ]
        )
        myFriends.append(friend)
        friend = Friend(
            friendNickName: "Friend5",
            friendImageName: Constants.friendImageNameText,
            friendGroupName: "Команда ВКонтакте",
            photos: [
                Photo(photoName: "photo6", likesCount: 10),
                Photo(photoName: "photo7", likesCount: 10),
                Photo(photoName: "photo1", likesCount: 10)
            ]
        )
        myFriends.append(friend)
        friend = Friend(
            friendNickName: "Friend6",
            friendImageName: Constants.friendImageNameText,
            friendGroupName: "",
            photos: [
                Photo(photoName: "photo2", likesCount: 10),
                Photo(photoName: "photo3", likesCount: 10),
                Photo(photoName: "photo4", likesCount: 10)
            ]
        )
        myFriends.append(friend)
        tableView.reloadData()
    }

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
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let friendPhotosViewController = segue.destination as? FriendPhotosViewController else { return }
        friendPhotosViewController.currentFriend = selectedFriend
    }
}

/// Constants
extension MainViewController {
    enum Constants {
        static let goToLoginSegueIdentifier = "goToLogin"
        static let isLoggedIn = "isLoggedIn"
        static let goToPhotosText = "goToPhotos"
        static let friendsTitle = "My friends"
        static let friendImageNameText = "friend2"
    }
}

/// UITableViewDataSourceDelegate, UITableViewDelegate
extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myFriends.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FriendViewCell.identifier) as? FriendViewCell {
            cell.configure(with: myFriends[indexPath.item])
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFriend = myFriends[indexPath.item]
        performSegue(withIdentifier: "goToPhotos", sender: self)
    }
}
