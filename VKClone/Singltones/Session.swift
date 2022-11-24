// Session.swift
// Copyright © RoadMap. All rights reserved.

/// Сессия хранит данные токена и айди пользователя
final class Session {
    static let shared = Session()

    // MARK: - Public properties

    var token = ""
    var userId = ""
    var apiVersion = "5.131"

    // MARK: - Initializators

    private init() {}
}
