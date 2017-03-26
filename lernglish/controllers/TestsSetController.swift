//
//  TestsSetController.swift
//  lernglish
//
//  Created by Maxim Belsky on 24/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import UIKit

class TestsSetController: UIViewController {

    var tests: [TestMO]!

    private var testControllers = [TestController]()

    private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.gestureRecognizers = nil
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.scrollsToTop = false
        return view
    }()

    fileprivate var correctAnswersCount = 0

    private var currentPage = -1 {
        didSet {
            displayPage(currentPage)
        }
    }
    private var pagesCount: Int {
        return tests.count + 1
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self,
                                                           action: #selector(closeController))

        view.backgroundColor = .white
        view.addSubview(scrollView)

        view.addConstraintsWithFormat("H:|[v0]|", views: scrollView)
        scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if 0 == testControllers.count {
            scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(pagesCount), height: view.frame.height)
            currentPage = 0
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        try? StorageHelper.instance.save()
    }

    func closeController() {
        dismiss(animated: true, completion: nil)
    }

    fileprivate func showNext() {
        currentPage += 1
    }

    private func displayPage(_ page: Int) {
        loadPage(page - 1)
        loadPage(page)
        loadPage(page + 1)

        // Update scroll view content offset
        var bounds = scrollView.bounds
        bounds.origin.x = bounds.width * CGFloat(page)
        bounds.origin.y = 0
        scrollView.scrollRectToVisible(bounds, animated: true)

        navigationItem.title = pagesCount - 1 > page ? "\(page + 1) of \(pagesCount - 1)" : "Results"
    }

    private func loadPage(_ page: Int) {
        guard -1 < page && page < pagesCount - 1 else {
            // something went wrong
            return
        }

        let controller: TestController
        if testControllers.count > page {
            controller = testControllers[page]
        } else {
            controller = TestController()
            controller.delegate = self
            controller.testMo = tests[page]
            testControllers.insert(controller, at: page)
        }

        if nil == controller.view.superview {
            var controllerFrame = scrollView.frame
            controllerFrame.origin.x = controllerFrame.width * CGFloat(page)
            controllerFrame.origin.y = 0
            controller.view.frame = controllerFrame

            addChildViewController(controller)
            scrollView.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
        }
    }
}

extension TestsSetController: TestControllerDelegate {
    func testController(_ controller: TestController, didGetAnswer isCorrect: Bool) {
        correctAnswersCount += isCorrect ? 1 : 0
        showNext()
    }
}
