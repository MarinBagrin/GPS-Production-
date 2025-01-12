//
//  UIMaps.swift
//  GPS
//
//  Created by Marin on 30.12.2024.
//
import UIKit
import CoreLocation
protocol UIMap {
    
    func getUIView() -> UIView
    func updateTrackers()
    func setCameraOnTracker(trackerShowMap: Tracker)
    func updateSelfLocation(location:CLLocationCoordinate2D)
   
    func stopUpdatingSelfLoaction()
}

