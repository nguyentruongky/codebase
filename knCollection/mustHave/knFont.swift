//
//  knFont.swift
//  knCollection
//
//  Created by Ky Nguyen on 10/12/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit


enum knFont: String {
    
    case helveticaNeue = "HelveticaNeueLTStd-Roman"
    case rubik_regular = "Rubik-Regular"
    case rubik_medium = "Rubik-Medium"
    

    static func font(name: knFont, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name.rawValue, size: size)
            else { return UIFont.boldSystemFont(ofSize: size) }
        return font
    }
    
}
