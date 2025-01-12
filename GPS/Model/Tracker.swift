//
//  Tracker.swift
//  GPS
//
//  Created by Marin on 04.01.2025.
//

class Tracker {
    var lat: Double!
    var long: Double!
    var name: String!
    var id: Int!
    static var counts = 0
    init() {
        lat = Double.random(in: -10...30)
        long = Double.random(in: 0...50)
        id = Tracker.counts
        name = String(Tracker.counts)
        Tracker.counts += 1
    }
}
