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
    fileprivate var
    orderedCategories = ["Present Simple", "Past Simple"],
    themes = ["Present Simple": ["Use", "Questions and negatives"], "Past Simple": ["Use", "Questions and negatives", "Irregular Verb Forms"]]
    
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
        return CGSize(width: view.bounds.width, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
