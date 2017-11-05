//
//  AnimateItemCollectionLayout.swift
//  Ogenii
//
//  Created by Ky Nguyen on 4/6/17.
//  Copyright © 2017 Ogenii. All rights reserved.
//

import UIKit


class knAnimateItemCollectionLayout : UICollectionViewFlowLayout {
    
    enum knAnimateItemType {
        case zoom, move
    }
    
    var animationType = knAnimateItemType.zoom
    
    convenience init(animationType: knAnimateItemType) {
        self.init()
        self.animationType = animationType
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var insertingIndexPaths = [IndexPath]()
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        insertingIndexPaths.removeAll()
        
        for update in updateItems {
            if let indexPath = update.indexPathAfterUpdate, update.updateAction == .insert {
                insertingIndexPaths.append(indexPath)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertingIndexPaths.removeAll()
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        attributes?.alpha = 0.0
        attributes?.transform = animationType == .zoom ?
            CGAffineTransform(scaleX: 0.1, y: 0.1) :
            CGAffineTransform(translationX: 0, y: 500.0)
        
        return attributes
    }
}


