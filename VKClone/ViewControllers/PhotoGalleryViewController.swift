// PhotoGalleryViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// фото галерея
final class PhotoGalleryViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet private var photoLoadingView: LoadingView!

    // MARK: - Private properties

    private var currentImage = 0
    private var userImagesArray: [String]?
    private var userImageViewsArray: [UIImageView] = []

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        createDummyImageViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showHideToolBar(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showHideToolBar(false)
    }

    // MARK: - Private methods

    @objc private func swipeAction(_ swipe: UISwipeGestureRecognizer) {
        let currentImageView = userImageViewsArray[currentImage]
        let nextImageView = swipe.direction == .left ?
            userImageViewsArray[currentImage + 1] : userImageViewsArray[currentImage - 1]

        let originalTransform = currentImageView.transform
        let newCenter = currentImageView.center
        let scaledTransform = currentImageView.transform.scaledBy(x: Constants.scaleValue, y: Constants.scaleValue)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.0, y: 0.0)
        let scaledAndTranslatedTransform2 = originalTransform.translatedBy(x: 0.0, y: 0.0)

        UIView.animate(withDuration: 0.5) {
            currentImageView.layer.cornerRadius = 20
            nextImageView.layer.cornerRadius = 20
            currentImageView.transform = scaledAndTranslatedTransform
            nextImageView.transform = scaledAndTranslatedTransform

        } completion: { _ in

            UIView.animate(withDuration: 0.5) {
                currentImageView.center.x = swipe.direction == .left ? -(newCenter.x) : newCenter.x * 3
                nextImageView.center = newCenter
            } completion: { _ in
                UIView.animate(withDuration: 0.5) {
                    currentImageView.layer.cornerRadius = 0
                    nextImageView.layer.cornerRadius = 0
                    nextImageView.transform = scaledAndTranslatedTransform2
                    currentImageView.layoutIfNeeded()
                    nextImageView.layoutIfNeeded()
                } completion: { _ in
                    self.currentImage += swipe.direction == .left ? 1 : -1
                }
            }
        }
    }

    private func createImageView(with index: Int) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: userImagesArray?[index] ?? "")
        imageView.isUserInteractionEnabled = true

        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        leftSwipeGesture.direction = .left
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        rightSwipeGesture.direction = .right
        imageView.addGestureRecognizer(leftSwipeGesture)
        imageView.addGestureRecognizer(rightSwipeGesture)
        imageView.frame = view.safeAreaLayoutGuide.layoutFrame
        imageView.center = index == 0 ? view.center : CGPoint(x: view.center.x * 3, y: view.center.y)
        view.addSubview(imageView)

        return imageView
    }

    private func createDummyImageViews() {
        guard let userImagesArray = userImagesArray else { return }
        for ind in 0 ..< userImagesArray.count {
            let imageView = createImageView(with: ind)
            userImageViewsArray.append(imageView)
        }
    }

    private func showHideToolBar(_ isHidden: Bool) {
        tabBarController?.tabBar.isHidden = isHidden
    }
}

/// константы
extension PhotoGalleryViewController {
    enum Constants {
        static let scaleValue = 0.90
    }
}
