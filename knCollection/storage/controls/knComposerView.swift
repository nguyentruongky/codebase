//
//  ComposerView.swift
//  WorkshopFixir
//
//  Created by Ky Nguyen on 2/10/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

enum knMessageType: String {
    case audio, image, text
}

protocol knSendMessageDelegate: class {
    
    func sendMessage(_ message: String, type: knMessageType)
    
}

protocol knComposerDelegate: class {
    
    func didBeginEditing()
    
    func didShowImageSelection()
    
    func didSelectImage(_ image: UIImage)
    
    func didShowRecordView()
}


class knComposerView : UIView {
    
    
    lazy var textView : UITextView = { [weak self] in
        
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = UIColor.color(value: 127)
        tv.createBorder(1, color: UIColor.color(value: 218))
        tv.createRoundCorner(3)
        tv.autocorrectionType = .no
        tv.spellCheckingType = .no
        tv.delegate = self
        return tv
        
        }() /* textView */
    
    lazy var cameraButton: UIButton = { [weak self] in
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        return button
        }() /* cameraButton */
    
    @objc func handleSelectImage() {
        textView.resignFirstResponder()
        delegate?.didShowImageSelection()
    }
    
    lazy var microButton: UIButton = { [weak self] in
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "micro"), for: .normal)
        button.addTarget(self, action: #selector(handleRecord), for: .touchUpInside)
        return button
        }() /* microButton */
    
    @objc func handleRecord() {
        textView.resignFirstResponder()
        delegate?.didShowRecordView()
    }
    
    lazy var sendButton: UIButton = { [weak self] in
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        button.setImage(UIImage(named: "send"), for: .normal)
        return button
        }() /* sendButton */
    
    @objc func handleSend() {
        sendDelegate?.sendMessage(textView.text, type: knMessageType.text)
    }
    
    let mediaView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }() /* mediaView */
    
    weak var delegate : knComposerDelegate? /* delegate */
    
    weak var sendDelegate: knSendMessageDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textToCameraConstraint: NSLayoutConstraint? /* textToCameraConstraint */
    var textToSendConstraint : NSLayoutConstraint? /* textToSendConstraint */
    var sendWidth: NSLayoutConstraint?
    
    func setupView() {
        
        backgroundColor = .white
        
        addSubview(textView)
        addSubview(mediaView)
        
        
        
        /* textView */
        addConstraints(withFormat: "V:|-8-[v0]-8-|", views: textView)
        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        textToCameraConstraint = mediaView.leftAnchor.constraint(equalTo: textView.rightAnchor, constant: 8)
        textToCameraConstraint?.isActive = true
        mediaView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mediaView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mediaView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        
        
        
        
        
        let threeDotSeparator: UIImageView = {
            
            let iv = UIImageView(image: UIImage(named: "three_dot_vertical"))
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.contentMode = .scaleAspectFit
            return iv
        }()
        
        cameraButton.width(44)
        microButton.width(44)
        mediaView.addSubview(cameraButton)
        mediaView.addSubview(microButton)
        mediaView.addSubview(threeDotSeparator)
        
        mediaView.addConstraints(withFormat: "V:|[v0]|", views: cameraButton)
        mediaView.addConstraints(withFormat: "V:|[v0]|", views: microButton)
        mediaView.addConstraints(withFormat: "V:|[v0]|", views: threeDotSeparator)
        
        mediaView.addConstraints(withFormat: "H:[v0][v1][v2]|", views: cameraButton, threeDotSeparator, microButton)
        mediaView.width(91)
        
        addSubview(sendButton)
        sendButton.alpha = 0
        sendWidth = sendButton.widthAnchor.constraint(equalToConstant: 22)
        sendWidth?.isActive = true
        sendButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sendButton.centerYAnchor.constraint(equalTo: mediaView.centerYAnchor).isActive = true
        textToSendConstraint = sendButton.leftAnchor.constraint(equalTo: textView.rightAnchor, constant: 8)
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
    }
    
    func resetText() {
        textView.text = ""
        animateSendButton(visible: false)
    }
}



extension knComposerView : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        // prevent press return to have multi line
        guard newText != "\n" else { return false }
        
        
        newText = newText.replacingOccurrences(of: "\n", with: "")
        if newText.length > 0 {
            
            animateSendButton(visible: true)
            
            if text == "\n" {
                sendDelegate?.sendMessage(newText, type: knMessageType.text)
                return false
            }
        }
        else {
            
            animateSendButton(visible: false)
        }
        
        return true
    }
    
    func animateSendButton(visible: Bool) {
        
        let animateDuration: Double = 0.45
        let damping: CGFloat = 0.7
        let velocity: CGFloat = 0.5
        
        func showSendButton() {
            textToSendConstraint?.isActive = true
            textToCameraConstraint?.isActive = false
            
            UIView.animate(withDuration: animateDuration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .curveEaseInOut, animations: { [weak self] in
                
                
                self?.sendButton.alpha = 1
                self?.mediaView.alpha = 0
                self?.sendWidth?.constant = 44
                self?.layoutIfNeeded()
                
            })
        }
        
        func hideSendButton() {
            textToSendConstraint?.isActive = false
            textToCameraConstraint?.isActive = true
            
            UIView.animate(withDuration: animateDuration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .curveEaseInOut, animations: { [weak self] in
                
                
                self?.sendButton.alpha = 0
                self?.mediaView.alpha = 1
                self?.sendWidth?.constant = 22
                self?.layoutIfNeeded()
                
            })
        }
        
        if visible == true {
            showSendButton()
        }
        else {
            hideSendButton()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.didBeginEditing()
    }
}






























