// LoginViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// экран логина
final class LoginViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var inputBackView: UIView!
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var imageHeightConstraint: NSLayoutConstraint!

    // MARK: - Private properties

    private var buttonConfiguration: UIButton.Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.background.backgroundColor = UIColor(named: Constants.ownDisabledColor)
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        container.foregroundColor = UIColor(named: Constants.ownBackColor)
        configuration.attributedTitle = AttributedString(Constants.loginTitle, attributes: container)
        return configuration
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addNotificationsAction()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserversAction()
    }

    // MARK: - Public methods

    @objc private func keyboardWasShownAction(notification: Notification) {
        if let info = notification.userInfo as NSDictionary?,
           let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)?.cgRectValue.size
        {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            let buttonRect = CGRect(
                x: loginButton.frame.midX,
                y: loginButton.frame.minY + 10,
                width: loginButton.frame.width,
                height: loginButton.frame.height
            )
            scrollView.scrollRectToVisible(buttonRect, animated: true)
            imageWidthConstraint.constant = 80
            imageHeightConstraint.constant = 80
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillBeHiddenAction(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        imageWidthConstraint.constant = 100
        imageHeightConstraint.constant = 100
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func hideKeyboardAction() {
        scrollView.endEditing(true)
    }

    @IBAction func goToLoginAction(_ sender: Any) {
        scrollView.endEditing(true)
        guard let username = usernameTextField.text, username.trimmingCharacters(in: [" "]) == Constants.username,
              let password = passwordTextField.text, password.trimmingCharacters(in: [" "]) == Constants.password
        else {
            showAlert(title: "", message: Constants.alertMessage)
            return
        }

        UserDefaults.standard.set(true, forKey: Constants.isLoggedInText)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Private methods

    private func removeObserversAction() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func addNotificationsAction() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasShownAction),
            name:
            UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHiddenAction(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAction))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
    }

    private func setupViews() {
        inputBackView.layer.borderColor = UIColor(named: Constants.ownStrokeColor)?.cgColor
        inputBackView.layer.borderWidth = 1
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.configuration = buttonConfiguration
    }
}

/// расширения константы
extension LoginViewController {
    enum Constants {
        static let ownStrokeColor = "ownStrokeColor"
        static let ownBlueColor = "ownBlueColor"
        static let ownDisabledColor = "ownDisabledColor"
        static let ownBackColor = "ownBackColor"
        static let loginTitle = "Sing In"
        static let username = "muxammed"
        static let password = "pass"
        static let alertMessage = """
        Username or Password is wrong.
        Please try again
        """
        static let okeyText = "Okey"
        static let isLoggedInText = "isLoggedIn"
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okeyAction = UIAlertAction(title: Constants.okeyText, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.usernameTextField.becomeFirstResponder()
        })
        alertController.addAction(okeyAction)
        present(alertController, animated: true, completion: nil)
    }
}

/// UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text,
              case let isTrue = usernameTextField.text?.count == 0 ||
              passwordTextField.text?.count == 0 ||
              text.count == 0
        else { return true }
        buttonConfiguration.background.backgroundColor = UIColor(
            named: isTrue ?
                Constants.ownDisabledColor : Constants.ownBlueColor
        )
        loginButton.configuration = buttonConfiguration
        view.layoutIfNeeded()
        return true
    }
}
