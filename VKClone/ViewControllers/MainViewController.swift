// MainViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// экран с табами
final class MainViewController: UITableViewController {
    // MARK: - Private properties

    private var isLoggedIn = false
    private var myFriends: [Friend] = []
    private var sortedMyFriendsMap: [LetterFriend] = []
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

    // MARK: - Public methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let friendPhotosViewController = segue.destination as? FriendPhotosViewController else { return }
        friendPhotosViewController.currentFriend = selectedFriend
    }

    // MARK: - Private methods

    private func loadDummyFriends() {
        myFriends = [
            Friend(
                friendNickName: "Friend",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo1", likesCount: 10),
                    Photo(photoName: "photo2", likesCount: 1),
                    Photo(photoName: "photo3", likesCount: 12)
                ]
            ), Friend(
                friendNickName: "Friend2",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo4", likesCount: 10),
                    Photo(photoName: "photo5", likesCount: 14),
                    Photo(photoName: "photo6", likesCount: 13)
                ]
            ), Friend(
                friendNickName: "Friend3",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "Команда ВКонтакте",
                photos: [
                    Photo(photoName: "photo7", likesCount: 11),
                    Photo(photoName: "photo1", likesCount: 16),
                    Photo(photoName: "photo2", likesCount: 18)
                ]
            ), Friend(
                friendNickName: "Ariend4",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo3", likesCount: 15),
                    Photo(photoName: "photo4", likesCount: 15),
                    Photo(photoName: "photo5", likesCount: 19)
                ]
            ), Friend(
                friendNickName: "Friend5",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "Команда ВКонтакте",
                photos: [
                    Photo(photoName: "photo6", likesCount: 10),
                    Photo(photoName: "photo7", likesCount: 10),
                    Photo(photoName: "photo1", likesCount: 10)
                ]
            ), Friend(
                friendNickName: "Ariend6",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo2", likesCount: 10),
                    Photo(photoName: "photo3", likesCount: 10),
                    Photo(photoName: "photo4", likesCount: 10)
                ]
            ),
            Friend(
                friendNickName: "UFriend",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo1", likesCount: 10),
                    Photo(photoName: "photo2", likesCount: 1),
                    Photo(photoName: "photo3", likesCount: 12)
                ]
            ), Friend(
                friendNickName: "ZFriend2",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo4", likesCount: 10),
                    Photo(photoName: "photo5", likesCount: 14),
                    Photo(photoName: "photo6", likesCount: 13)
                ]
            ), Friend(
                friendNickName: "ZFriend3",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "Команда ВКонтакте",
                photos: [
                    Photo(photoName: "photo7", likesCount: 11),
                    Photo(photoName: "photo1", likesCount: 16),
                    Photo(photoName: "photo2", likesCount: 18)
                ]
            ), Friend(
                friendNickName: "UAriend4",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo3", likesCount: 15),
                    Photo(photoName: "photo4", likesCount: 15),
                    Photo(photoName: "photo5", likesCount: 19)
                ]
            ), Friend(
                friendNickName: "DFriend5",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "Команда ВКонтакте",
                photos: [
                    Photo(photoName: "photo6", likesCount: 10),
                    Photo(photoName: "photo7", likesCount: 10),
                    Photo(photoName: "photo1", likesCount: 10)
                ]
            ), Friend(
                friendNickName: "DoAriend6",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo2", likesCount: 10),
                    Photo(photoName: "photo3", likesCount: 10),
                    Photo(photoName: "photo4", likesCount: 10)
                ]
            )
        ]
        tableView.reloadData()
        sortByLetters(array: myFriends)
    }

    private func sortByLetters(array: [Friend]) {
        let letters = Array(Set(array))
        for letter in letters {
            guard let firstLetter = letter.friendNickName.first else { return }
            let sortedByLetter = array.filter { $0.friendNickName.first?.lowercased() == firstLetter.lowercased() }
            let letterFriend = LetterFriend(letter: "\(firstLetter)", friends: sortedByLetter)
            sortedMyFriendsMap.append(letterFriend)
        }
        sortedMyFriendsMap.sort(by: { $0.letter < $1.letter })
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

    private func clearTableViewAction() {
        sortedMyFriendsMap.removeAll()
        tableView.reloadData()
    }

    private func createHeaderView(section: Int) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .black.withAlphaComponent(0.5)
        let letterLabel = UILabel()
        letterLabel.text = sortedMyFriendsMap[section].letter
        letterLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        letterLabel.textColor = .white
        letterLabel.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(letterLabel)
        letterLabelConstarints(letterLabel: letterLabel, headerView: headerView)
        return headerView
    }

    private func letterLabelConstarints(letterLabel: UILabel, headerView: UIView) {
        NSLayoutConstraint.activate([
            letterLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            letterLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            letterLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            letterLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
        ])
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
        static let goToPhotosSegueName = "goToPhotos"
    }
}

/// UITableViewDataSourceDelegate, UITableViewDelegate
extension MainViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        sortedMyFriendsMap.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedMyFriendsMap[section].friends.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = createHeaderView(section: section)
        return headerView
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FriendViewCell.identifier) as? FriendViewCell {
            cell.configure(with: sortedMyFriendsMap[indexPath.section].friends[indexPath.item])
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFriend = myFriends[indexPath.item]
        performSegue(withIdentifier: Constants.goToPhotosSegueName, sender: self)
    }
}

/// UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        clearTableViewAction()
        let filteredFriendsArray = myFriends.filter { $0.friendNickName.contains(searchBar.searchTextField.text ?? "") }
        sortByLetters(array: filteredFriendsArray)
        tableView.reloadData()
        searchBar.searchTextField.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearTableViewAction()
        sortByLetters(array: myFriends)
        tableView.reloadData()
        searchBar.searchTextField.text = ""
        searchBar.searchTextField.endEditing(true)
    }
}
