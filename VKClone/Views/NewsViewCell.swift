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

    private var likesCount = ""
    private var commentsCount = ""
    private var animator = UIViewPropertyAnimator()
//    private var currentNew: Friend

    // MARK: - Public methods

    static func nib() -> UINib {
        UINib(nibName: Constants.NewsViewCellIdentifier, bundle: nil)
    }

    override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        var plusWidth = likesCount.count == 0 ? -8 : CGFloat(likesCount.count * 10)
        likeReactionViewWidthConstraint.constant = 60 + plusWidth
        plusWidth = commentsCount.count == 0 ? -8 : CGFloat(commentsCount.count * 10)
        commentsReactionViewWidthConstraint.constant = 60 + plusWidth
        layoutIfNeeded()
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
            placeFourImages(by: currentNew)
        } else {
            let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.image = UIImage(named: currentNew.newsPhotos[0])
            image.translatesAutoresizingMaskIntoConstraints = false
            newsImageView.addSubview(image)
            pinToParentView(with: image, to: newsImageView)
        }

        invalidateIntrinsicContentSize()
    }

    // MARK: - Private methods

    private func placeFourImages(by currentNew: News) {
        let imageOne = createImageView(with: currentNew.newsPhotos[0])
        let imageDwa = createImageView(with: currentNew.newsPhotos[1])
        let imageThree = createImageView(with: currentNew.newsPhotos[2])
        let imageFour = createImageView(with: currentNew.newsPhotos[3])

        let blurView = createBlurView()
        let countLabel = createCountLable(with: currentNew.newsPhotos.count)

        imageFour.addSubview(blurView)
        imageFour.addSubview(countLabel)

        UIView.animate(withDuration: 0.4) {
            countLabel.alpha = 1
        }

        pinToParentView(with: blurView, to: imageFour)
        pinToParentView(with: countLabel, to: imageFour)

        imageOneConstraints(with: imageOne)
        imageDwaConstraints(with: imageDwa)
        imageThreeConstraints(with: imageThree)
        imageFourConstraints(with: imageFour)
    }

    private func imageOneConstraints(with imageOne: UIImageView) {
        NSLayoutConstraint.activate([
            imageOne.topAnchor.constraint(equalTo: newsImageView.topAnchor),
            imageOne.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
            imageOne.widthAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 1 / 2),
            imageOne.heightAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 1 / 2),
        ])
    }

    private func imageDwaConstraints(with imageDwa: UIImageView) {
        NSLayoutConstraint.activate([
            imageDwa.topAnchor.constraint(equalTo: newsImageView.topAnchor),
            imageDwa.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor),
            imageDwa.widthAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 1 / 2),
            imageDwa.heightAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 1 / 2),
        ])
    }

    private func imageThreeConstraints(with imageThree: UIImageView) {
        NSLayoutConstraint.activate([
            imageThree.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor),
            imageThree.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
            imageThree.widthAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 1 / 2),
            imageThree.heightAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 1 / 2),
        ])
    }

    private func imageFourConstraints(with imageFour: UIImageView) {
        NSLayoutConstraint.activate([
            imageFour.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor),
            imageFour.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor),
            imageFour.widthAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 1 / 2),
            imageFour.heightAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 1 / 2),
        ])
    }

    private func pinToParentView(with view: UIView, to imageView: UIView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: imageView.topAnchor),
            view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
        ])
    }

    private func createImageView(with imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: imageName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.addSubview(imageView)
        return imageView
    }

    private func createBlurView() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView()
        blurView.translatesAutoresizingMaskIntoConstraints = false
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
        return blurView
    }

    private func createCountLable(with count: Int) -> UILabel {
        let countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.text = "\(count - 3)+"
        countLabel.textColor = .white.withAlphaComponent(0.9)
        countLabel.alpha = 0
        countLabel.textAlignment = .center
        countLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return countLabel
    }
}

/// константы
extension NewsViewCell {
    enum Constants {
        static let NewsViewCellIdentifier = "NewsViewCell"
    }
}
