//
//  ViewController.swift
//  EatingPlaces
//
//  Created by Raghav Ahuja on 08/01/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet private weak var mapView: GMSMapView!
    
    private var places = [Places]()
    
    private let locationManager = CLLocationManager()
    private let model = NearbyPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }
    
    private func setupMap() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
    }
    
    @IBAction private func listButtonPressed(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "listVC") as? TableViewController else { return }
        vc.places = places
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 30)
        locationManager.stopUpdatingLocation()
        fetch(at: location)
    }
    
    func fetch(at location: CLLocation) {
        model.fetchRestuarants(near: location.coordinate, radius: 500) { (places, error) in
            if let error = error {
                print(error)
                self.places = []
            } else if let places = places {
                self.places = places
                self.model.markPlaces(places: places, in: self.mapView)
            }
        }
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let placeMarker = marker as? PlaceMarker else {
            return nil
        }
        let infoView = InfoView()
        infoView.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        infoView.setLocation(place: placeMarker.place)
        return infoView
    }
}
