//
//  TestsSetController.swift
//  lernglish
//
//  Created by Maxim Belsky on 24/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import UIKit

class TestsSetController: UIPageViewController {

    var tests: [TestMO]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self,
                                                           action: #selector(closeController))
    }

    func closeController() {
        dismiss(animated: true, completion: nil)
    }
}
