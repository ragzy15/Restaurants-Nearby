//
//  NearbyPlaces.swift
//  EatingPlaces
//
//  Created by Raghav Ahuja on 09/01/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import UIKit
import GoogleMaps

class NearbyPlaces {
    typealias PlaceCompletion = ([Places]?, Error?) -> ()
    
    var mapAPIKey: String
    var currentTask: URLSessionTask?
    var urlSession: URLSession
    
    init() {
        urlSession = URLSession(configuration: .default)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            mapAPIKey = "invalid"
            return
        }
        mapAPIKey = appDelegate.mapAPIKey
    }
    
    func markPlaces(places: [Places], in mapView: GMSMapView) {
        places.forEach {
            let marker = PlaceMarker(place: $0)
            marker.map = mapView
        }
    }
    
    func fetchRestuarants(near coordinate: CLLocationCoordinate2D, radius: Float, completion: @escaping PlaceCompletion) {
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true&key=\(mapAPIKey)"
        guard let url = URL(string: urlString) else {
            return
        }
        print(url)
        currentTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } else if let data = data {
                let result = self.decode(type: Result.self, data: data)
                DispatchQueue.main.async {
                    completion(result?.results, nil)
                }
            }
        })
        currentTask?.resume()
    }
    
    private func decode<T: Decodable>(type: T.Type, data: Data) -> T? {
        do {
//            print(try? JSONSerialization.jsonObject(with: data, options: []))
            let result = try JSONDecoder().decode(T.self, from: data)
            print(result)
            return result
        } catch {
            print(error)
            print("")
        }
        return nil
    }
}
