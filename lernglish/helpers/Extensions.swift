//
//  Extensions.swift
//  lernglish
//
//  Created by Maxim Belsky on 16/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(_ format: String,
                                  options: NSLayoutFormatOptions = NSLayoutFormatOptions(),
                                  metrics: [String: Any]? = nil, views: UIView...) {
        var viewsDict = [String: UIView]()
        for (index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict["v\(index)"] = view
        }
        
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: options,
                                                         metrics: metrics, views: viewsDict)
        addConstraints(constraints)
    }
}
