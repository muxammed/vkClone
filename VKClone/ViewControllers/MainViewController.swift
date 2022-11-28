// MainViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// экран с табами
final class MainViewController: UITableViewController {
    // MARK: - Private properties

    private var isLoggedIn = false
    private var myFriends: [Friend] = []
    private var sortedMyFriendsMap: [LetterFriend] = []
    private var sortedMyVKFriendsMap: [LetterVKFriend] = []
    private var selectedFriend: Friend?
    private var selectedVKFriend: VKFriend?
    private let apiService = VKAPIService()
    private var myFriendsFromApi: [VKFriend] = []
    private var session = Session.shared

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
        fetchMyFriend()
    }

    // MARK: - Public methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let friendPhotosViewController = segue.destination as? FriendPhotosViewController else { return }
        friendPhotosViewController.currentFriend = selectedFriend
    }

    // MARK: - Private methods

    private func fetchMyFriend() {
        clearTableViewAction()
        apiService.apiAccessToken = session.token
        apiService.apiUserId = session.userId
        apiService.fetchMyFriends { friends in
            self.myFriendsFromApi = friends
            self.sortByLettersVK(array: friends)
            self.tableView.reloadData()
        }
    }

    private func sortByLettersVK(array: [VKFriend]) {
        let letters = Array(Set(array))
        for letter in letters {
            guard let firstLetter = letter.firstName.first else { return }
            let sortedByLetter = array.filter { $0.firstName.first?.lowercased() == firstLetter.lowercased() }
            let letterFriend = LetterVKFriend(letter: "\(firstLetter)", friends: sortedByLetter)
            sortedMyVKFriendsMap.append(letterFriend)
        }
        sortedMyVKFriendsMap.sort(by: { $0.letter < $1.letter })
    }

    private func checkLoggedIn() {
        if !isLoggedIn {
            performSegue(withIdentifier: Constants.goToAuthSegueIdentifier, sender: self)
        }
    }

    private func checkLoggedInAction() {
        isLoggedIn = session.token.isEmpty ? false : true
    }

    private func setupViews() {
        navigationItem.title = Constants.friendsTitle
    }

    private func clearTableViewAction() {
        sortedMyVKFriendsMap.removeAll()
        tableView.reloadData()
    }

    private func createHeaderView(section: Int) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .black.withAlphaComponent(0.5)
        let letterLabel = UILabel()
        letterLabel.text = sortedMyVKFriendsMap[section].letter
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
        static let goToAuthSegueIdentifier = "goToAuth"
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
        sortedMyVKFriendsMap.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedMyVKFriendsMap[section].friends.count
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
            cell.configure(with: sortedMyVKFriendsMap[indexPath.section].friends[indexPath.item])
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVKFriend = myFriendsFromApi[indexPath.item]
        performSegue(withIdentifier: Constants.goToPhotosSegueName, sender: self)
    }
}

/// UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        clearTableViewAction()
        let filteredFriendsArray = myFriendsFromApi.filter {
            $0.firstName.contains(searchBar.searchTextField.text ?? "")
        }
        sortByLettersVK(array: filteredFriendsArray)
        tableView.reloadData()
        searchBar.searchTextField.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearTableViewAction()
        sortByLettersVK(array: myFriendsFromApi)
        tableView.reloadData()
        searchBar.searchTextField.text = ""
        searchBar.searchTextField.endEditing(true)
    }
}
