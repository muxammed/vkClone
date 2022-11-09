// LoadingView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// анимированная загрузка из 3х точек
final class LoadingView: UIView {
    // MARK: - IBOutlets

    @IBOutlet private var firstDot: UIView!
    @IBOutlet private var secondDot: UIView!
    @IBOutlet private var thirdDot: UIView!
    @IBOutlet private var loadingView: UIView!

    // MARK: - Initialisators

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }

    // MAKR: - Private methods
    private func initSubviews() {
        let bundle = Bundle(for: ReactionView.self)
        bundle.loadNibNamed(Constants.loadingViewNibName, owner: self, options: nil)
        addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        frame = bounds
        clipsToBounds = true
        loadingView.clipsToBounds = true
        startAnimationAction()
    }

    private func startAnimationAction() {
        UIView.animate(withDuration: 0.5, delay: 0, options: []) {
            self.firstDot.backgroundColor = UIColor(named: Constants.finalColorName)
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: []) {
                self.firstDot.backgroundColor = UIColor(named: Constants.initialColorName)
                self.secondDot.backgroundColor = UIColor(named: Constants.finalColorName)
            } completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0, options: []) {
                    self.secondDot.backgroundColor = UIColor(named: Constants.initialColorName)
                    self.thirdDot.backgroundColor = UIColor(named: Constants.finalColorName)
                } completion: { _ in
                    UIView.animate(withDuration: 0.5, delay: 0, options: []) {
                        self.thirdDot.backgroundColor = UIColor(named: Constants.initialColorName)

                    } completion: { _ in
                        self.startAnimationAction()
                    }
                }
            }
        }
    }
}

extension LoadingView {
    enum Constants {
        static let initialColorName = "ownStrokeColor"
        static let finalColorName = "ownGrayColor"
        static let loadingViewNibName = "LoadingView"
    }
}
