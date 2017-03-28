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
        let btn = GreenButton()
        btn.backgroundColor = K.Color.primary
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btn.isHidden = true
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false

        btn.setTitle("Let's practice", for: .normal)
        btn.sizeToFit()

        return btn
    }()
    private let lblEmpty: UILabel = {
        let lbl = UILabel()
        lbl.font = K.Font.default
        lbl.isHidden = true
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = K.Color.primaryDark
        lbl.text = "Read a few themes to test your knowledge"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private var tests: [TestMO]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        for subview in [lblEmpty, btnStart] {
            view.addSubview(subview)
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }

        lblEmpty.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addConstraintsWithFormat("H:|-16-[v0]-16-|", views: lblEmpty)

        view.addConstraintsWithFormat("H:|-60-[v0]-60-|", views: btnStart)
        let btnHeightConstraint = NSLayoutConstraint(item: btnStart, attribute: .height, relatedBy: .equal,
                                                     toItem: btnStart, attribute: .width, multiplier: 1, constant: 0)
        btnStart.addConstraint(btnHeightConstraint)
        btnStart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(startPractice))
        btnStart.addGestureRecognizer(tapRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StorageHelper.instance.getTests { [weak self] tests in
            self?.tests = tests
            if let tests = tests, tests.count > 0 {
                self?.btnStart.isHidden = false
                self?.lblEmpty.isHidden = true
            } else {
                self?.lblEmpty.isHidden = false
                self?.btnStart.isHidden = true
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if 0 == btnStart.layer.cornerRadius {
            btnStart.layer.cornerRadius = btnStart.bounds.width / 2
        }
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

        let count: Int
        #if DEBUG
            count = 3
        #else
            count = 5
        #endif
        controller.tests = shuffledTests.prefix(upTo: count).map { $0 as! TestMO }

        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
}

private class GreenButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? K.Color.primaryDark : K.Color.primary
        }
    }
}
