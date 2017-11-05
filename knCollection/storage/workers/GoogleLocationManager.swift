//
//  LocationManager.swift
//  Marco
//
//  Created by Ky Nguyen on 7/11/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit
import CoreLocation
//import GooglePlaces

class knLocationManager: NSObject {

    var successResponse: ((_ location: CLLocation) -> Void)?
    var offResponse: (() -> Void)?
    var deniedResponse: (() -> Void)?

    var requestWorker: knRequestLocationWorker?

    var address: String?

    private weak var holder: UIViewController?

    func getLocation(for controller: UIViewController) {
        holder = controller

        requestWorker = knRequestLocationWorker(success: getLocationSuccess,
                                                locationOff: locationOff,
                                                deniedLocation: locationDenied)
        requestWorker?.execute()
    }

    private func getLocationSuccess(_ location: CLLocation) {
        if let successResponse = successResponse {
            successResponse(location)
        }
    }

    private func locationOff() {
        if let offResponse = offResponse {
            offResponse()
        }
        else {
            let controller = UIAlertController(title: "Location service is off", message: "We can't access to your location until you turn location service on", preferredStyle: .alert)
            holder?.present(controller)
        }


    }

    private func locationDenied() {
        if let deniedResponse = deniedResponse {
            deniedResponse()
        }
        else {
            let controller = UIAlertController(title: "Location service is denied", message: "You denied our request for location service, so that we can't find you. You can change that in Setting", preferredStyle: .alert)
            holder?.present(controller)
        }
    }

    func findAddress(completion: @escaping (_ address: String?) -> Void) {

//        let placesClient = GMSPlacesClient()
//        placesClient.currentPlace(callback: { [weak self]
//            (places, error) -> Void in
//
//            if let error = error {
//                print("Pick Place error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let places = places else { return }
//            for likelihood in places.likelihoods {
//                self?.address = likelihood.place.formattedAddress
//                completion(likelihood.place.formattedAddress)
//                break
//            }
//        })

    }

}
