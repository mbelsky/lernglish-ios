//
//  ScoreController.swift
//  lernglish
//
//  Created by Maxim Belsky on 15/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import CoreData
import UIKit

class ScoreController: UICollectionViewController {

    fileprivate let cellId = "ThemeCellId"
    fileprivate let headerId = "HeaderCellId"

    fileprivate let frc: NSFetchedResultsController<NSFetchRequestResult> = {
        StorageHelper.instance.frcGetAnsweredThemes()
    }()

    private let lblEmpty: UILabel = {
        let lbl = UILabel()
        lbl.isHidden = true
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = K.Color.primaryDark
        lbl.font = K.Font.title
        lbl.text = "You have not practised yet"
        return lbl
    }()
    private let lblAction: UILabel = {
        let lbl = UILabel()
        lbl.isHidden = true
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = K.Color.primaryDark
        lbl.font = K.Font.default
        lbl.text = "Take a few tests and come back to see your results"
        return lbl
    }()

    init(_ layout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for subview in [lblEmpty, lblAction] {
            view.addSubview(subview)
            view.addConstraintsWithFormat("H:|-16-[v0]-16-|", views: subview)
        }
        lblEmpty.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        lblAction.topAnchor.constraint(equalTo: lblEmpty.bottomAnchor, constant: 4).isActive = true

        collectionView?.backgroundColor = .white
        collectionView?.register(ScoreCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(LessonHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: headerId)

        frc.delegate = self
        try! frc.performFetch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLblEmptyVisibility()
    }

    fileprivate func setLblEmptyVisibility() {
        let hidden: Bool
        if let objects = frc.fetchedObjects, objects.count > 0 {
            hidden = true
        } else {
            hidden = false
        }

        let _ = [lblEmpty, lblAction].map { $0.isHidden = hidden }
    }
}

extension ScoreController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return frc.sections?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = frc.sections![section]
        return section.numberOfObjects
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let theme = frc.object(at: indexPath) as! ThemeMO
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScoreCell

        cell.lblTheme.text = theme.name
        cell.lblValue.text = "\(Int(theme.score!.ratio))%"
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
        let section = frc.sections![indexPath.section]
        header.label.text = section.name
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 48)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ScoreController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        setLblEmptyVisibility()
        collectionView?.reloadData()
    }
}
