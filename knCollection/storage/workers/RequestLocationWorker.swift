//
//  RequestLocationWorker.swift
//  Streamy
//
//  Created by Ky Nguyen on 7/8/17.
//  Copyright © 2017 Streamy. All rights reserved.
//

import Foundation
import CoreLocation

class knRequestLocationWorker: NSObject, knWorker {
    
    var success: ((CLLocation) -> Void)?
    var locationOff: (() -> Void)?
    var deniedLocation: (() -> Void)?
    
    init(success: ((CLLocation) -> Void)?, locationOff: (() -> Void)?, deniedLocation: (() -> Void)?) {
        self.success = success
        self.locationOff = locationOff
        self.deniedLocation = deniedLocation
    }
    
    lazy var locationManager : CLLocationManager? = { [weak self] in
        
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    func execute() {
            
        let isLocationOn = CLLocationManager.locationServicesEnabled()
        
        if isLocationOn {
            checkLocationStatus()
        }
        else {
            locationOff?()
        }
    }
    
    func checkLocationStatus() {
        let locationStatus = CLLocationManager.authorizationStatus()
        
        switch locationStatus {
            
        case .restricted, .denied:
            deniedLocation?()
            
        case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
        }
    }
    
    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
    }
}

extension knRequestLocationWorker : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            deniedLocation?()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        
        let userLocation:CLLocation = locations[0] as CLLocation
        locationManager = nil
        success?(userLocation)
    }
}


