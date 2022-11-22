// CustomInteractiveTransition.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Интерактивный транзиншн
final class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    // MARK: - Public properties

    var viewController: UIViewController? {
        didSet { let recognizer = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(handleScreenEdgeGestureAction)
        )
        recognizer.edges = [.left]
        viewController?.view.addGestureRecognizer(recognizer)
        }
    }

    var isHasStarted: Bool = false
    var isShouldFinish: Bool = false

    // MARK: - Private methods

    @objc private func handleScreenEdgeGestureAction(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            isHasStarted = true
            viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            isShouldFinish = progress > 0.33
            update(progress)
        case .ended:
            isHasStarted = false
            isShouldFinish ? finish() : cancel()
        case .cancelled:
            isHasStarted = false
            cancel()
        default: return
        }
    }
}
