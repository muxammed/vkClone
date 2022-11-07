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

    public var groups: [Group]?
    public var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    // MARK: - IBActions

    @IBAction func backToMyGroups(_ unwindSegue: UIStoryboardSegue) {
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

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        true
    }

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
        cell.configure(with: groups[indexPath.item], isJoined: false, indexPath: indexPath)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "goToMyGroups", sender: self)
        }
    }
}
