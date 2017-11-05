//
//  AskNotificationPermissionWorker.swift
//  Marco
//
//  Created by Ky Nguyen on 6/20/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit
import UserNotifications

struct knAskNotificationPermissionWorker : knWorker {

    var responseToDecline: (() -> Void)?

    func execute() {

        if #available(iOS 10.0, *) {
            registerForiOS10()
        } else {
            registerForiOS9()
        }
    }

    @available(iOS 10.0, *)
    private func registerForiOS10() {

        let setting: UNAuthorizationOptions = [.alert, .badge, .sound]

        func responseToRequest(granted: Bool, error: Error?) {
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }

        UNUserNotificationCenter.current().requestAuthorization(options: setting, completionHandler: responseToRequest)
    }

    func checkPermission(granted: Bool) {
        if granted == true {
            UIApplication.shared.registerForRemoteNotifications()
        }
        else {
            responseToDecline?()
        }
    }

    private func registerForiOS9() {

        let application = UIApplication.shared
        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings)) {

            let setting = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(setting)
            application.registerForRemoteNotifications()
        }
    }
}


