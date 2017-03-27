//
//  LessonController.swift
//  lernglish
//
//  Created by Maxim Belsky on 17/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import CoreData
import UIKit

class LessonController: UIViewController {
    weak var theme: ThemeMO?

    fileprivate var textView = UITextView(frame: .zero)
    private let aiSpinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.activityIndicatorViewStyle = .whiteLarge
        view.color = K.Color.primaryDark
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func loadView() {
        view = textView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        view.addSubview(aiSpinner)
        aiSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        aiSpinner.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        aiSpinner.startAnimating()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self,
                                                           action: #selector(closeController))

        navigationItem.prompt = theme?.section?.name
        navigationItem.title = theme?.name

        displayContent()
    }
    
    func closeController() {
        dismiss(animated: true) {
            if let theme = self.theme {
                let value = UIDevice.current.isSimulator ? !theme.isStudied : true
                theme.isStudied = value
                try? StorageHelper.instance.save()
            }
        }
    }

    private func displayContent() {
        DispatchQueue.global(qos: .userInteractive).async {
            let text: NSAttributedString?

            let html = self.wrapContent(self.theme?.content)
            if let data = html?.data(using: .unicode, allowLossyConversion: true) {
                text = try? NSAttributedString(data: data,
                                               options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                               documentAttributes: nil)
            } else {
                text = nil
            }

            DispatchQueue.main.async {
                self.aiSpinner.stopAnimating()

                if let text = text {
                    let transition = CATransition()
                    transition.duration = 0.7
                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    transition.type = kCATransitionFade
                    self.textView.layer.add(transition, forKey: kCATransitionFade)
                    self.textView.attributedText = text
                } else {
                    self.showErrorAlert()
                }
            }
        }
    }

    private func wrapContent(_ content: String?) -> String? {
        if let content = content {
            return "<html><body>" + content + "</body></html>"
        } else {
            return nil
        }
    }

    private func showErrorAlert() {
        let alert = UIAlertController(title: nil, message: "Unable to display this lesson's content",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
}
