// GroupsViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// делегат для нажатия join внутри ячейки
protocol JoinGroupDelegate: AnyObject {
    func joinGroup(group: Group, indexPath: IndexPath)
}

/// экран таблица прочих групп
final class GroupsViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet private var tableView: UITableView!

    // MARK: - Public properties

    var groups: [VKGroup]?
    var user: User?

    // MARK: - Private properties

    let vkApiService = VKAPIService()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    // MARK: - IBActions

    @IBAction private func backToMyGroups(_ unwindSegue: UIStoryboardSegue) {
        guard let myGroupsViewController = unwindSegue.source as? MyGroupsViewController
        else {
            return
        }
        myGroupsViewController.currentUser = user
        myGroupsViewController.otherGroups = groups
        myGroupsViewController.tableView.reloadData()
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Public methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let myGroupsViewController = segue.destination as? MyGroupsViewController else { return }
        myGroupsViewController.otherGroups = groups
        myGroupsViewController.currentUser = user
    }

    // MARK: - Private methods

    private func configureTableView() {
        tableView.register(GroupViewCell.nib(), forCellReuseIdentifier: GroupViewCell.identifier)
    }
}

/// UITableViewDelegate, UITableViewDataSource
extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GroupViewCell.identifier,
            for: indexPath
        ) as? GroupViewCell,
            let groups = groups else { return UITableViewCell() }
        cell.configure(with: groups[indexPath.item], isJoined: false, indexPath: indexPath, vkApiService: vkApiService)
        cell.delegate = self
        return cell
    }
}

/// JoinGroupDelegate
extension GroupsViewController: JoinGroupDelegate {
    func joinGroup(group: Group, indexPath: IndexPath) {
        guard var groups = groups,
              var user = user else { return }
        user.joinedGroups.append(group)
        groups.remove(at: indexPath.item)
        self.user = user
        self.groups = groups
        tableView.deleteRows(at: [indexPath], with: .top)
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performSegue(withIdentifier: Constants.goToMyGroupsSeguaName, sender: self)
        }
    }
}

/// константы
extension GroupsViewController {
    enum Constants {
        static let goToMyGroupsSeguaName = "goToMyGroups"
    }
}
