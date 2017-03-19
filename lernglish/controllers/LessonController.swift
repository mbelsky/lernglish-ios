//
//  LessonController.swift
//  lernglish
//
//  Created by Maxim Belsky on 17/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import CoreData
import UIKit
import WebKit

class LessonController: UIViewController {
    var sectionName: String?
    weak var theme: ThemeMO?

    fileprivate var textView: UITextView!

    override func loadView() {
        textView = UITextView(frame: .zero)
        view = textView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self,
                                                           action: #selector(closeController))

        navigationItem.prompt = sectionName
        navigationItem.title = theme?.name

        guard let html = wrapContent(theme?.content) else {
            closeController()
            return
        }

        DispatchQueue.global(qos: .userInteractive).async {
            if let data = html.data(using: .unicode, allowLossyConversion: true),
                    let text = try? NSAttributedString(data: data,
                                                       options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                       documentAttributes: nil) {
                DispatchQueue.main.async {
                    self.textView.attributedText = text
                }
            }
        }
    }
    
    func closeController() {
        dismiss(animated: true, completion: nil)
    }

    private func wrapContent(_ content: String?) -> String? {
        if let content = content {
            return "<html><body>" + content + "</body></html>"
        } else {
            return nil
        }
    }
}
