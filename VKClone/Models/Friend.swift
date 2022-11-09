// Friend.swift
// Copyright © RoadMap. All rights reserved.

/// друг
struct Friend {
    let friendNickName: String
    let friendImageName: String
    let friendGroupName: String
    let photos: [Photo]
}

/// для удобного выявления уникальных первых букв в имени друга
extension Friend: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendNickName.first)
    }

    static func == (lhs: Friend, rhs: Friend) -> Bool {
        lhs.friendNickName.first == rhs.friendNickName.first
    }
}

/// фотографий
struct Photo {
    let photoName: String
    let likesCount: Int
}
