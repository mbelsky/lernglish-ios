//
//  LessonsController.swift
//  lernglish
//
//  Created by Maxim Belsky on 15/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import UIKit

class LessonsController: UICollectionViewController {
    fileprivate let cellId = "LessonsCellId"
    fileprivate let headerId = "HeaderCellId"
    fileprivate var
    orderedCategories = ["Present Simple", "Past Simple"],
    themes = [
        "Present Simple": ["Use", "Questions and negatives"],
        "Past Simple": ["Use", "Questions and negatives", "Irregular Verb Forms"]
    ]
    
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(LessonCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(LessonHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: headerId)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if 0 == collectionView?.constraints.count {
            view.addConstraintsWithFormat("H:|[v0]|", views: collectionView!)
            
            let format = "V:|-\(topLayoutGuide.length)-[v0]-\(bottomLayoutGuide.length)-|"
            view.addConstraintsWithFormat(format, views: collectionView!)
        }
    }
}

// Implement protocols
extension LessonsController: UICollectionViewDelegateFlowLayout {
    private func getThemes(_ section: Int) -> [String] {
        return themes[orderedCategories[section]] ?? [String]()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return orderedCategories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getThemes(section).count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LessonCell
        cell.label.text = getThemes(indexPath.section)[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Headers
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId,
                                                                     for: indexPath) as! LessonHeaderCell
        header.label.text = orderedCategories[indexPath.section]
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 48)
    }
}
