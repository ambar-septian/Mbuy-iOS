//
//  CheckoutController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/26/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import GooglePlaces

typealias searchPlaceResults = ((_ searchResults: [SearchPlace]) -> Void)
typealias searchCompletePlace = ((_ searchPlace: SearchPlace?) -> Void)
class SearchPlaceController  {
    
    fileprivate let placesClient = GMSPlacesClient()
    
    func searchPlace(keyword:String, completion: @escaping searchPlaceResults) {
        let gmapConst = Constants.GMAP.self
        let bounds = GMSCoordinateBounds(coordinate: gmapConst.indonesiaFarLeftCoordinate, coordinate: gmapConst.indonesiaFarRightCoordinate)
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        
        placesClient.autocompleteQuery(keyword, bounds: bounds, filter: filter) { (results, error) in
            var places = [SearchPlace]()
            if let error = error {
                print("Error Google Maps \(error)")
                completion(places)
            }
            
            guard let searchResults = results else {
                completion(places)
                return
            }
            
            
            for result in searchResults {
                guard let placeID = result.placeID else { continue }
                let name = result.attributedPrimaryText.string
                let description = result.attributedSecondaryText?.string ?? ""
                
                let place = SearchPlace(placeID: placeID, name: name, descriptionPlace: description, coordinate: nil)
                places.append(place)
            }
            
            completion(places)
        }
        
    }
    
    func getDetailPlace(place: SearchPlace, completion: @escaping searchCompletePlace){
        placesClient.lookUpPlaceID(place.placeID) { (gmsPlace, error) in
            if let error = error {
                print("Error Google Maps \(error)")
                completion(nil)
            }
            
            guard gmsPlace != nil else {
                print("Search Placce nil")
                completion(nil)
                return
            }
            
            place.coordinate = gmsPlace!.coordinate
            completion(place)
        }
    }
    
    func calculateDeliveryCost(coorindate:CLLocationCoordinate2D) -> Double {
        let defaultCoordinate = Constants.GMAP.defaultCoordinate
        let defaultLocation = CLLocation(latitude: defaultCoordinate.latitude, longitude: defaultCoordinate.longitude)
        let targetLocation = CLLocation(latitude: coorindate.latitude, longitude: coorindate.longitude)
        let result = ((defaultLocation.distance(from: targetLocation) / 1000) / 3)
        let roundResult = result.rounded(.toNearestOrEven)
        
        return roundResult * Constants.deliveryPrice
    }
}
