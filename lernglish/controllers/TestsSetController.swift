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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self,
                                                            action: #selector(showNext))

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

    func showNext() {
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

class TestController: UIViewController {

    var testMo: TestMO? {
        didSet {
            guard let testMo = testMo,
                let content = testMo.content,
                let regex = try? NSRegularExpression(pattern: K.Test.pattern) else {
                    return
            }

            var firstPart: String?,
            secondPart: String?,
            hint: String?,
            answer: String?


            let nsContent = NSString(string: content)
            let range = NSRange(location: 0, length: nsContent.length)
            guard let match = regex.matches(in: content, range: range).first else {
                return
            }

            #if DEBUG
                print(nsContent.substring(with: match.rangeAt(0)))
            #endif

            if match.numberOfRanges > 3 {
                firstPart = nsContent.substring(with: match.rangeAt(1))
                secondPart = nsContent.substring(with: match.rangeAt(match.numberOfRanges - 1))
                answer = nsContent.substring(with: match.rangeAt(match.numberOfRanges - 2))

                if match.numberOfRanges > 4 {
                    hint = nsContent.substring(with: match.rangeAt(2))
                } else {
                    hint = answer
                }
            }

            if let test = Test(section: "", firstPart: firstPart, secondPart: secondPart, hint: hint, answer: answer) {
                self.test = test
            }
        }
    }
    private var test: Test! {
        didSet {
            lblFirstPart.text = test.firstPart
            lblSecondPart.text = test.secondPart

            let placeholderAttrs = [NSForegroundColorAttributeName: K.Color.gray]
            tfAnswer.attributedPlaceholder = NSAttributedString(string: test.hint, attributes: placeholderAttrs)

            // Calc answer view bounds based on answer's text
            let attrs = [NSFontAttributeName: tfAnswer.font]
            let size = CGSize(width: view.frame.width, height: CGFloat.greatestFiniteMagnitude)
            var bounds = NSString(string: test.answer).boundingRect(with: size, attributes: attrs, context: nil)
            bounds.size.width += 42
            bounds.size.height += 16

            let widthConstraint = NSLayoutConstraint(item: tfAnswer, attribute: .width, relatedBy: .equal, toItem: nil,
                                                     attribute: .notAnAttribute, multiplier: 0, constant: bounds.width)
            let heightConstraint = NSLayoutConstraint(item: tfAnswer, attribute: .height, relatedBy: .equal, toItem: nil,
                                                      attribute: .notAnAttribute, multiplier: 0, constant: bounds.height)
            tfAnswer.addConstraint(widthConstraint)
            tfAnswer.addConstraint(heightConstraint)
        }
    }

    private let lblFirstPart: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    private let lblSecondPart: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    private let tfAnswer: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.textAlignment = .center
        view.textColor = K.Color.primaryDark
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        for subview in [lblFirstPart, lblSecondPart] {
            view.addSubview(subview)
            view.addConstraintsWithFormat("H:|-16-[v0]-16-|", views: subview)
        }

        view.addSubview(tfAnswer)
        tfAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let topConstant: CGFloat = 4
        lblFirstPart.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 80).isActive = true
        tfAnswer.topAnchor.constraint(equalTo: lblFirstPart.bottomAnchor, constant: topConstant).isActive = true
        lblSecondPart.topAnchor.constraint(equalTo: tfAnswer.bottomAnchor, constant: topConstant).isActive = true
    }
}

private struct Test {
    let
    section: String,
    firstPart: String,
    secondPart: String,
    hint: String,
    answer: String

    init?(section: String?, firstPart: String?, secondPart: String?, hint: String?, answer: String?) {
        guard let section = section?.trimmingCharacters(in: .whitespacesAndNewlines),
                let firstPart = firstPart?.trimmingCharacters(in: .whitespacesAndNewlines),
                let secondPart = secondPart?.trimmingCharacters(in: .whitespacesAndNewlines),
                let hint = hint?.trimmingCharacters(in: .whitespacesAndNewlines),
                let answer = answer?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
        }

        self.section = section
        self.firstPart = firstPart
        self.secondPart = secondPart
        self.hint = hint
        self.answer = answer
    }
}
