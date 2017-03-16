//
//  Extensions.swift
//  lernglish
//
//  Created by Maxim Belsky on 16/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init?(html: Int, alpha: CGFloat = 1) {
        if html < 0 || html > 0xFFFFFF {
            return nil
        }
        let r = (html & 0xFF0000) >> 16
        let g = (html & 0x00FF00) >> 8
        let b = (html & 0x0000FF)
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: alpha)
    }
}

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
