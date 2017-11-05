//
//  DateDialog.swift
//  Fixir
//
//  Created by Ky Nguyen on 3/28/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

protocol knDateDialogDelegate: class {
    
    func didSelectDate(date: Date)
    
    func didCancelSelection()
}




class knDateDialog: UIView {
    
    struct knFonts {
        
        private init() { }
        static let mediumFont = UIFont.systemFont(ofSize: 15)
        static let smallFont = UIFont.systemFont(ofSize: 12)
        
    }
    
    struct knColors {
        private init() { }
        
        static let kn_127 = UIColor.color(value: 127)
        static let kn_229 = UIColor.color(value: 229)
        static let kn_241_147_78 = UIColor.color(r: 241, g: 147, b: 78)
        static let kn_133_189_175 = UIColor.color(r: 133, g: 189, b: 175)
        static let kn_119_203_189 = UIColor.color(r: 119, g: 203, b: 189)
        
    }


    private override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    weak var delegate: knDateDialogDelegate?
    
    static let center = knDateDialog()
    
    lazy var backgroundView: UIView = { [weak self] in
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCancel)))
        view.isUserInteractionEnabled = true
        return view
        
        }() /* backgroundView */
    
    let datePicker: UIDatePicker = {
        
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    let messageBoxView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }() /* messageBoxView */
    
    func setupView() {
        
        let titleLabel: UILabel = {
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = knFonts.mediumFont
            label.textColor = .white
            label.backgroundColor = knColors.kn_119_203_189
            label.text = "SET APPOINTMENT"
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
        
        let setButton: UIButton = {
            
            let title = "SET APPOINTMENT!"
            let color = knColors.kn_127
            
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(title, for: .normal)
            button.setTitleColor(color, for: .normal)
            button.titleLabel?.font = knFonts.mediumFont
            
            let separator = UIView()
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.height(1)
            separator.backgroundColor = knColors.kn_119_203_189
            
            button.addSubview(separator)
            separator.horizontal(toView: button)
            separator.top(toView: button)
            
            return button
            
        }()
        setButton.addTarget(self, action: #selector(handleSetAppointment), for: .touchUpInside)
        
        messageBoxView.addSubview(titleLabel)
        messageBoxView.addSubview(datePicker)
        messageBoxView.addSubview(setButton)
        
        
        titleLabel.horizontal(toView: messageBoxView)
        datePicker.horizontal(toView: messageBoxView)
        setButton.horizontal(toView: messageBoxView)
        
        messageBoxView.addConstraints(withFormat: "V:|[v0(40)][v1(166)][v2(44)]|", views: titleLabel, datePicker, setButton)
        
    }
    
    @objc func handleSetAppointment() {
        close()
        delegate?.didSelectDate(date: datePicker.date)
    }
    
    @objc func handleCancel() {
        close()
        delegate?.didCancelSelection()
    }
    
    weak var parentView: UIView?
    
    func show(in view: UIView) {
        
        setupView()
        
        parentView = view
        
        view.addSubview(backgroundView)
        view.addSubview(messageBoxView)
        
        backgroundView.vertical(toView: view)
        backgroundView.horizontal(toView: view)
        
        messageBoxView.horizontal(toView: view, space: 24)
        messageBoxView.centerY(toView: view, space: -32)
        
        messageBoxView.layer.opacity = 0
        messageBoxView.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.4)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: { [weak self] in
                
                self?.backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
                self?.messageBoxView.layer.opacity = 1
                self?.messageBoxView.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
        
    }
    
    func close() {
        
        let currentTransform = messageBoxView.layer.transform
        
        let startRotation = (self.value(forKeyPath: "layer.transform.rotation.z") as? NSNumber) as? Double ?? 0.0
        let rotation = CATransform3DMakeRotation((CGFloat)(-startRotation + Double.pi * 270 / 180), 0, 0, 0)
        
        messageBoxView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1))
        messageBoxView.layer.opacity = 1
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: { [weak self] in
                
                self?.backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                self?.messageBoxView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1))
                self?.messageBoxView.layer.opacity = 0
                
            }, completion: { [weak self] (finished: Bool) in
                
                self?.backgroundView.removeFromSuperview()
                self?.messageBoxView.removeFromSuperview()
                self?.parentView = nil
                
        })
    }
}


























