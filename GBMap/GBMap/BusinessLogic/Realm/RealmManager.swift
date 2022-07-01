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
    // MARK: - Track
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
    // MARK: - User
    func checkLoginAndPasword(login: String, password: String) -> Bool {
        guard let user = findUserInRealm(login: login) else { return false }
        if user.password == password {
            return true
        } else {
            return false
        }
    }

    func addUser(login: String, password: String) {
        if let user = findUserInRealm(login: login) {
            changeUserPassword(user: user, password: password)
        } else {
            addNewUserToRealm(login: login, password: password)
        }
    }
    
    private func findUserInRealm(login: String) -> User? {
        if let user = localRealm?.object(ofType: User.self, forPrimaryKey: login) {
            return user
        } else {
            return nil
        }
    }
    
    private func addNewUserToRealm(login: String, password: String) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let user = User()
                    user.login = login
                    user.password = password
                    localRealm.add(user)
                }
            } catch {
                print("Error adding task to Realm: \(error)")
            }
        }
    }
    
    private func changeUserPassword(user: User, password: String) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    user.password = password
                    localRealm.add(user, update: .modified)
                }
            } catch {
                print("Error adding task to Realm: \(error)")
            }
        }
    }
    
    //MARK: -Transforming
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
