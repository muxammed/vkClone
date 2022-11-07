// Friend.swift
// Copyright © RoadMap. All rights reserved.

/// модель друзей
struct Friend {
    let friendNickName: String
    let friendImageName: String
    let friendGroupName: String
    let photos: [Photo]
}

/// модель фотографий
struct Photo {
    let photoName: String
    let likesCount: Int
}
