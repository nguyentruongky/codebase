//
//  Localization.swift
//  Coinhako
//
//  Created by Ky Nguyen on 10/3/17.
//  Copyright © 2017 Coinhako. All rights reserved.
//

import Foundation

/// Internal current language key
let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"

/// Name for language change notification
public let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"

class Localizator {
    
    
    static let shared = Localizator()
    
    lazy var localizableDictionary: NSDictionary! = { [weak self] in
        
        let language = self?.currentLanguage == nil ? "en" : self?.currentLanguage!
        if let path = Bundle.main.path(forResource: "Localizable_" + language!, ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
        }()
    
    func localize(string: String) -> String {
        guard let localizedString = localizableDictionary.value(forKeyPath: string) as? String else { return string }
        return localizedString
    }
    
    func setLanguage(_ language: String) {
        currentLanguage = language
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    private var currentLanguage: String? {
        get {
            return UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String
        }
        set {
            
            let savedLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String
            if newValue == savedLanguage { return }
            
            UserDefaults.standard.set(newValue, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        }
    }
}

extension String {
    
    var localized: String {
        return Localizator.shared.localize(string: self)
    }
}





