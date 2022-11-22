// Session.swift
// Copyright © RoadMap. All rights reserved.

/// Сессия хранит данные токена и айди пользователя
class Session {
    var token = ""
    var userId = ""

    static let instance = Session()

    private init() {}
}
