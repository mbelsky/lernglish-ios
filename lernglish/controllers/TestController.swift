//
//  TestController.swift
//  lernglish
//
//  Created by Maxim Belsky on 25/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import UIKit

class TestController: UIViewController {

    weak var delegate: TestControllerDelegate?
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

            Log.d(nsContent.substring(with: match.rangeAt(0)))

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

        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.keyboardType = .asciiCapable
        view.returnKeyType = .done
        view.spellCheckingType = .no

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

        tfAnswer.delegate = self
    }

    fileprivate func analyzeAnswer(in textField: UITextField) {
        guard let answer = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
                !answer.isEmpty else {
            return
        }

        let replacePairs = [
            ("don't", "do not"),
            ("doesn't", "does not"),
            ("'ll", " will"),
            ("won't", "will not")
        ]
        let expandedAnswer = replacePairs.reduce(answer) { string, pair in
            string.replacingOccurrences(of: pair.0, with: pair.1)
        }

        let isAnswerCorrect = expandedAnswer == test.answer
        StorageHelper.instance.increaseScore(for: testMo!, isCorrect: isAnswerCorrect)
        Log.d("Answers: original='\(test.answer)' received='\(answer)' expanded='\(expandedAnswer)' isCorrect=\(isAnswerCorrect)")

        DispatchQueue.main.async {
            self.delegate?.testController(self, didGetAnswer: isAnswerCorrect)
        }
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
    }
}

extension TestController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        analyzeAnswer(in: textField)
        return true
    }
}

protocol TestControllerDelegate: class {
    func testController(_ controller: TestController, didGetAnswer isCorrect: Bool)
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
            let answer = answer?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else {
                return nil
        }

        self.section = section
        self.firstPart = firstPart
        self.secondPart = secondPart
        self.hint = hint
        self.answer = answer
    }
}
