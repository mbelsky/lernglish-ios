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
    var sectionName: String?
    weak var theme: ThemeMO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self,
                                                           action: #selector(closeController))

        navigationItem.prompt = sectionName
        navigationItem.title = theme?.name
    }
    
    func closeController() {
        dismiss(animated: true, completion: nil)
    }
}
