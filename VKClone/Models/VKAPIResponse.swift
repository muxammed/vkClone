// VKAPIResponse.swift
// Copyright © RoadMap. All rights reserved.

/// Рутовый ответ от ВК АПИ
struct VKAPIResponse: Codable {
    let response: VKResponse
}

/// Более нижняя ветвь
struct VKResponse: Codable {
    let count: Int
    let items: [VKFriend]
}
