//
//  InfoView.swift
//  EatingPlaces
//
//  Created by Raghav Ahuja on 12/01/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import UIKit
import GoogleMaps

class InfoView: UIView {

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
        return label
    }()
    
    private var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 1
        label.textColor = .darkGray
        return label
    }()
    
    func setLocation(place: Places) {
        nameLabel.text = place.name
        decodeCoordinates(place.coordinates) { address in
            self.addressLabel.text = address
        }
        addSubviews()
    }
    
    private func addSubviews() {
        nameLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 40)
        addSubview(nameLabel)
        
        addressLabel.frame = CGRect(x: nameLabel.frame.origin.x, y: nameLabel.frame.origin.y + nameLabel.frame.size.height, width: frame.size.width, height: 40)
        addSubview(addressLabel)
    }
    
    private func decodeCoordinates(_ coordinates: CLLocationCoordinate2D, completion: @escaping (String?) -> ()) {
        let decoder = GMSGeocoder()
        decoder.reverseGeocodeCoordinate(coordinates) { (response, error) in
            guard let address = response?.firstResult(), let lines = address.lines else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(lines.joined(separator: "\n"))
            }
        }
        return
    }
}
