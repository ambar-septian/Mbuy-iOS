//
//  CheckOutAddressViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/25/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic
import GoogleMaps
import GooglePlaces

class CheckOutAddressViewController: BaseViewController {
    
    @IBOutlet weak var addressLabel: IconLabel! {
        didSet {
            addressLabel.text = "address".localize
            addressLabel.icon = FontAwesomeIcon.homeIcon
        }
    }

    @IBOutlet weak var noteLabel: IconLabel! {
        didSet {
            noteLabel.text = "deliveryNote".localize
            noteLabel.icon = FontAwesomeIcon.editIcon
        }
    }
    
    @IBOutlet weak var deliveryLabel: UILabel! {
        didSet {
            deliveryLabel.text = Double(0).formattedPrice
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cell = SearchPlaceTableViewCell.self
            tableView.register(cell.nib, forCellReuseIdentifier: cell.identifier)
            tableView.isHidden = true
        }
    }
    
    @IBOutlet weak var addressTextView: BorderTextView!
    
    @IBOutlet weak var noteTextView: BorderTextView!
    
    @IBOutlet weak var containerMapView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var distanceLabel: UILabel! {
        didSet {
            distanceLabel.text = nil
        }
    }
    
    fileprivate lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withTarget: Constants.GMAP.defaultCoordinate, zoom: 16)
        let mapView = GMSMapView.map(withFrame: self.containerMapView.bounds, camera: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
     
        return mapView
    }()
    
    fileprivate lazy var marker: GMSMarker = {
        let marker = GMSMarker()
        marker.position = Constants.GMAP.defaultCoordinate
        marker.title = "M-Commerce Store"
        marker.snippet = "Jakarta"
        marker.isDraggable = false
        marker.isTappable = false
        
        return marker
    }()
    
    fileprivate lazy var deliveryMarker: GMSMarker = {
        let marker = GMSMarker()
        marker.isDraggable = true
        marker.isTappable = true
        return marker
    }()

    
    fileprivate var deliveryCoordinate: CLLocationCoordinate2D?
    
    var deliveryCost: Double = 0 {
        didSet {
            deliveryLabel.text = deliveryCostFormatted
        }
    }
    
    var distance: Double = 0 {
        didSet {
            let distanceText = distance == 0 ? nil : "(\(distance) Km)"
            distanceLabel.text = distanceText
        }
    }
    
    fileprivate var deliveryCostFormatted: String {
        return deliveryCost.formattedPrice
    }
    
    fileprivate var isMapAlreadyLoad = false

    fileprivate var searchResults = [SearchPlace]() {
        didSet {
            tableView.reloadData()
            let isTableViewHidden = tableView.isHidden
            let isHidden = searchResults.count > 0 ? false : true
            guard isTableViewHidden != isHidden else { return }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { 
                self.tableView.isHidden = isHidden
            }, completion: nil)
        }
    }
    
    fileprivate var controller = SearchPlaceController()
    
    var selectedPlace: SearchPlace? {
        didSet {
            guard selectedPlace != nil else {
                deliveryCost = 0
                return
            }
            
            guard oldValue != selectedPlace else { return }
            
            if selectedPlace?.coordinate == nil {
                DispatchQueue.global().async {
                    self.controller.getDetailPlace(place: self.selectedPlace!) { (newPlace) in
                        guard newPlace != nil else { return }
                        self.setSearchResult(newPlace: newPlace!, isSetActiveMarker: true)
                    }
                    
                }
            } else {
                guard selectedPlace != nil else { return }
                self.setSearchResult(newPlace: selectedPlace!, isSetActiveMarker: false)
            }
           
        }
    }
    
    weak var childDelegate: CheckOutChildProtocol?
    
    var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !(isMapAlreadyLoad) else { return }
    
        containerMapView.addSubview(mapView)
        marker.map = mapView
        mapView.selectedMarker = marker
        
        isMapAlreadyLoad = true
   
    }
}

extension CheckOutAddressViewController {
    
    func toggleHideTableView(willHide: Bool){
        let animation: UIViewAnimationOptions = willHide  == true ? .curveEaseOut : .curveEaseOut
        
        UIView.animate(withDuration: 0.3, delay: 0, options: animation, animations: {
            self.tableView.isHidden = willHide
        }, completion: nil)

    }
    
    func beginSearch(timer: Timer) {
        guard let keyword = (timer.userInfo as? [String:Any])?["keyword"] as? String else { return }
        guard !(keyword.isEmpty) else { return }
        
        activityIndicator.startAnimating()
        DispatchQueue.global().async {
            self.controller.searchPlace(keyword: keyword, completion: { (searchPlaces) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.searchResults = searchPlaces
                }
                
            })
        }
    }
    
    func validateForm() -> (isValid:Bool, message:String?){
        if deliveryCost != 0 && selectedPlace != nil {
            return (isValid: true, message: nil)
            
        } else {
            return (isValid: false, message: "Address must not empty")

        }
    }
    
    fileprivate func setSearchResult(newPlace: SearchPlace, isSetActiveMarker: Bool){
        guard let coordinate = newPlace.coordinate else { return }
        self.distance = self.controller.distanceFromCoordinate(coordinate: coordinate)
        guard self.distance <= self.controller.maximumDistance else {
            let message = String(format: "deliveryAddressTooFar".localize, Int(self.controller.maximumDistance))
            Alert.showAlert(message: message, alertType: .okOnly, viewController: self)
            return
        }
        
        self.selectedPlace  = newPlace
        
        self.deliveryCost = self.controller.calculateDeliveryCost(distance: self.distance)
        self.addressTextView.text = self.selectedPlace!.name
        
        self.deliveryMarker.title = self.selectedPlace!.name
        self.deliveryMarker.snippet = self.selectedPlace!.descriptionPlace
        
        guard isSetActiveMarker else { return }
        setActiveMarker(coordinate: self.selectedPlace!.coordinate!)
        
    }
    
    fileprivate func setActiveMarker(coordinate: CLLocationCoordinate2D){
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 16)
       
        self.deliveryMarker.position = coordinate
        self.deliveryMarker.map = self.mapView
        self.mapView.selectedMarker = self.deliveryMarker
        self.mapView.animate(to: camera)
    }
    
    
}

extension CheckOutAddressViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        childDelegate?.didBeginTypingComponent()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        childDelegate?.didEndTypingComponent()
        
//        if textView == addressTextView {
//            toggleHideTableView(willHide: true)
//        }
//        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard textView == addressTextView else { return true }
        guard let textViewText = textView.text else { return false }
        
        selectedPlace = nil
        
        var fullString: String
        if range.length == 0 {
            fullString = textViewText.appending(text)
        } else {
            fullString = textViewText
            fullString.remove(at: fullString.index(before: fullString.endIndex))
        }
        if fullString.characters.count == 0 {
//            self.clearDataSource()
        }
        guard fullString.characters.count > 2 else {
            searchResults.removeAll()
            return true
        }
        
        
        if let timer = searchTimer {
            if timer.isValid {
                searchTimer?.invalidate()
            }
        }
        
        let userInfo = ["keyword": fullString]
        searchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(beginSearch(timer:)), userInfo: userInfo, repeats: false)
        
        return true
    }
}

extension CheckOutAddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        return SearchPlaceTableViewCell.configureCell(tableView: tableView, indexPath: indexPath, object: searchResult)
    }
}

extension CheckOutAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlace = searchResults[indexPath.row]
        searchResults.removeAll()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension CheckOutAddressViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        deliveryMarker.title = nil
        deliveryMarker.snippet = nil
        setActiveMarker(coordinate: coordinate)
        
        DispatchQueue.global().async {
            self.controller.getPlaceByCoordinate(coordinate: coordinate, completion: { (searchPlace) in
                DispatchQueue.main.async {
                    self.selectedPlace = searchPlace
                }
            })
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
    }
}

