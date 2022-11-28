// VKAPIResponse.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift

/// Рутовый дженерик ответ от ВК АПИ
struct VKAPIResponse<T>: Decodable where T: Decodable {
    let response: VKResponse

    /// Более нижняя ветвь
    struct VKResponse: Decodable {
        let count: Int
        let items: [T]
    }
}
