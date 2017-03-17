//
//  RootTabController.swift
//  lernglish
//
//  Created by Maxim Belsky on 15/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import UIKit

class RootTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        view.backgroundColor = K.Color.primaryDark
        
        let sView = view.subviews[0]
        view.addConstraintsWithFormat("H:|[v0]|", views: sView)
        sView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        sView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
    }
}
