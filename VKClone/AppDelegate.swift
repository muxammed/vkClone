// AppDelegate.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift
import UIKit

/// AppDelegate
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = configuration
        return true
    }
}
