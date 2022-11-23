// VKAuthViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
import WebKit

/// экран авторизации и вызова запросов ВК АПИ
final class VKAuthViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet private var authWebView: WKWebView! {
        didSet { authWebView.navigationDelegate = self }
    }

    @IBOutlet private var groupSearchTextField: UITextField!

    // MARK: - Private properties

    private let apiService = VKAPIService()
    private var session = Session.instance

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthPage()
    }

    // MARK: - IBActions

    @IBAction private func loadFriendAction() {
        apiService.loadMyFriends()
    }

    @IBAction private func loadPhotosAction() {
        apiService.loadMyPhotos()
    }

    @IBAction private func loadGroupsAction() {
        apiService.loadMyGroups()
    }

    @IBAction private func searchGroupsAction() {
        apiService.searchMyGroups(by: groupSearchTextField.text ?? "")
    }

    // MARK: - Private methods

    private func loadAuthPage() {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.schemaValue
        urlComponents.host = Constants.hostValue
        urlComponents.path = Constants.pathValue
        urlComponents.queryItems = [
            URLQueryItem(name: Constants.clientIdFieldName, value: Constants.clientIdValue),
            URLQueryItem(name: Constants.displayFieldName, value: Constants.displayValue),
            URLQueryItem(name: Constants.redirectUrlFieldName, value: Constants.redirectUrlValue),
            URLQueryItem(name: Constants.scopeFieldName, value: Constants.scopeValue),
            URLQueryItem(name: Constants.respondeTypeFieldName, value: Constants.respondeTypeValue),
            URLQueryItem(name: Constants.versionFieldName, value: Constants.versionValue)
        ]
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)

        authWebView.load(request)
    }
}

/// WKNavigationDelegate
extension VKAuthViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        guard let url = navigationResponse.response.url,
              url.path == Constants.blankPathValue,
              let fragment = url.fragment
        else { decisionHandler(.allow)
            return
        }

        let params = fragment.components(separatedBy: Constants.appersandSign)
            .map { $0.components(separatedBy: Constants.equalSign) }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }

        let token = params[Constants.accessToken]
        let userId = params[Constants.userId]
        Session.instance.userId = userId ?? ""
        Session.instance.token = token ?? ""
        apiService.apiAccessToken = token ?? ""
        apiService.apiUserId = userId ?? ""
        authWebView.removeFromSuperview()
        decisionHandler(.cancel)
    }
}

/// Константы
extension VKAuthViewController {
    enum Constants {
        static let accessToken = "access_token"
        static let userId = "user_id"
        static let schemaValue = "https"
        static let hostValue = "oauth.vk.com"
        static let pathValue = "/authorize"
        static let blankPathValue = "/blank.html"
        static let clientIdFieldName = "client_id"
        static let clientIdValue = "51468498"
        static let displayFieldName = "display"
        static let displayValue = "mobile"
        static let redirectUrlFieldName = "redirect_url"
        static let redirectUrlValue = "https://oauth.vk.com/blank.html"
        static let scopeFieldName = "scope"
        static let scopeValue = "262150"
        static let respondeTypeFieldName = "response_type"
        static let respondeTypeValue = "token"
        static let versionFieldName = "v"
        static let versionValue = "5.68"
        static let equalSign = "="
        static let appersandSign = "&"
    }
}
