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

    func configure(with group: VKGroup, isJoined: Bool, indexPath: IndexPath) {
        groupNameLabel.text = group.name
        joinButton.isHidden = true
        currentIndexPath = indexPath
        joinButton.addTarget(self, action: #selector(joinButtonLeavedAction), for: .touchCancel)
        guard let urlString = URL(string: group.photoUrl) else { return }
        groupImageView.downloadImageInto(from: urlString)
    }

    // MARK: - Private methods

    @objc private func joinButtonAction() {
        guard let delegate = delegate,
              let currentGroup = currentGroup,
              let indexPath = currentIndexPath else { return }
        delegate.joinGroup(group: currentGroup, indexPath: indexPath)
    }

    @objc private func joinButtonPressedAction() {
        imageViewWidthConstraint.constant -= 20
        imageViewHeightConstraint.constant -= 20
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }

    @objc private func joinButtonLeavedAction() {
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
