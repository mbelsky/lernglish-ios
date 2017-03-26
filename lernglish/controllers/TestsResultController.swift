//
//  TestsResultController.swift
//  lernglish
//
//  Created by Maxim Belsky on 26/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import UIKit

class TestsResultController: UIViewController {

    var correctAnswersCount = 0 {
        didSet {
            let medal: String
            let p: Float = Float(correctAnswersCount) / Float(totalTestsCount) * 100
            switch Int(p) {
            case let x where x > 80:
                medal = "🥇"
            case let x where x > 60:
                medal = "🥈"
            case let x where x > 0:
                medal = "🥉"
            default:
                medal = "💩"
            }

            lblMedal.text = medal
            lblDetail.text = "\(correctAnswersCount) of \(totalTestsCount)"
        }
    }
    var totalTestsCount = 0

    private let lblScore: UILabel = {
        let lbl = UILabel()
        lbl.font = K.Font.title
        lbl.text = "Your score:"
        lbl.textAlignment = .center
        return lbl
    }()
    private let lblMedal: UILabel = {
        let lbl = UILabel()
        lbl.font = K.Font.emojiLarge
        lbl.textAlignment = .center
        return lbl
    }()
    private let lblDetail: UILabel = {
        let lbl = UILabel()
        lbl.font = K.Font.title
        lbl.textAlignment = .center
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        for subview in [lblScore, lblMedal, lblDetail] {
            view.addSubview(subview)
            view.addConstraintsWithFormat("H:|-16-[v0]-16-|", views: subview)
        }
        lblMedal.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        lblScore.bottomAnchor.constraint(equalTo: lblMedal.topAnchor).isActive = true
        lblDetail.topAnchor.constraint(equalTo: lblMedal.bottomAnchor).isActive = true
    }
}
