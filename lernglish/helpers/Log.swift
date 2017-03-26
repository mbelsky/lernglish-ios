//
//  Log.swift
//  lernglish
//
//  Created by Maxim Belsky on 26/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import Foundation

class Log {
    static func d(_ log: String) {
        #if DEBUG
            print(log)
        #endif
    }
}
