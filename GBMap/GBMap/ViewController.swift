//
//  ViewController.swift
//  GBMap
//
//  Created by Dmitry Zasenko on 13.06.22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            self.mapView.delegate = self
            self.mapView.showsUserLocation = true
        }
    }
    private let locationManager = CLLocationManager()
    private let initialLocation =  CLLocation(latitude: 55.753215, longitude: 37.622504)
    private var routePointsPins: [MKPointAnnotation] = []
    private var routePoints: [CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        mapView.centerToLocation(initialLocation)
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}
// MARK: -MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 8.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
// MARK: -CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        routePoints.append(userLocation.coordinate)
        let line = MKPolyline(coordinates: routePoints, count: routePoints.count)
        mapView.addOverlay(line)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.coordinate = userLocation.coordinate
        routePointsPins.append(sourceAnnotation)
        
        self.mapView.showAnnotations(routePointsPins, animated: true )
        self.mapView.setCenter(userLocation.coordinate, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
// MARK: -extension MKMapView
private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 5000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
