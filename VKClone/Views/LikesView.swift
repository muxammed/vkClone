// LikesView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// вьюв для лайков
final class LikesView: UIView {
    // MARK: - Private properties

    private var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "heart")
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .red
        return imageView
    }()

    private var likesCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    var likeCount = 0 {
        didSet {
            likesCountLabel.text = "\(likeCount)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Public methods

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }

    @objc func likeTapped() {
        if likeImageView.image == UIImage(systemName: "heart") {
            likeImageView.image = UIImage(systemName: "heart.fill")
            likesCountLabel.textColor = .red
            likeCount += 1
            likesCountLabel.text = "\(likeCount)"
        } else {
            likeImageView.image = UIImage(systemName: "heart")
            likesCountLabel.textColor = .white
            likeCount -= 1
            likesCountLabel.text = "\(likeCount)"
        }
    }

    // MARK: - Private methods

    private func setupViews() {
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
        likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(likeImageView)
        addSubview(likesCountLabel)

        likeImageViewConstraints()
        likesCountLabelConstraints()
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeImageView.addGestureRecognizer(likeTap)
    }

    private func likeImageViewConstraints() {
        NSLayoutConstraint.activate([
            likeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            likeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            likeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1),
            likeImageView.widthAnchor.constraint(equalTo: likeImageView.heightAnchor),
        ])
    }

    private func likesCountLabelConstraints() {
        NSLayoutConstraint.activate([
            likesCountLabel.centerYAnchor.constraint(equalTo: likeImageView.centerYAnchor),
            likesCountLabel.leadingAnchor.constraint(equalTo: likeImageView.trailingAnchor, constant: 2),
            likesCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 6),
        ])
    }
}
