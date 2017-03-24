//
//  AppDelegate.swift
//  lernglish
//
//  Created by Maxim Belsky on 15/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let lessons = LessonsListController()
        lessons.tabBarItem = UITabBarItem(title: "Lessons", image: nil, selectedImage: nil)
        let tests = StartPracticeController()
        tests.tabBarItem = UITabBarItem(title: "Tests", image: nil, selectedImage: nil)
        let results = ResultsController()
        results.tabBarItem = UITabBarItem(title: "Results", image: nil, selectedImage: nil)

        let controller = RootTabController()
        controller.setViewControllers([lessons, tests, results], animated: true)
        window?.rootViewController = controller

        UITabBar.appearance().barTintColor = K.Color.lightGray
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = K.Color.primaryDark

        UINavigationBar.appearance().barTintColor = K.Color.lightGray
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = K.Color.primaryDark

        StorageHelper.instance.importBaseSections()
        StorageHelper.instance.importBaseTests()

        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        try? StorageHelper.instance.save()
    }
}
