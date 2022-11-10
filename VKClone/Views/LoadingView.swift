// LoadingView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// анимированная загрузка из 3х точек
final class LoadingView: UIView {
    // MARK: - IBOutlets

    @IBOutlet private var firstDotView: UIView!
    @IBOutlet private var secondDotView: UIView!
    @IBOutlet private var thirdDotView: UIView!
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
        loadingViewConstraints()
        frame = bounds
        clipsToBounds = true
        loadingView.clipsToBounds = true
        startAnimationAction()
    }

    private func loadingViewConstraints() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func startAnimationAction() {
        UIView.animate(withDuration: 0.5, delay: 0, options: []) {
            self.firstDotView.backgroundColor = UIColor(named: Constants.finalColorName)
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: []) {
                self.firstDotView.backgroundColor = UIColor(named: Constants.initialColorName)
                self.secondDotView.backgroundColor = UIColor(named: Constants.finalColorName)
            } completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0, options: []) {
                    self.secondDotView.backgroundColor = UIColor(named: Constants.initialColorName)
                    self.thirdDotView.backgroundColor = UIColor(named: Constants.finalColorName)
                } completion: { _ in
                    UIView.animate(withDuration: 0.5, delay: 0, options: []) {
                        self.thirdDotView.backgroundColor = UIColor(named: Constants.initialColorName)

                    } completion: { _ in
                        self.startAnimationAction()
                    }
                }
            }
        }
    }
}

/// константы
extension LoadingView {
    enum Constants {
        static let initialColorName = "ownStrokeColor"
        static let finalColorName = "ownGrayColor"
        static let loadingViewNibName = "LoadingView"
    }
}
