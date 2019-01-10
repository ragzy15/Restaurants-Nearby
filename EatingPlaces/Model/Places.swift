//
//  Places.swift
//  EatingPlaces
//
//  Created by Raghav Ahuja on 09/01/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import UIKit
import GoogleMaps

struct Result: Decodable {
    let results: [Places]
}

struct Places: Decodable {
    private let geometry: Geometry
    let icon: String
    let id, name: String
    let photos: [Photo]?
    let placeID: String
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: geometry.location.lat, longitude: geometry.location.lng)
    }
    
    var marker: PlaceMarker {
        return PlaceMarker(place: self)
    }
    
    private enum CodingKeys: String, CodingKey {
        case geometry, icon, id, name
        case photos
        case placeID = "place_id"
    }
}

struct Geometry: Decodable {
    let location: Location
}

struct Location: Decodable {
    let lat, lng: Double
}

struct Photo: Decodable {
    let height: Double
    let photoReference: String
    let width: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Photo.CodingKeys.self)
        height = try container.decode(Double.self, forKey: .height)
        photoReference = try container.decode(String.self, forKey: .photoReference)
        width = try container.decode(Double.self, forKey: .width)
    }
    
    enum CodingKeys: String, CodingKey {
        case height
        case photoReference = "photo_reference"
        case width
    }
}

class PlaceMarker: GMSMarker {
    let place: Places
    
    init(place: Places) {
        self.place = place
        super.init()
        position = place.coordinates
        icon = UIImage(named: "restaurant_pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
}
