//
//  LessonsListController.swift
//  lernglish
//
//  Created by Maxim Belsky on 15/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import CoreData
import UIKit

class LessonsListController: UICollectionViewController {
    fileprivate let cellId = "LessonsCellId"
    fileprivate let headerId = "HeaderCellId"
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        return StorageHelper.instance!.getLessonsFetchedResultsController()
    }()
    
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
        
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
}

// Implement protocols
extension LessonsListController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = fetchedResultsController.sections![section]
        return section.numberOfObjects
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let theme = fetchedResultsController.object(at: indexPath) as! ThemeMO
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LessonCell
        cell.label.text = theme.name!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = UINavigationController(rootViewController: LessonController())
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        present(controller, animated: true, completion: nil)
    }
    
    // Headers
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId,
                                                                     for: indexPath) as! LessonHeaderCell
        let section = fetchedResultsController.sections![indexPath.section]
        header.label.text = section.name
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 48)
    }
}

extension LessonsListController: NSFetchedResultsControllerDelegate {
}
