//
//  SnappingFlowLayout.swift
//  MyMovie
//
//  Created by Ricardo Prestes on 27/10/25.
//

import UIKit

class SnappingFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let targetRect = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)
        guard let layoutAttributes = super.layoutAttributesForElements(in: targetRect) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let horizontalCenter = proposedContentOffset.x + collectionView.bounds.width / 2
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        
        for layoutAttribute in layoutAttributes {
            let itemHorizontalCenter = layoutAttribute.center.x
            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
