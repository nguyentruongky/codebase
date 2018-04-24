//
//  MapController.swift
//  Marco
//
//  Created by Ky Nguyen on 6/28/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit
import MapKit

class marMapController: knController {

    var location: knLocationData?

    lazy var mapView: MKMapView = { [weak self] in

        let view = MKMapView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        fetchData()
    }

    override func setupView() {

        addBackButton(tintColor: UIColor.color(value: 141))
        navigationController?.removeBottomSeparator(color: .clear)

        view.addSubview(mapView)
        mapView.fill(toView: view)
    }

    override func fetchData() {

        guard let location = location else { return }

        let latitude = CLLocationDegrees(location.lat)
        let longitude = CLLocationDegrees(location.long)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate

        mapView.addAnnotation(annotation)

        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.2), longitudeDelta: CLLocationDegrees(0.2))
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)

    }

}

extension marMapController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if(pinView == nil) {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        return pinView
    }


}














