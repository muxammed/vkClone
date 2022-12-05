// VKAPIService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation
import RealmSwift

/// Апи запросы
class VKAPIService {
    // MARK: - Public properties

    let baseUrl = "https://api.vk.com"
    var apiAccessToken = ""
    var apiUserId = ""
    let apiVersion = Session.shared.apiVersion

    // MARK: - Public methods

    func downloadImageFrom(urlString: URL, completion: @escaping (UIImage) -> Void) {
        let task = URLSession.shared.dataTask(with: urlString) { data, _, error in
            if error != nil {
                print(error ?? "")
            }
            guard let data = data,
                  let downloadedImage = UIImage(data: data) else { return }
            completion(downloadedImage)
        }
        task.resume()
    }

    func fetchMyFriends(completion: @escaping (Bool) -> Void) {
        apiAccessToken = Session.shared.token
        apiUserId = Session.shared.userId
        let path = Constants.friendsGetPathString
        let parameters: Parameters = [
            Constants.accessTokenFieldName: apiAccessToken,
            Constants.userIdFieldName: apiUserId,
            Constants.versionFieldName: apiVersion,
            Constants.fieldsFieldName: [
                Constants.photoFieldName,
                Constants.nicknameFieldName,
                Constants.onlineFieldName,
                Constants.sexFieldName
            ]
        ]
        let url = "\(baseUrl)\(path)"
        print(url)
        print(parameters)
        AF.request(
            url,
            method: .post,
            parameters: parameters
        )
        .responseDecodable { (response: DataResponse<VKAPIResponse<VKFriend>, AFError>) in
            print(response)
            if let friendsResponse = response.value {
                completion(self.saveMyFriends(friends: friendsResponse.response.items))

            } else {
                let errorResponse = response.error
                print(errorResponse?.localizedDescription ?? "")
            }
        }
    }

    func clearFriendsFromDB() -> Bool {
        do {
            let realm = try Realm()
            let friends = realm.objects(VKFriend.self)
            realm.beginWrite()
            realm.delete(friends)
            try realm.commitWrite()
            return true
        } catch {
            print(error)
            return false
        }
    }

    func loadMyFriendsFromDB() -> [VKFriend] {
        do {
            let realm = try Realm()
            let friends = realm.objects(VKFriend.self)
            return Array(friends)
        } catch {
            print(error)
            return []
        }
    }

    func saveMyFriends(friends: [VKFriend]) -> Bool {
        if clearFriendsFromDB() {
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.add(friends)
                try realm.commitWrite()
                return true
            } catch {
                print(error)
                return false
            }
        } else {
            return false
        }
    }

    func fetchMyPhotos() {
        let path = Constants.getPhotosPathString
        let parameters: Parameters = [
            Constants.accessTokenFieldName: apiAccessToken,
            Constants.ownerIdFieldName: apiUserId,
            Constants.versionFieldName: apiVersion
        ]
        let url = "\(baseUrl)\(path)"
        AF.request(url, method: .post, parameters: parameters)
            .response { data in
                debugPrint(data)
            }
    }

    func fetchMyGroups(completion: @escaping ([VKGroup]) -> Void) {
        let path = Constants.getGroupsPathString
        let parameters: Parameters = [
            Constants.accessTokenFieldName: apiAccessToken,
            Constants.userIdFieldName: apiUserId,
            Constants.versionFieldName: apiVersion,
            Constants.extendedFieldName: Constants.extendedFieldValue
        ]
        let url = "\(baseUrl)\(path)"
        AF.request(url, method: .post, parameters: parameters)
            .responseDecodable { (response: DataResponse<VKAPIResponse<VKGroup>, AFError>) in
                if let friendsResponse = response.value {
                    completion(friendsResponse.response.items)
                } else {
                    let errorResponse = response.error
                    print(errorResponse?.localizedDescription ?? "")
                }
            }
    }

    func fetchGroups(by: String) {
        let path = Constants.searchGroupsByPathString
        let parameters: Parameters = [
            Constants.accessTokenFieldName: apiAccessToken,
            Constants.userIdFieldName: apiUserId,
            Constants.queryFieldName: by,
            Constants.versionFieldName: apiVersion
        ]
        let url = "\(baseUrl)\(path)"
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
        static let extendedFieldName = "extended"
        static let extendedFieldValue = 1
    }
}
