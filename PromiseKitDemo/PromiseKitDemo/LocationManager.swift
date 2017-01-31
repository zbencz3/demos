//
//  LocationManager.swift
//  PromiseKitDemo
//
//  Created by Zsolt Bencze on 31/01/2017.
//  Copyright © 2017 iSylva. All rights reserved.
//

import Foundation
import CoreLocation
import PromiseKit

class LocationManager  {
    let coder = CLGeocoder()

    func getLocation() -> Promise<CLPlacemark> {
        return CLLocationManager.promise().then { location in
            return self.coder.reverseGeocode(location: location)
        }
    }

    func searchForPlacemark(text: String) -> Promise<CLPlacemark> {
        return CLGeocoder().geocode(text)
    }
    
}

