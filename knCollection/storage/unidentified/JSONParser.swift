//
//  JSONParser.swift
//  WorkshopFixir
//
//  Created by Ky Nguyen on 12/28/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import Foundation

struct JSONParser {
    
    static func getString(forKey key: String, inObject object: AnyObject) -> String {
        guard let temp = object.value(forKeyPath: key) as? String else { return "" }
        return temp
    }
    
    static func getBool(forKey key: String, inObject object: AnyObject) -> Bool {
        guard let temp = object.value(forKeyPath: key) as? Bool else { return false }
        return temp
    }
    
    static func getInt(forKey key: String, inObject object: AnyObject) -> Int {
        guard let temp = object.value(forKeyPath: key) as? Int else { return 0 }
        return temp
    }
    
    
}
