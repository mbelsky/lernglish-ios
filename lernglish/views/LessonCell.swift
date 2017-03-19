//
//  LessonCell.swift
//  lernglish
//
//  Created by Maxim Belsky on 16/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import UIKit

class LessonCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.font = K.Font.tableRow
        return label
    }()
    var lessonIsStudied = false {
        didSet {
            label.textColor = lessonIsStudied ? K.Color.primaryDark : UIColor.black
        }
    }
    fileprivate let viewSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(label)
        addSubview(viewSeparator)

        addConstraintsWithFormat("H:|-16-[v0]-16-|", views: label)
        addConstraintsWithFormat("V:|-8-[v0]-8-[v1(1)]|", views: label, viewSeparator)
        addConstraintsWithFormat("H:|[v0]|", views: viewSeparator)
    }
}
