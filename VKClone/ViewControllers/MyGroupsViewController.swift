// MyGroupsViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// экран список груп
final class MyGroupsViewController: UITableViewController {
    // MARK: - Private properties

    var currentUser: User?
    var otherGroups: [Group]?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configTabelView()
        fillDummyUser()
        fillDummyGroups()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func goToGroupsAction(_ sender: Any) {
        performSegue(withIdentifier: "goToGroups", sender: self)
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

    private func fillDummyUser() {
        currentUser = User(username: "muxammed", joinedGroups: [])
        guard var currentUser = currentUser else {
            return
        }

        for ind in 0 ... 7 {
            let group = Group(groupName: "group\(ind)", groupImageName: "photo\(ind)")
            currentUser.joinedGroups.append(group)
        }
        self.currentUser = currentUser
        tableView.reloadData()
    }

    private func fillDummyGroups() {
        otherGroups = [Group]()
        guard var otherGroups = otherGroups else {
            return
        }

        for ind in 0 ... 7 {
            let group = Group(groupName: "notJoinedGroup\(ind)", groupImageName: "photo\(ind)")
            otherGroups.append(group)
        }
        self.otherGroups = otherGroups
    }
}

/// UITableViewDelegate, UITableViewDelegate
extension MyGroupsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentUser?.joinedGroups.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: GroupViewCell.identifier,
            for: indexPath
        ) as? GroupViewCell {
            guard let currentUser = currentUser else { return UITableViewCell() }
            cell.configure(with: currentUser.joinedGroups[indexPath.item], isJoined: true, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            guard var otherGroups = otherGroups,
                  var currentUser = currentUser else { return }
            otherGroups.append(currentUser.joinedGroups[indexPath.item])
            currentUser.joinedGroups.remove(at: indexPath.item)
            self.otherGroups = otherGroups
            self.currentUser = currentUser
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
