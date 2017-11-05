//
//  BarButtonNumber.swift
//  UIBarButtonWithNumber
//
//  Created by Ky Nguyen on 9/30/15.
//  Copyright © 2015 Ky Nguyen. All rights reserved.
//

import Foundation
import UIKit

class knBarButtonNumber : UIBarButtonItem {

    var _badgeValue : String = ""
    var badgeValue: String {
        set {
            _badgeValue = newValue
            if (_badgeValue == "" || _badgeValue == "0") {
                removeBadge()
            }
            else {
                badge.isHidden = false
                badge.frame = CGRect(x: badgeOriX, y: badgeOriY, width: 20, height: 20)
                badge.textColor = _badgeTextColor
                badge.backgroundColor = _badgeColor
                badge.font = _badgeFont
                badge.textAlignment = NSTextAlignment.center
                customView?.addSubview(self.badge)
                updateBadgeValueAnimated(true)
            }
        }

        get { return _badgeValue }
    }
    
    var _badgeColor: UIColor = UIColor.red
    var badgeColor: UIColor {
        
        get { return self._badgeColor }
        
        set {
            _badgeColor = newValue
            refreshBadge()
        }
    }
    
    var _badgeTextColor: UIColor = UIColor.white
    var badgeTextColor: UIColor {
        
        get { return _badgeTextColor }
        
        set {
            _badgeTextColor = newValue
            refreshBadge()
        }
    }
    
    var _badgeFont: UIFont = UIFont.systemFont(ofSize: 10)
    var badgeFont : UIFont {
        
        get { return _badgeFont }
        
        set {
            _badgeFont = newValue
            refreshBadge()
        }
    }
    
    var _badgePadding: CGFloat = 3
    var badgePadding : CGFloat {
        
        get { return _badgePadding }
        
        set {
            _badgePadding = newValue
            refreshBadge()
        }
    }

    var _badgeMinSize: CGFloat = 0
    var badgeMinSize: CGFloat {
        
        get { return _badgeMinSize }
        
        set {
            _badgeMinSize = newValue
            refreshBadge()
        }
    }

    var _badgeOriX : CGFloat = 0
    var badgeOriX : CGFloat {
        
        get { return _badgeOriX }
        
        set {
            _badgeOriX = newValue
            updateBadgeFrame()
        }
    }
    
    var _badgeOriY : CGFloat = 0 
    var badgeOriY : CGFloat {

        get { return _badgeOriY }
        
        set {
            _badgeOriY = newValue
            updateBadgeFrame()
        }
    }
    
    var shouldHideBadgeAtZero = true
    
    var shouldAnimateBadge = true

    func initWithButton(_ button: UIButton) {
        self.customView = button
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    var badge = UILabel()
    
    func updateBadgeFrame() {
        
        let frameLabel = badge
        frameLabel.sizeToFit()
        
        let expectedLabelSize = frameLabel.frame.size
        var minHeight = expectedLabelSize.height
        minHeight = minHeight < self.badgeMinSize ? self.badgeMinSize : minHeight
        var minWidth = expectedLabelSize.width
        let padding = badgePadding
        minWidth = minWidth < minHeight ? minHeight : minWidth
        
        badge.frame = CGRect(x: badgeOriX, y: badgeOriY, width: minWidth + padding, height: minHeight + padding)
        badge.layer.cornerRadius = (minHeight + padding) / 2
        badge.layer.masksToBounds = true
    }

    
    func refreshBadge() {
        
        badge.textColor = self.badgeTextColor
        badge.backgroundColor = self.badgeColor
        badge.font = self.badgeFont
    }
    
    func resetBadge() { badgeValue = "0" }

    func updateBadgeValueAnimated(_ animated: Bool) {
        
        if (animated && shouldAnimateBadge && !(badge.text == badgeValue)) {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 1.5
            animation.toValue = 1.0
            animation.duration = 0.2
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 1.3, 1, 1)
            badge.layer.add(animation, forKey: "bounceAnimation")
        }
        badge.text = badgeValue
        updateBadgeFrame()
    }
    
    func duplicateLabel(_ labelToCopy: UILabel) -> UILabel {
        let duplicateLabel = UILabel()
        duplicateLabel.text = labelToCopy.text
        duplicateLabel.font = labelToCopy.font
        return duplicateLabel
    }
    
    func removeBadge() {
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
//                self.badge.transform = CGAffineTransformMakeScale(0, 0)
                self.badge.isHidden = true
            }, completion: { (Bool) -> Void in
//                self.badge.hidden = true
        }) 
    }
}
