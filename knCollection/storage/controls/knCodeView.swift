//
//  CodeView.swift
//  ActiveCode
//
//  Created by Ky Nguyen on 5/23/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

var defaultFontSize: CGFloat = 40

struct Color {
    static let currentColor = UIColor.black
    static let activeColor = UIColor.blue.withAlphaComponent(0.5)
    static let inactiveColor = UIColor.lightGray
}

class CharacterView: UIView {
    
    fileprivate var codeLabel : UILabel!
    fileprivate var underlineView: UIView!
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCode()
        setupUnderline()
    }
    
    func activate() { changeStateWithColor(Color.activeColor) }
    
    func deactivate() { changeStateWithColor(Color.inactiveColor) }
    
    func markEntered() { changeStateWithColor(Color.currentColor) }
    
    func changeCodeWithString(_ string: String) { codeLabel.text = string }
    
    fileprivate func setupCode() {
        
        codeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        codeLabel.font = UIFont.systemFont(ofSize: defaultFontSize)
        codeLabel.textAlignment = NSTextAlignment.center
        addSubview(codeLabel)
    }
    
    fileprivate func setupUnderline() {
        underlineView = UIView(frame: CGRect(
            x: codeLabel.frame.origin.x,
            y: codeLabel.frame.origin.y + codeLabel.frame.height + 4,
            width: codeLabel.frame.width,
            height: codeLabel.frame.width / 10))
        underlineView.backgroundColor = Color.inactiveColor
        addSubview(underlineView)
    }
    
    fileprivate func changeStateWithColor(_ color: UIColor) { codeLabel.textColor = color; underlineView.backgroundColor = color; }
}

class CodeView: UIView, UITextFieldDelegate {
    
    var validateCode: ((String) -> ())?
    var codeCharacter : String!
    var numberOfCharacter : Int {
        get { return _numberOfCharacter }
        
        set(value) {
            _numberOfCharacter = value
            characterViews.removeAll()
            for v in subviews {
                v.removeFromSuperview()
            }
            setupView()
        }
    }
    
    fileprivate var _numberOfCharacter = 4
    fileprivate var characterViews = [CharacterView]()
    fileprivate var horizontalSpacing: CGFloat = 16
    fileprivate var codeField = UITextField()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init(frame: CGRect, numberOfCharacter: Int) {
        
        self.init(frame: frame)
        self.numberOfCharacter = numberOfCharacter
    }
    
    func activeCodeView() {
        codeField.becomeFirstResponder()
    }
    
    func changeKeyboardType(_ keyboardType: UIKeyboardType) {
        codeField.keyboardType = keyboardType
    }
    
    fileprivate func setupView() {
        
        let viewWidth = UIScreen.main.bounds.width
        setupCodeField()
        let value = calculateSizeForScreenBaseOnWidth(viewWidth, numberOfCharacter: numberOfCharacter)
        let horizontalSpacing: CGFloat = value.spacing
        let characterSize = value.chracterSize
        var labelX = calculateFirstLabelXBaseOnLabelWidth(characterSize.width,
                                                          viewWidth: viewWidth,
                                                          numberOfCharacter: numberOfCharacter,
                                                          horizontalSpacing: horizontalSpacing)
        
        for _ in 0 ..< numberOfCharacter {
            addSubview(createCharacterViewWithSize(characterSize, atX: labelX))
            labelX += horizontalSpacing + characterSize.width
        }
        
        activeCodeAtIndex(0)
    }
    
    fileprivate func setupCodeField() {
        codeField.delegate = self
        addSubview(codeField)
        codeField.becomeFirstResponder()
        codeField.autocorrectionType = UITextAutocorrectionType.no
        codeField.autocapitalizationType = UITextAutocapitalizationType.none
    }
    
    fileprivate func calculateSizeForScreenBaseOnWidth(_ viewWidth: CGFloat, numberOfCharacter: Int) -> (chracterSize: CGSize, spacing: CGFloat) {
        
        let baseSize = calculateSizeBaseOnFontSize(defaultFontSize)
        if viewWidth / CGFloat(numberOfCharacter) > baseSize.width + horizontalSpacing { return (baseSize, horizontalSpacing) }
        
        horizontalSpacing -=  horizontalSpacing > 8 ? 2 : 0
        defaultFontSize -= 4
        return calculateSizeForScreenBaseOnWidth(viewWidth, numberOfCharacter: numberOfCharacter)
    }
    
    fileprivate func calculateFirstLabelXBaseOnLabelWidth(_ width: CGFloat,
                                                      viewWidth: CGFloat,
                                                      numberOfCharacter: Int,
                                                      horizontalSpacing spacing: CGFloat) -> CGFloat {
        
        var labelX: CGFloat = width * CGFloat(numberOfCharacter)
        labelX += spacing * CGFloat(numberOfCharacter - 1)
        labelX = (viewWidth - labelX) / 2
        return labelX
    }
    
    fileprivate func calculateSizeBaseOnFontSize(_ fontSize: CGFloat) -> CGSize {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.text = "0"
        label.sizeToFit()
        return CGSize(width: label.frame.width + 8, height: label.frame.height + 4)
    }
    
    fileprivate func createCharacterViewWithSize(_ size: CGSize, atX x: CGFloat) -> CharacterView {
        let newFrame = CGRect(x: x, y: (frame.height - size.height) / 2 - 4,
                              width: size.width + 4, height: size.height)
        let characterView = CharacterView(frame: newFrame)
        characterViews.append(characterView)
        return characterView
    }
    
    fileprivate func activeCodeAtIndex(_ index: Int, withString string: String) {
        let character = characterViews[index]
        character.changeCodeWithString(string.uppercased())
        character.activate()
        deactivateCodeAtIndex(index - 1)
    }
    
    fileprivate func deactivateCodeAtIndex(_ index: Int) {
        guard index >= 0 && index < characterViews.count else { return }
        characterViews[index].deactivate()
    }
    
    fileprivate func activeCodeAtIndex(_ index: Int) {
        
        guard index >= 0 && index < characterViews.count else { return }
        let character = characterViews[index]
        character.activate()
    }
    
    fileprivate func markCodeEntered(_ index: Int) {
        guard index >= 0 && index < characterViews.count else { return }
        let character = characterViews[index]
        character.markEntered()
    }
    
    fileprivate func enterCodeAtIndex(_ index: Int, withString string: String) {
        let newString = codeCharacter != nil ? codeCharacter : string
        characterViews[index].changeCodeWithString(newString!)
        activeCodeAtIndex(index + 1)
        markCodeEntered(index)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let codeLength = textField.text!.characters.count
        // delete character
        guard string.isEmpty == false && range.length != 1 else {
            characterViews[codeLength - 1].changeCodeWithString(string)
            activeCodeAtIndex(codeLength - 1)
            deactivateCodeAtIndex(codeLength)
            return true
        }
        
        // enter new character
        guard codeLength < characterViews.count else { return false }
        enterCodeAtIndex(codeLength, withString: string)
        
        // validate code
        if codeLength + 1 == characterViews.count {
            let code = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.text = code
            if let validateCode = validateCode {
                validateCode(code)
            }
            return false
        }
        
        return true
    }
}


