//
//  ScoreCell.swift
//  lernglish
//
//  Created by Maxim Belsky on 27/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import UIKit

class ScoreCell: UICollectionViewCell {
    let lblTheme: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = K.Font.tableRow
        return label
    }()
    let lblValue: UILabel = {
        let label = UILabel()
        label.font = K.Font.tableRow
        return label
    }()
    private let viewSeparator: UIView = {
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
        addSubview(lblTheme)
        addSubview(lblValue)
        addSubview(viewSeparator)

        addConstraintsWithFormat("H:|-16-[v0]-8-[v1]-16-|", views: lblTheme, lblValue)
        addConstraintsWithFormat("V:|-8-[v0]-8-[v1(1)]|", views: lblTheme, viewSeparator)
        addConstraintsWithFormat("H:|[v0]|", views: viewSeparator)

        lblValue.centerYAnchor.constraint(equalTo: lblTheme.centerYAnchor).isActive = true
    }
}
