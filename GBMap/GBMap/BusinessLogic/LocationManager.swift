//
//  LocationManager.swift
//  GBMap
//
//  Created by Dmitry Zasenko on 01.07.22.
//

import CoreLocation
import RxSwift
import RxCocoa

final class LocationManager: NSObject {
    static let schared = LocationManager()
    
    private override init() {
        super.init()
        configureLocationManager()
    }
    
    let locationManager = CLLocationManager()
    let location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
    }
}
// MARK: -LocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location.accept(locations.last)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
