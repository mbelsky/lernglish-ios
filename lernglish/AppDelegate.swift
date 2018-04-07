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

        window?.rootViewController = buildRootController()

        let viewStatusBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
                                                 height: application.statusBarFrame.height))
        viewStatusBar.backgroundColor = K.Color.primaryDark
        window?.rootViewController?.view.addSubview(viewStatusBar)

        setAppAppearance()

        StorageHelper.instance.importBaseSections()
        StorageHelper.instance.importBaseTests()

        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        try? StorageHelper.instance.save()
    }

    private func buildRootController() -> UIViewController {
        let lessons = LessonsListController()
        lessons.tabBarItem = UITabBarItem(title: "Themes", image: #imageLiteral(resourceName: "ic_themes"), selectedImage: nil)
        let tests = StartPracticeController()
        tests.tabBarItem = UITabBarItem(title: "Practice", image: #imageLiteral(resourceName: "ic_practice"), selectedImage: nil)
        let results = ScoreController()
        results.tabBarItem = UITabBarItem(title: "Score", image: #imageLiteral(resourceName: "ic_score"), selectedImage: nil)

        let controller = RootTabController()
        controller.setViewControllers([lessons, tests, results], animated: true)
        return controller
    }

    private func setAppAppearance() {
        UITabBar.appearance().barTintColor = K.Color.lightGray
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = K.Color.primaryDark

        UINavigationBar.appearance().barTintColor = K.Color.primaryDark
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}
