//
//  File.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/26/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import CoreLocation

class SearchPlace {
    var placeID:String
    var coordinate: CLLocationCoordinate2D?
    var name: String
    var descriptionPlace: String
    
    init(placeID:String, name:String, descriptionPlace:String, coordinate:CLLocationCoordinate2D?) {
        self.placeID = placeID
        self.name = name
        self.descriptionPlace = descriptionPlace
        self.coordinate = coordinate
    }

}
