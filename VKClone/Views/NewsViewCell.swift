// NewsViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// ячейка таблицы новостей
final class NewsViewCell: UITableViewCell {
    // MARK: - IBOutlets

    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var newsImageView: UIView!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var newsDateLabel: UILabel!
    @IBOutlet private var newsTextLabel: UILabel!
    @IBOutlet private var likeReactionView: ReactionView!
    @IBOutlet private var commentReactionView: ReactionView!
    @IBOutlet private var shareReactionView: ReactionView!
    @IBOutlet private var likeReactionViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var commentsReactionViewWidthConstraint: NSLayoutConstraint!

    // MARK: - Public properties

    static let identifier = Constants.NewsViewCellIdentifier

    // MARK: - Private properties

    private var likesCount: String = ""
    private var commentsCount: String = ""
    private var animator = UIViewPropertyAnimator()

    // MARK: - Public methods

    static func nib() -> UINib {
        UINib(nibName: Constants.NewsViewCellIdentifier, bundle: nil)
    }

    func configure(with currentNew: News) {
        newsTextLabel.text = currentNew.newsText
        likeReactionView.caption = currentNew.likesCount > 0 ? "\(currentNew.likesCount)" : ""
        likeReactionView.hasLabelText = currentNew.likesCount > 0 ? true : false
        likesCount = currentNew.likesCount > 0 ? "\(currentNew.likesCount)" : ""

        commentReactionView.caption = currentNew.commentsCount > 0 ? "\(currentNew.commentsCount)" : ""
        commentReactionView.hasLabelText = currentNew.commentsCount > 0 ? true : false
        commentsCount = currentNew.commentsCount > 0 ? "\(currentNew.commentsCount)" : ""

        userImageView.image = UIImage(named: currentNew.newsUser.friendImageName)
        userNameLabel.text = currentNew.newsUser.friendNickName
        newsDateLabel.text = Date().formatted()

        if currentNew.newsPhotos.count > 4 {
            let imageOne = UIImageView()
            imageOne.contentMode = .scaleAspectFill
            imageOne.clipsToBounds = true
            imageOne.image = UIImage(named: currentNew.newsPhotos[0])
            imageOne.translatesAutoresizingMaskIntoConstraints = false
            newsImageView.addSubview(imageOne)

            let imageDwa = UIImageView()
            imageDwa.contentMode = .scaleAspectFill
            imageDwa.clipsToBounds = true
            imageDwa.image = UIImage(named: currentNew.newsPhotos[1])
            imageDwa.translatesAutoresizingMaskIntoConstraints = false
            newsImageView.addSubview(imageDwa)

            let imageThree = UIImageView()
            imageThree.contentMode = .scaleAspectFill
            imageThree.clipsToBounds = true
            imageThree.image = UIImage(named: currentNew.newsPhotos[2])
            imageThree.translatesAutoresizingMaskIntoConstraints = false
            newsImageView.addSubview(imageThree)

            let imageFour = UIImageView()
            imageFour.contentMode = .scaleAspectFill
            imageFour.clipsToBounds = true
            imageFour.image = UIImage(named: currentNew.newsPhotos[3])
            imageFour.translatesAutoresizingMaskIntoConstraints = false
            newsImageView.addSubview(imageFour)

            let blurEffect = UIBlurEffect(style: .dark)
            let blurView = UIVisualEffectView()
            animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                blurView.effect = blurEffect
            }
            animator.pausesOnCompletion = true
            animator.startAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                if self.animator.state != .inactive {
                    self.animator.stopAnimation(true)
                    self.animator.fractionComplete = 0.5
                }
            }

            let countLabel = UILabel()
            countLabel.translatesAutoresizingMaskIntoConstraints = false
            countLabel.text = "\(currentNew.newsPhotos.count - 3)+"
            countLabel.textColor = .white.withAlphaComponent(0.9)
            countLabel.alpha = 0
            countLabel.textAlignment = .center
            countLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)

            blurView.translatesAutoresizingMaskIntoConstraints = false
            imageFour.addSubview(blurView)
            imageFour.addSubview(countLabel)

            UIView.animate(withDuration: 0.4) {
                countLabel.alpha = 1
            }

            NSLayoutConstraint.activate([
                blurView.topAnchor.constraint(equalTo: imageFour.topAnchor),
                blurView.leadingAnchor.constraint(equalTo: imageFour.leadingAnchor),
                blurView.bottomAnchor.constraint(equalTo: imageFour.bottomAnchor),
                blurView.trailingAnchor.constraint(equalTo: imageFour.trailingAnchor),
            ])

            NSLayoutConstraint.activate([
                countLabel.leadingAnchor.constraint(equalTo: imageFour.leadingAnchor),
                countLabel.trailingAnchor.constraint(equalTo: imageFour.trailingAnchor),
                countLabel.centerYAnchor.constraint(equalTo: imageFour.centerYAnchor),
            ])

            NSLayoutConstraint.activate([
                imageOne.topAnchor.constraint(equalTo: newsImageView.topAnchor),
                imageOne.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
                imageOne.widthAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 1 / 2),
                imageOne.heightAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 1 / 2),
            ])

            NSLayoutConstraint.activate([
                imageDwa.topAnchor.constraint(equalTo: newsImageView.topAnchor),
                imageDwa.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor),
                imageDwa.widthAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 1 / 2),
                imageDwa.heightAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 1 / 2),
            ])

            NSLayoutConstraint.activate([
                imageThree.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor),
                imageThree.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
                imageThree.widthAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 1 / 2),
                imageThree.heightAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 1 / 2),
            ])

            NSLayoutConstraint.activate([
                imageFour.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor),
                imageFour.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor),
                imageFour.widthAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 1 / 2),
                imageFour.heightAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 1 / 2),
            ])

        } else {
            let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.image = UIImage(named: currentNew.newsPhotos[0])
            image.translatesAutoresizingMaskIntoConstraints = false
            newsImageView.addSubview(image)
            NSLayoutConstraint.activate([
                image.topAnchor.constraint(equalTo: newsImageView.topAnchor),
                image.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
                image.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor),
                image.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor),
            ])
        }

        invalidateIntrinsicContentSize()
    }

    override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        var plusWidth = likesCount.count == 0 ? -8 : CGFloat(likesCount.count * 10)
        likeReactionViewWidthConstraint.constant = 60 + plusWidth
        plusWidth = commentsCount.count == 0 ? -8 : CGFloat(commentsCount.count * 10)
        commentsReactionViewWidthConstraint.constant = 60 + plusWidth
        layoutIfNeeded()
    }
}

/// константы
extension NewsViewCell {
    enum Constants {
        static let NewsViewCellIdentifier = "NewsViewCell"
    }
}
