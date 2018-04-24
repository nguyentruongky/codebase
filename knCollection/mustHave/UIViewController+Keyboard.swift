//
//  UIViewController+Keyboard.swift
//
//  Created by Håkon Bogen on 10/12/14.
//  Copyright (c) 2014 Håkon Bogen. All rights reserved.
//  MIT LICENSE

import UIKit

private var scrollViewKey : UInt8 = 0

extension UIViewController {
    
    public func setupKeyboardNotifcationListenerForScrollView(scrollView: UIScrollView) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        internalScrollView = scrollView
    }
    
    public func removeKeyboardNotificationListeners() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private var internalScrollView: UIScrollView! {
        get {
            return objc_getAssociatedObject(self, &scrollViewKey) as? UIScrollView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &scrollViewKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.cgRectValue
        let keyboardFrameConvertedToViewFrame = view.convert(keyboardFrame!, from: nil)
        let options = UIViewAnimationOptions.beginFromCurrentState
        UIView.animate(withDuration: animationDuration, delay: 0, options:options, animations: { () -> Void in
            let insetHeight = (self.internalScrollView.frame.height + self.internalScrollView.frame.origin.y) - keyboardFrameConvertedToViewFrame.origin.y
            self.internalScrollView.contentInset = UIEdgeInsetsMake(0, 0, insetHeight, 0)
            self.internalScrollView.scrollIndicatorInsets  = UIEdgeInsetsMake(0, 0, insetHeight, 0)
            }) { (complete) -> Void in
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let options = UIViewAnimationOptions.beginFromCurrentState
        UIView.animate(withDuration: animationDuration, delay: 0, options:options, animations: { () -> Void in
            self.internalScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            self.internalScrollView.scrollIndicatorInsets  = UIEdgeInsetsMake(0, 0, 0, 0)
            }) { (complete) -> Void in
        }
    }
}
