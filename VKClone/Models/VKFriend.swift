// VKFriend.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift

/// Друг из ВК
final class VKFriend: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var nickname, trackCode: String?
    @objc dynamic var sex: Int
    @objc dynamic var photo100: String
    @objc dynamic var online: Int
    @objc dynamic var firstName, lastName: String

    enum CodingKeys: String, CodingKey {
        case id, nickname
        case trackCode = "track_code"
        case sex
        case photo100 = "photo_100"
        case online
        case firstName = "first_name"
        case lastName = "last_name"
    }

    override class func primaryKey() -> String? {
        "id"
    }
}
