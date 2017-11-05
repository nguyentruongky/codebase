//
//  LocationPickerView.swift
//  Marco
//
//  Created by Ky Nguyen on 7/11/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit
import GooglePlaces

class knPlacePickerView: knView {

    var didSelectPlace: ((_ place: GMSPlace) -> Void)?

    var datasource = [(placeId: String?, address: String)]()

    lazy var tableView: UITableView = { [weak self] in

        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        tb.backgroundColor = .clear
        return tb

        }()

    override func setupView() {

        tableView.separatorStyle = .none

        addSubview(tableView)
        tableView.fill(toView: self)

        registerCells()
    }

    func registerCells() {
        tableView.register(marLocationCell.self, forCellReuseIdentifier: "marLocationCell")
    }

}

extension knPlacePickerView {

    func searchPlace(text: String) {

        let placesClient = GMSPlacesClient()

        placesClient.autocompleteQuery(text, bounds: nil, filter: nil) { [weak self] (data, error) in

            guard let data = data else { return }

            let places = data.map({ return (placeId: $0.placeID, address: $0.attributedFullText.string) })
            self?.datasource = places
            self?.tableView.reloadData()
        }

    }
}

extension knPlacePickerView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marLocationCell", for: indexPath) as! marLocationCell
        cell.data = datasource[indexPath.row].address
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let placesClient = GMSPlacesClient()

        guard let id = datasource[indexPath.row].placeId else { return }
        placesClient.lookUpPlaceID(id, callback: { [weak self] place, error in

            guard let place = place else { return }
            self?.didSelectPlace?(place)
        })
    }
    
}

