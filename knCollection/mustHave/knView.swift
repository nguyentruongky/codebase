//
//  knView.swift
//  Ogenii
//
//  Created by Ky Nguyen on 3/17/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

class knView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setupView() { }
}

class knCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setupView() { }
}

class knTableCell : UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setupView() { }
}
