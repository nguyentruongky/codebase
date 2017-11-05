//
//  GeocodingWorker.swift
//  Coinhako
//
//  Created by Ky Nguyen on 9/19/17.
//  Copyright © 2017 Coinhako. All rights reserved.
//

import Foundation
import CoreLocation

struct knGeocodingWorker: knWorker {
    
    var location: CLLocation
    var successAction: ((_ country: String) -> Void)?
    var failAction: ((_ err: knError) -> Void)?
    
    func execute() {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, err) in
            guard let countryCode = placemarks?.first?.isoCountryCode else { return }
            self.successAction?(countryCode)
        }
    }
    
    
    func successResponse(returnData: AnyObject) {
    
        guard let results = returnData.value(forKeyPath: "results") as? [AnyObject],
            let addressComponents = results.first?.value(forKeyPath: "address_components") as? [AnyObject],
            let countryJson = addressComponents.last,
            let countryCode = countryJson.value(forKeyPath: "short_name") as? String else {
                
            failResponse(err: knError(code: knErrorCode.notFound, message: "Can't geocoding"))
            return
        }
        
        successAction?(countryCode)
    }
    
    func failResponse(err: knError) {
        failAction?(err)
    }
}




