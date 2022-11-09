// GroupViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка группы
final class GroupViewCell: UITableViewCell {
    // MARK: - IBOutlets

    @IBOutlet private var groupImageView: UIImageView!
    @IBOutlet private var groupNameLabel: UILabel!
    @IBOutlet private var joinButton: UIButton!
    @IBOutlet private var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var imageViewWidthConstraint: NSLayoutConstraint!

    // MARK: - Public properties

    static let identifier = Constants.groupViewCellIdentifier
    var delegate: JoinGroupDelegate?

    // MARK: - Private properties

    private var currentGroup: Group?
    private var currentIndexPath: IndexPath?

    // MARK: - Public methods

    static func nib() -> UINib {
        UINib(nibName: GroupViewCell.identifier, bundle: nil)
    }

    func configure(with group: Group, isJoined: Bool, indexPath: IndexPath) {
        groupNameLabel.text = group.groupName
        groupImageView.image = UIImage(named: group.groupImageName)
        joinButton.isHidden = isJoined
        // joinButton.addTarget(self, action: #selector(joinButtonAction), for: .touchUpInside)
        currentGroup = group
        currentIndexPath = indexPath

        // joinButton.addTarget(self, action: #selector(joinButtonPressed), for: .touchDown)
        joinButton.addTarget(self, action: #selector(joinButtonLeaved), for: .touchCancel)

        // groupImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(<#T##@objc method#>)))
    }

    // MARK: - Private methods

    @objc private func joinButtonAction() {
        guard let delegate = delegate,
              let currentGroup = currentGroup,
              let indexPath = currentIndexPath else { return }
        delegate.joinGroup(group: currentGroup, indexPath: indexPath)
    }

    @objc private func joinButtonPressed() {
        imageViewWidthConstraint.constant -= 20
        imageViewHeightConstraint.constant -= 20
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }

    @objc private func joinButtonLeaved() {
        imageViewWidthConstraint.constant += 20
        imageViewHeightConstraint.constant += 20
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
}

/// Константы
extension GroupViewCell {
    enum Constants {
        static let groupViewCellIdentifier = "GroupViewCell"
    }
}
