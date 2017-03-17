//
//  LessonHeaderCell.swift
//  lernglish
//
//  Created by Maxim Belsky on 17/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import UIKit

class LessonHeaderCell: UICollectionReusableView {
    let label: UILabel = {
        let label = UILabel()
        label.font = K.Font.tableHeader
        label.textColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = K.Color.primary
        
        addSubview(label)
        addConstraintsWithFormat("H:|-16-[v0]-16-|", views: label)
        addConstraintsWithFormat("V:|[v0]|", views: label)
    }
}
