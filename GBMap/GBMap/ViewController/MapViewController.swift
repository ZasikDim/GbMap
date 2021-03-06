//
//  MapViewController.swift
//  GBMap
//
//  Created by Dmitry Zasenko on 13.06.22.
//

import UIKit
import MapKit

typealias points = [CLLocationCoordinate2D]

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            self.mapView.delegate = self
            self.mapView.showsUserLocation = true
        }
    }
    @IBOutlet weak var newTrackButton: UIButton!
    @IBOutlet weak var endTrackButton: UIButton!
    @IBOutlet weak var previousTrackButton: UIButton!
    
    private let realmManager = RealmManager()
    private let locationManager = LocationManager.schared
    private let initialLocation =  CLLocation(latitude: 55.753215, longitude: 37.622504)
//    private var routePointsPins: [MKPointAnnotation] = []
    private var routePoints: [CLLocationCoordinate2D] = []
    private var isLocationRecording: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        mapView.centerToLocation(initialLocation)
        endTrackButton.isHidden = true
        if realmManager.getLastTrack() == nil {
            previousTrackButton.isHidden = true
        }
    }
    
    @IBAction func newTrackButtonTapped(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            deleteOverlay()
            locationManager.startUpdatingLocation()
            newTrackButton.isHidden = true
            endTrackButton.isHidden = false
            isLocationRecording = true
        }
    }
    @IBAction func endTrackButtonTapped(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        realmManager.deleteTrack()
        realmManager.addTrack(points: routePoints)
        deleteOverlay()
        previousTrackButton.isHidden = false
        endTrackButton.isHidden = true
        newTrackButton.isHidden = false
        isLocationRecording = false
    }
    @IBAction func previousTrackButtonTapped(_ sender: Any) {
        if isLocationRecording {
            showAlert()
        } else {
            showPreviousTrack()
        }
    }
    private func configureLocationManager() {
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let self = self else {return}
                guard let userLocation = location else { return }
                self.routePoints.append(userLocation.coordinate)
                let line = MKPolyline(coordinates: self.routePoints, count: self.routePoints.count)
                self.mapView.addOverlay(line)
                //        let sourceAnnotation = MKPointAnnotation()
                //        sourceAnnotation.coordinate = userLocation.coordinate
                //        routePointsPins.append(sourceAnnotation)
                //        self.mapView.showAnnotations(routePointsPins, animated: true )
                self.mapView.setCenter(userLocation.coordinate, animated: true)
            }
    }
    private func deleteOverlay() {
        routePoints = []
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
    }
    private func showPreviousTrack() {
        locationManager.stopUpdatingLocation()
        guard let lastTrack = realmManager.getLastTrack() else { return }
        let points = lastTrack.points
        routePoints = realmManager.transformListToArray(list: points)
        let line = MKPolyline(coordinates: routePoints, count: routePoints.count)
        mapView.addOverlay(line)
        mapView.setRegion(MKCoordinateRegion(line.boundingMapRect), animated: true)
    }
    private func showAlert() {
        let alert = UIAlertController(title: nil, message: "???????????????????? ???????????????????? ????????????????", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "????????????", style: UIAlertAction.Style.cancel))
        alert.addAction(UIAlertAction(title: "O??", style: .default, handler: { _ in
            self.locationManager.stopUpdatingLocation()
            self.isLocationRecording = false
            self.deleteOverlay()
            self.endTrackButton.isHidden = true
            self.newTrackButton.isHidden = false
            self.showPreviousTrack()
        }))
        present(alert, animated: true, completion: nil)
    }
}
// MARK: -MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
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
// MARK: -extension MKMapView
private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 500) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
