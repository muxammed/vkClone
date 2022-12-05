// MainViewController.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift
import UIKit

/// экран с табами
final class MainViewController: UITableViewController {
    // MARK: - Private properties

    private var myFriendsUpdatedToken: NotificationToken?
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

        if !checkLoggedInAction() {
            checkLoggedIn()
        }

        fetchMyFriend()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Public methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let friendPhotosViewController = segue.destination as? FriendPhotosViewController else { return }
        friendPhotosViewController.currentFriend = selectedFriend
    }

    // MARK: - Private methods

    private func fetchMyFriend() {
        apiService.fetchMyFriends { [weak self] isSaved in
            guard let self = self else { return }
            if isSaved {
                self.myFriendsFromApi = self.loadMyFriendsFromDB()
                self.sortByLettersVK(array: self.myFriendsFromApi)
                self.registerDBUpdateToken()
            }
        }
    }

    private func loadMyFriendsFromDB() -> [VKFriend] {
        do {
            let realm = try Realm()
            let friends = realm.objects(VKFriend.self)
            return Array(friends)
        } catch {
            print(error)
            return []
        }
    }

    private func registerDBUpdateToken() {
        do {
            let realm = try Realm()
            let friends = realm.objects(VKFriend.self)
            myFriendsUpdatedToken = friends.observe { [weak self] changes in
                guard let self = self else { return }
                for frnd in friends {
                    print("friend \(frnd.firstName) online value is \(frnd.online)")
                }
                self.sortByLettersVK(array: Array(friends))
                switch changes {
                case .initial:
                    print("initial")
                    self.tableView.reloadData()
                case let .update(_, deletions, insertions, modifications):
                    print("db updated")
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(
                        at: insertions.map { IndexPath(row: $0, section: 0) },
                        with: .automatic
                    )
                    self.tableView.deleteRows(
                        at: deletions.map { IndexPath(row: $0, section: 0) },
                        with: .automatic
                    )
                    self.tableView.reloadRows(
                        at: modifications.map { IndexPath(row: $0, section: 0) },
                        with: .automatic
                    )
                    self.tableView.endUpdates()
                case let .error(error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }

    private func sortByLettersVK(array: [VKFriend]) {
        sortedMyVKFriendsMap.removeAll()
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

    private func checkLoggedInAction() -> Bool {
        guard let accessToken = UserDefaults.standard.string(forKey: Constants.accessTokenString),
              accessToken.count > 0,
              let userId = UserDefaults.standard.string(forKey: Constants.userIdString),
              userId.count > 0
        else {
            isLoggedIn = false
            return isLoggedIn
        }
        session.token = accessToken
        session.userId = userId
        isLoggedIn = true
        return isLoggedIn
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
        static let accessTokenString = "access_token"
        static let userIdString = "user_id"
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
            cell.configure(
                with: sortedMyVKFriendsMap[indexPath.section].friends[indexPath.item],
                vkApiService: apiService
            )
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVKFriend = sortedMyVKFriendsMap[indexPath.section].friends[indexPath.item]
        guard let selectedFriend = selectedVKFriend else { return }
        do {
            let realm = try Realm()
            realm.beginWrite()
            selectedFriend.online = selectedFriend.online == 1 ? 0 : 1
            realm.add(selectedFriend)
            try realm.commitWrite()
        } catch {
            print(error)
        }
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
