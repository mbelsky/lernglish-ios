//
//  Constants.swift
//  lernglish
//
//  Created by Maxim Belsky on 17/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import UIKit

struct K {

    struct Color {
        static let primary = UIColor(html: 0x22B13B)!
        static let primaryDark = UIColor(html: 0x1E9F35)!
        
        static let lightGray = UIColor(html: 0xEEEEEE)!
        static let gray = UIColor.gray
    }
    
    struct Font {
        static let `default` = UIFont.systemFont(ofSize: 16.5, weight: UIFont.Weight(rawValue: 0))
        static let emojiLarge = UIFont.systemFont(ofSize: 120, weight: UIFont.Weight(rawValue: 0))
        static let tableHeader = UIFont.systemFont(ofSize: 12.5, weight: UIFont.Weight(rawValue: 0.25))
        static let tableRow = Font.default
        static let title = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 0.4))
    }

    struct Test {
        static let pattern = "(.*)<([^\\|]*)\\|?([^\\|]*)>(.*)"
    }
}
