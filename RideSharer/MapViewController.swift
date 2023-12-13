//
//  MapViewController.swift
//  RideSharer
//
//

import MapKit
import UIKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            showAlert(withMessage: "Location services are not enabled.")
        }
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        case .restricted:
            showAlert(withMessage: "Authorization is restricted.")
            break
        case .denied:
            showAlert(withMessage: "Authorization is denied. Please allow in Settings.")
            break
        case .authorizedAlways, .authorizedWhenInUse:
            print("AUTHORIZED")
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        @unknown default:
            fatalError()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    /// Used https://www.youtube.com/watch?v=f6xN2MuHv1s by iOS Academy as a reference for this.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
    /// Used https://www.youtube.com/watch?v=f6xN2MuHv1s by iOS Academy as a reference for this.
    func render(_ location: CLLocation) {
        let coord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func showAlert(withMessage message: String) {
        let alertVC = UIAlertController(title: "Help us locate you!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}
