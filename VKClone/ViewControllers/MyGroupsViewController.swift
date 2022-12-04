// MyGroupsViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// экран список груп
final class MyGroupsViewController: UITableViewController {
    // MARK: - Public properties

    var currentUser: User?
    var otherGroups: [VKGroup]?

    // MARK: - Private properties

    private let apiService = VKAPIService()
    private var vkGroups: [VKGroup]?
    private var session = Session.shared

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configTabelView()
        fetchMyGroups()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func goToGroupsAction(_ sender: Any) {
        performSegue(withIdentifier: Constants.goToGroupsSegueName, sender: self)
    }

    // MARK: - Public methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let groupsViewController = segue.destination as? GroupsViewController,
              let otherGroups = otherGroups else { return }
        groupsViewController.groups = otherGroups
        groupsViewController.user = currentUser
    }

    @IBAction func comeBackToMyGroupsSegue(_ sender: UIStoryboardSegue) {}

    // MARK: - Private methods

    private func configTabelView() {
        tableView.register(GroupViewCell.nib(), forCellReuseIdentifier: GroupViewCell.identifier)
    }

    private func fetchMyGroups() {
        vkGroups?.removeAll()
        tableView.reloadData()
        apiService.apiAccessToken = session.token
        apiService.apiUserId = session.userId
        apiService.fetchMyGroups { [weak self] groups in
            guard let self = self else { return }
            self.vkGroups = groups
            self.tableView.reloadData()
        }
    }

    private func fillDummyUser() {
        currentUser = User(username: Constants.userName, joinedGroups: [])
        for ind in 0 ... 7 {
            let group = Group(
                groupName: Constants.joinedGroupPrefix + "\(ind)",
                groupImageName: Constants.groupPhotoPrefix + "\(ind)"
            )
            currentUser?.joinedGroups.append(group)
        }
        tableView.reloadData()
    }
}

/// UITableViewDelegate, UITableViewDelegate
extension MyGroupsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vkGroups?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: GroupViewCell.identifier,
            for: indexPath
        ) as? GroupViewCell {
            guard let vkGroups = vkGroups else { return UITableViewCell() }
            cell.configure(
                with: vkGroups[indexPath.item],
                isJoined: true,
                indexPath: indexPath,
                vkApiService: apiService
            )
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            guard var otherGroups = otherGroups,
                  var currentUser = currentUser else { return }
            currentUser.joinedGroups.remove(at: indexPath.item)
            self.otherGroups = otherGroups
            self.currentUser = currentUser
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

/// Константы
extension MyGroupsViewController {
    enum Constants {
        static let goToGroupsSegueName = "goToGroups"
        static let userName = "muxammed"
        static let joinedGroupPrefix = "group"
        static let groupPhotoPrefix = "photo"
        static let notJoinedGroupPrefix = "notJoinedGroup"
    }
}
