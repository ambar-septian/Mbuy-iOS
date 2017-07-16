//
//  CheckoutController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/26/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

typealias searchPlaceResults = ((_ searchResults: [SearchPlace]) -> Void)
typealias searchCompletePlace = ((_ searchPlace: SearchPlace?) -> Void)
class SearchPlaceController  {
    
    fileprivate let placesClient = GMSPlacesClient()
    let maximumDistance:Double = 30
    
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
    
    func getPlaceByCoordinate(coordinate: CLLocationCoordinate2D, completion: @escaping searchCompletePlace){
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
        
            guard let result = response?.firstResult() else {
                completion(nil)
                return
            }
            
            guard let name = result.thoroughfare else {
                completion(nil)
                return
            }
            
            let searchPlace = SearchPlace(placeID: nil, name: name, descriptionPlace: result.subLocality, coordinate: result.coordinate)
            completion(searchPlace)
        }
    }
    
    func getDetailPlace(place: SearchPlace, completion: @escaping searchCompletePlace){
        guard let placeID = place.placeID else { return }
        placesClient.lookUpPlaceID(placeID) { (gmsPlace, error) in
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
    
    func distanceFromCoordinate(coordinate: CLLocationCoordinate2D) -> Double {
        let defaultCoordinate = Constants.GMAP.defaultCoordinate
        let defaultLocation = CLLocation(latitude: defaultCoordinate.latitude, longitude: defaultCoordinate.longitude)
        let targetLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let result = ((defaultLocation.distance(from: targetLocation) / 1000) / 3)
        
        return result.rounded(.toNearestOrEven)
    }
    
    func calculateDeliveryCost(distance: Double) -> Double {
       return max(Constants.deliveryPrice,distance * Constants.deliveryPrice)
    }
}
