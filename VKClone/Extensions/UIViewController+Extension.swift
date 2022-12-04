// UIViewController+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// универсальный алерт
extension UIViewController {
    func showAlert(title: String, message: String, okeyAction: UIAlertAction) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(okeyAction)
        present(alertController, animated: true, completion: nil)
    }
}
