//
//  AppDelegate.swift
//  IOS6-HW26-AlekseiKudinov
//
//  Created by Алексей Кудинов on 21.08.2022.
//

import Foundation
import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let viewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}


