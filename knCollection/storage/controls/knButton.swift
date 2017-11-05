//
//  KButton
//  kLibrary
//
//  Created by Ky Nguyen on 8/25/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit


class knButton: UIButton {
    
    let standardHeight: CGFloat = 50
    private var savedTitle : String!
    var enabledColor : UIColor = .white
    private var shouldSavedThisColor = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            
            if shouldSavedThisColor {
                enabledColor = backgroundColor!
            }
        }
    }
    
    func animate() {
        
        let spinner = knFlatSpinnerView()
        spinner.setPositionCenterView(self)
        savedTitle = titleLabel?.text
        setTitle("", for: UIControlState())
        isEnabled = false
    }
    
    
    
    func stopAnimating() {
        
        isEnabled = true
        setTitle(savedTitle, for: UIControlState())
        
        for item in subviews {
            if item is knFlatSpinnerView {
                item.removeFromSuperview()
                return
            }
        }
    }
    
    override var isEnabled: Bool {
        
        get { return super.isEnabled }
        set(newValue) {
            
            super.isEnabled = newValue
            
            if backgroundColor == nil {
                titleLabel?.alpha = newValue ? 1 : 0.5
            }
            else {
                shouldSavedThisColor = false
                backgroundColor = newValue ? enabledColor :  enabledColor.withAlphaComponent(0.5)
                shouldSavedThisColor = true
            }
        }
    }
}

class knFlatSpinnerView: UIActivityIndicatorView {
    
    func setPositionCenterView(_ container: UIView, withColor color: UIColor = UIColor.white) {
        
        frame.size = CGSize(width: 32, height: 32)
        frame.origin = CGPoint(x: (container.frame.width - frame.width) / 2, y: (container.frame.height - frame.height) / 2)
        
        container.addSubview(self)
        self.color = color
        startAnimating()
    }
}
