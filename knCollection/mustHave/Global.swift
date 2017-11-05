//
//  GlobalSupporter.swift
//  Fixir
//
//  Created by Ky Nguyen on 3/9/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

var screenWidth: CGFloat { return UIScreen.main.bounds.width }
var screenHeight: CGFloat { return UIScreen.main.bounds.height }
let appDelegate = UIApplication.shared.delegate as! AppDelegate
var statusBarStyle = UIStatusBarStyle.lightContent { didSet {UIApplication.shared.statusBarStyle = statusBarStyle}}
var isStatusBarHidden = false { didSet { UIApplication.shared.isStatusBarHidden = isStatusBarHidden}}


func run(_ action: @escaping () -> Void, after second: Double) {
    let triggerTime = DispatchTime.now() + .milliseconds(Int(second * 1000))
    DispatchQueue.main.asyncAfter(deadline: triggerTime) { action() }
}

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

func makeCall(to number: String) {
    
    guard let phoneUrl = URL(string: "tel://\(number)") else { return }
    guard UIApplication.shared.canOpenURL(phoneUrl) else { return }
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(phoneUrl)
    } else {
        UIApplication.shared.openURL(phoneUrl)
    }
}





enum knErrorCode : String {
    case loginFail
    case invalidEmail
    case invalidPassword
    case notFound
    case timeOut
    case serverError
    case empty
    case emailExist
    case emptyPassword
    case weakPassword
    case notSure
    case facebookCancel
    case cantGetUploadedUrl
    case uploadFail
    
    case sendFail
}

struct knError {
    
    var code: knErrorCode?
    var message: String?
}
