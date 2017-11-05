
//
//  knTagView.swift
//  knTagView
//
//  Created by Ky Nguyen on 11/29/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

protocol knTagSelectionDelegate {
    
    func didSelectTag(tag: knTag, atIndex index: Int)
}

class knTagView : UIView {
    
    let activeBackgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    let inactiveBackgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    
    let cellId = "cellId"
    var tags = [
        knTag(text: "iOS"),
        knTag(text: "mobile developement: iOS "),
        knTag(text: "ambition"),
        knTag(text: "vision")
        ] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: CenterAlignedCollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        addSubview(collectionView)
        
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView.register(knTagCell.self, forCellWithReuseIdentifier: cellId)
    }
    
}

extension knTagView : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! knTagCell
        configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cell = knTagCell()
        configureCell(cell, forIndexPath: indexPath)
        cell.tagName.sizeToFit()
        let size = CGSize(width: cell.tagName.frame.size.width + 16, height: cell.tagName.frame.size.height + 16)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? knTagCell else { return  }
        
        collectionView.deselectItem(at: indexPath, animated: false)
        tags[indexPath.row].selected = !tags[indexPath.row].selected
        cell.backgroundColor = tags[indexPath.row].selected ? activeBackgroundColor : inactiveBackgroundColor
        cell.tagName.textColor = tags[indexPath.row].selected ? UIColor.white : UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    }
    
    func configureCell(_ cell: knTagCell, forIndexPath indexPath: IndexPath) {
        let tag = tags[indexPath.row]
        cell.tagName.text = tag.text
        cell.tagName.textColor = tag.selected ? UIColor.white : UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        cell.backgroundColor = tag.selected ? activeBackgroundColor : inactiveBackgroundColor
    }
}


struct knTag {
    
    var text: String?
    var selected = false
    
    init(text: String) {
        self.text = text
    }
}

class knTagCell: UICollectionViewCell {
    
    var tagName : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    var tagNameMaxWidthConstraint: NSLayoutConstraint?
    
    var tagData: knTag? {
        didSet {
            tagName.text = tagData?.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        addSubview(tagName)
        tagName.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        tagName.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        tagName.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        tagName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        tagName.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        tagNameMaxWidthConstraint = tagName.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        tagNameMaxWidthConstraint!.constant = UIScreen.main.bounds.width - 8 * 2 - 8 * 2
        tagNameMaxWidthConstraint!.isActive = true
        
        backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        tagName.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        layer.cornerRadius = 4
    }
}


// Code from Alex Koshy
class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElements(in: rect)
        
        // Constants
        let leftPadding: CGFloat = 8
        let interItemSpacing: CGFloat = 5
        
        // Tracking values
        var leftMargin: CGFloat = leftPadding // Modified to determine origin.x for each item
        var maxY: CGFloat = -1.0 // Modified to determine origin.y for each item
        var rowSizes: [[CGFloat]] = [] // Tracks the starting and ending x-values for the first and last item in the row
        var currentRow: Int = 0 // Tracks the current row
        attributes?.forEach { layoutAttribute in
            
            // Each layoutAttribute represents its own item
            if layoutAttribute.frame.origin.y >= maxY {
                
                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding
                
                // Register its origin.x in rowSizes for use later
                if rowSizes.count == 0 {
                    // Add to first row
                    rowSizes = [[leftMargin, 0]]
                } else {
                    // Append a new row
                    rowSizes.append([leftMargin, 0])
                    currentRow += 1
                }
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
            
            // Add right-most x value for last item in the row
            rowSizes[currentRow][1] = leftMargin - interItemSpacing
        }
        
        // At this point, all cells are left aligned
        // Reset tracking values and add extra left padding to center align entire row
        leftMargin = leftPadding
        maxY = -1.0
        currentRow = 0
        attributes?.forEach { layoutAttribute in
            
            // Each layoutAttribute is its own item
            if layoutAttribute.frame.origin.y >= maxY {
                
                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding
                
                // Need to bump it up by an appended margin
                let rowWidth = rowSizes[currentRow][1] - rowSizes[currentRow][0] // last.x - first.x
                let appendedMargin = (collectionView!.frame.width - leftPadding  - rowWidth - leftPadding) / 2
                leftMargin += appendedMargin
                
                currentRow += 1
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}
