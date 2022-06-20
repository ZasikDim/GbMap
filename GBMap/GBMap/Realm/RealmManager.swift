//
//  RealmManager.swift
//  GBMap
//
//  Created by Dmitry Zasenko on 15.06.22.
//

import Foundation
import RealmSwift
import CoreLocation

class RealmManager: ObservableObject {

    private(set) var localRealm: Realm?
    var lastTrack: Realm?
    
    init() {
        openRealm()
    }
    
    func openRealm() {
        do {
            localRealm = try Realm()
        } catch {
            print("Error opening Realm", error)
        }
    }

    func addTrack(points: points) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let points = transformArrayToList(array: points)
                    let newTrack = TrackModel()
                    newTrack.points = points
                    localRealm.add(newTrack)
                }
            } catch {
                print("Error adding task to Realm: \(error)")
            }
        }
    }
    
    func getLastTrack() -> TrackModel? {
        if let localRealm = localRealm {
            let lastTrack = localRealm.objects(TrackModel.self)
            return lastTrack.last
        } else {
            return nil
        }
        
    }
    
    func deleteTrack() {
        if let localRealm = localRealm {
            do {
                let trackToDelete = localRealm.objects(TrackModel.self)
                
                guard !trackToDelete.isEmpty else { return }
                try localRealm.write {
                    localRealm.delete(trackToDelete)
                }
            } catch {
                print("Error deleting task to Realm: \(error)")
            }
        }
    }
    
    func transformArrayToList(array: points) -> List<LocationCoordinateModel> {
        let result = List<LocationCoordinateModel>()
        for entry in array {
            let model = LocationCoordinateModel()
            model.latitude = entry.latitude
            model.longitude = entry.longitude
            result.append(model)
        }
        return result
    }
    
    func transformListToArray(list: List<LocationCoordinateModel>) -> points {
        var result: points = []
        for entry in list {
            result.append(CLLocationCoordinate2D(latitude: entry.latitude, longitude: entry.longitude))
        }
        return result
    }
}
