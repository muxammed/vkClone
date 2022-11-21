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
            translationX: source.view.frame.width / Constants.translationWidthDivider,
            y: Constants.translationY
        )
        let rotate = CGAffineTransform(scaleX: Constants.scaleValue, y: Constants.scaleValue)
        destination.view.transform = translate.concatenating(rotate)

        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: Constants.delayTimeInterval,
            options: .calculationModePaced,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: Constants.relativeStartTimeFirst,
                    relativeDuration: Constants.relativeDurationFirst
                ) {
                    let translation = CGAffineTransform(translationX: Constants.scaleValueFrom, y: Constants.scaleValueFrom)
                    let scale = CGAffineTransform(scaleX: Constants.scaleValueTo, y: Constants.scaleValueTo)
                    source.view.transform = translation.concatenating(scale)
                }

                UIView.addKeyframe(
                    withRelativeStartTime: Constants.relativeStartTimeSecond,
                    relativeDuration: Constants.relativeDurationSecond
                ) {
                    let translation = CGAffineTransform(translationX: Constants.translationX, y: source.view.frame.width * Constants.translationYMultiplier)
                    let scale = CGAffineTransform(rotationAngle: .pi / Constants.rotationPiDivider)
                    source.view.transform = translation.concatenating(scale)
                }

                UIView.addKeyframe(
                    withRelativeStartTime: Constants.relativeStartTimeThird,
                    relativeDuration: Constants.relativeDurationThird
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
        Constants.transitionDuration
    }
}

/// константы
extension CustomPopAnimator {
    enum Constants {
        static let scaleValue = 0.8
        static let transitionDuration = 0.6
        static let translationX = 200.0
        static let translationYMultiplier = 1.5
        static let delayTimeInterval = 0.0
        static let relativeStartTimeFirst = 0.0
        static let relativeStartTimeSecond = 0.2
        static let relativeStartTimeThird = 0.6
        static let relativeDurationFirst = 0.75
        static let relativeDurationSecond = 0.4
        static let relativeDurationThird = 0.4
        static let scaleValueFrom = 0.0
        static let scaleValueTo = 1.0
        static let translationWidthDivider = 50.0
        static let translationY = 0.0
        static let rotationPiDivider = -2.0
    }
}
