// VKGroup.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift

/// Группа ВК
final class VKGroup: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var name: String
    @objc dynamic var photoUrl: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case photoUrl = "photo_100"
    }
}
