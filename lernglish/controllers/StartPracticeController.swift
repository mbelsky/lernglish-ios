//
//  StartPracticeController.swift
//  lernglish
//
//  Created by Maxim Belsky on 15/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import GameKit
import UIKit

class StartPracticeController: UIViewController {
    private let btnStart: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = K.Color.primary
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btn.layer.cornerRadius = 2
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false

        btn.setTitle("Let's practice", for: .normal)
        btn.sizeToFit()

        return btn
    }()

    private var tests: [TestMO]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(btnStart)
        btnStart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnStart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(startPractice))
        btnStart.addGestureRecognizer(tapRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StorageHelper.instance.getTests { [weak self] tests in
            self?.tests = tests
            self?.btnStart.isEnabled = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        btnStart.isEnabled = false
    }

    func startPractice() {
        guard let tests = tests, tests.count > 0 else {
            let error = UIAlertController(title: nil, message: "No tests to practice", preferredStyle: .alert)
            error.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            present(error, animated: true, completion: nil)
            return
        }

        let controller = TestsSetController()
        let shuffledTests = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: tests)
        controller.tests = shuffledTests.prefix(upTo: 5).map { $0 as! TestMO }
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
}
