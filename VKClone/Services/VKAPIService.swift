// VKAPIService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation

/// Апи запросы
class VKAPIService {
    // MARK: - Public properties
    let baseUrl = "https://api.vk.com"
    var apiAccessToken = ""
    var apiUserId = ""
    let apiVersion = Session.instance.apiVersion

    // MARK: - Public methods
    func loadMyFriends() {
        let path = Constants.friendsGetPathString
        let parameters: Parameters = [
            Constants.accessTokenFieldName: apiAccessToken,
            Constants.userIdFieldName: apiUserId,
            Constants.versionFieldName: apiVersion,
            Constants.fieldsFieldName: [Constants.photoFieldName, Constants.nicknameFieldName, Constants.onlineFieldName, Constants.sexFieldName]
        ]
        let url = baseUrl + path
        AF.request(url, method: .post, parameters: parameters)
            .responseDecodable(of: VKAPIResponse.self) { data in
                debugPrint(data)
            }
    }

    func loadMyPhotos() {
        let path = Constants.getPhotosPathString
        let parameters: Parameters = [
            Constants.accessTokenFieldName: apiAccessToken,
            Constants.ownerIdFieldName: apiUserId,
            Constants.versionFieldName: apiVersion
        ]
        let url = baseUrl + path
        AF.request(url, method: .post, parameters: parameters)
            .response { data in
                debugPrint(data)
            }
    }

    func loadMyGroups() {
        let path = Constants.getGroupsPathString
        let parameters: Parameters = [
            Constants.accessTokenFieldName: apiAccessToken,
            Constants.userIdFieldName: apiUserId,
            Constants.versionFieldName: apiVersion
        ]
        let url = baseUrl + path
        AF.request(url, method: .post, parameters: parameters)
            .response { data in
                debugPrint(data)
            }
    }

    func searchMyGroups(by: String) {
        let path = Constants.searchGroupsByPathString
        let parameters: Parameters = [
            Constants.accessTokenFieldName: apiAccessToken,
            Constants.userIdFieldName: apiUserId,
            Constants.queryFieldName: by,
            Constants.versionFieldName: apiVersion
        ]
        let url = baseUrl + path
        AF.request(url, method: .post, parameters: parameters)
            .response { data in
                debugPrint(data)
            }
    }
}

/// Константы
extension VKAPIService {
    enum Constants {
        static let friendsGetPathString = "/method/friends.get"
        static let getPhotosPathString = "/method/photos.getAll"
        static let getGroupsPathString = "/method/groups.get"
        static let searchGroupsByPathString = "/method/groups.search"
        static let accessTokenFieldName = "access_token"
        static let userIdFieldName = "user_id"
        static let versionFieldName = "v"
        static let queryFieldName = "q"
        static let ownerIdFieldName = "owner_id"
        static let fieldsFieldName = "fields"
        static let nicknameFieldName = "nickname"
        static let photoFieldName = "photo_100"
        static let onlineFieldName = "online"
        static let sexFieldName = "sex"
    }
}
