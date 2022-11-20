// CustomPopAnimator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// катом поп
final class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: - Public mehotds

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to) else { return }

        transitionContext.containerView.insertSubview(destination.view, at: 0)
        destination.view.frame = source.view.frame

        let translate = CGAffineTransform(
            translationX: source.view.frame.width / 50,
            y: 0
        )
        let rotate = CGAffineTransform(scaleX: Constants.scaleValue, y: Constants.scaleValue)
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
                    let scale = CGAffineTransform(scaleX: 1, y: 1)
                    source.view.transform = translation.concatenating(scale)
                }

                UIView.addKeyframe(
                    withRelativeStartTime: 0.2,
                    relativeDuration: 0.4
                ) {
                    let translation = CGAffineTransform(translationX: 200, y: source.view.frame.width * 1.5)
                    let scale = CGAffineTransform(rotationAngle: .pi / -2)
                    source.view.transform = translation.concatenating(scale)
                }

                UIView.addKeyframe(
                    withRelativeStartTime: 0.6,
                    relativeDuration: 0.4
                ) {
                    destination.view.transform = .identity
                }
            }, completion: { finished in
                if finished, !transitionContext.transitionWasCancelled {
                    source.removeFromParent()
                    destination.view.transform = .identity
                    transitionContext.completeTransition(true)
                }
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
            }
        )
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.6
    }
}

/// константы
extension CustomPopAnimator {
    enum Constants {
        static let scaleValue = 0.8
    }
}
