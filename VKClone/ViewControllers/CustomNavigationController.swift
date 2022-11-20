// CustomNavigationController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Кастомный UINavigationController
final class CustomNavigationController: UINavigationController {
    // MARK: - Private properties

    private let interactiveTransition = CustomInteractiveTransition()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

// MARK: - UINavigationControllerDelegate
extension CustomNavigationController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            interactiveTransition.viewController = toVC
            return CustomPushAnimator()
        case .pop:
            if navigationController.viewControllers.first != toVC {
                interactiveTransition.viewController = toVC
            }
            return CustomPopAnimator()
        default:
            return nil
        }
    }

    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        interactiveTransition.hasStarted ? interactiveTransition : nil
    }
}
