//
//  TrackModel.swift
//  GBMap
//
//  Created by Dmitry Zasenko on 15.06.22.
//

import Foundation
import RealmSwift

class TrackModel: Object {
    @Persisted var date: Date
    @Persisted var points = List<LocationCoordinateModel>()
}

class LocationCoordinateModel: Object {
    @Persisted var latitude: Double = 0.0
    @Persisted var longitude: Double = 0.0
    @Persisted var owner: TrackModel?
}
