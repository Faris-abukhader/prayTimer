//  locationManager.swift
//  pray timer
//  Created by admin on 2021/8/8.

import Foundation
import CoreLocation

class locationManager  {
    static let shared = locationManager()
    
    let manager = CLLocationManager()
    
    let data = getTime()

    func getUserLocationAutherization() ->Bool{
        var isAutherized = false
        
        // send request to the user to get the premission
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        // getting the user answer
        let autherizationStatus = manager.authorizationStatus
        
        // getting location ...
        let latitude:Double = Double(manager.location?.coordinate.latitude ?? 21.27)
        let longitude:Double = Double(manager.location?.coordinate.longitude ?? 39.49)
        
        
        // if the user denied our request will we show an alert to alarm the user to open location permission from settings
        if autherizationStatus == CLAuthorizationStatus.authorizedWhenInUse {
            isAutherized = true
            data.showLocationAlarm = false
        }else if autherizationStatus == CLAuthorizationStatus.denied {
            data.showLocationAlarm = true
        }
        
        return isAutherized
    }
    func getLocationCoordinate()->(latitude:Double,longitude:Double){
        return (Double(manager.location?.coordinate.latitude ?? 21.27),Double(manager.location?.coordinate.longitude ?? 39.49))
    }
    
}
