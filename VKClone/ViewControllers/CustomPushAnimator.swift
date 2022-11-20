// CustomPushAnimator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Кастомный пуш
final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: - Public mehots

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to) else { return }

        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame

        let translate = CGAffineTransform(
            translationX: 200,
            y: source.view.frame.width * 1.5
        )
        let rotate = CGAffineTransform(rotationAngle: .pi / -2)
        destination.view.transform = translate.concatenating(rotate)

        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .calculationModePaced,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.75
                ) {
                    let translation = CGAffineTransform(translationX: 0, y: 0)
                    let scale = CGAffineTransform(scaleX: Constants.scaleValue, y: Constants.scaleValue)
                    source.view.transform = translation.concatenating(scale)
                }

                UIView.addKeyframe(
                    withRelativeStartTime: 0.2,
                    relativeDuration: 0.4
                ) {
                    let translation = CGAffineTransform(translationX: source.view.frame.width / 50, y: 0)
                    let scale = CGAffineTransform(scaleX: 1, y: 1)
                    destination.view.transform = translation.concatenating(scale)
                }

                UIView.addKeyframe(
                    withRelativeStartTime: 0.6,
                    relativeDuration: 0.4
                ) {
                    destination.view.transform = .identity
                }
            }, completion: { finished in
                if finished, !transitionContext.transitionWasCancelled {
                    source.view.transform = .identity
                }
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
            }
        )
    }
}

/// константы
extension CustomPushAnimator {
    enum Constants {
        static let scaleValue = 0.8
    }
}
