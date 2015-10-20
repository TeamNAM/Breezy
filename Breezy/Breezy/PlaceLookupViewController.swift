//
//  PlaceLookupViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import CoreLocation
import GoogleMaps
import UIKit

@objc protocol PlaceLookupViewDelegate {
    optional func placeLookupViewController(placeLookupViewController: PlaceLookupViewController, didSelectPlace selectedPlace: Place)
}

class PlaceLookupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CLLocationManagerDelegate {
    // MARK: Types
    
    // Controller states
    enum ControllerState: Int {
        case Searching
        case Confirming
    }
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!

    weak var delegate: PlaceLookupViewDelegate?
    var debounceTimer: NSTimer?
    var locationManager: CLLocationManager!
    var placesClient: GMSPlacesClient!
    var predictions = [GMSAutocompletePrediction]()
    var searchController: UISearchController!
    var selectedPlace: Place?
    var state: ControllerState!
    
    // MARK:
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.state = ControllerState.Searching
        
        self.placesClient = GMSPlacesClient()

        // Set up the map
//        self.locationManager = CLLocationManager()
//        MapHelpers.triggerCurrentLocation(self.locationManager, delegate: self)
        self.mapView.camera = GMSCameraPosition.cameraWithLatitude(37.785834, longitude: -122.406417, zoom: 10)
//        self.mapView.myLocationEnabled = true
//        self.mapView.settings.myLocationButton = true
        
        // Set up tableview
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let resultCellNib = UINib(nibName: "PlacePredictionCell", bundle: nil)
        self.tableView.registerNib(resultCellNib, forCellReuseIdentifier: PlacePredictionCell.reuseIdentifier)
        self.tableView.hidden = true
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense.  Should set probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
    }
    
    // MARK: Action handlers
    
    func onCancelConfirmPlace(sender: AnyObject) {
        let searchBar = self.searchController.searchBar
        searchBar.text = ""
        searchBar.hidden = false
        searchBar.becomeFirstResponder()
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func onFinishConfirmPlace(sender: AnyObject) {
        print("confirm finish")
        self.delegate?.placeLookupViewController?(self, didSelectPlace: self.selectedPlace!)
        self.navigationController?.popViewControllerAnimated(true)
    }
   
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PlacePredictionCell.reuseIdentifier) as! PlacePredictionCell
        cell.prediction = self.predictions[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.predictions.count
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let placeID = self.predictions[indexPath.row].placeID
        print(placeID)
        self.placesClient.lookUpPlaceID(placeID) { (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place placeID \(place.placeID)")
                print("Place attributions \(place.attributions)")
                
                self.selectedPlace = Place(lat: place.coordinate.latitude, lng: place.coordinate.longitude, addressDescription: place.formattedAddress)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.camera = GMSCameraPosition.cameraWithLatitude(place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 12)
                    let marker = GMSMarker()
                    marker.position = place.coordinate
                    marker.map = self.mapView
                    self.tableView.hidden = true
                    self.searchController.searchBar.hidden = true
                    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "onCancelConfirmPlace:")
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "onFinishConfirmPlace:")
                }
            } else {
                print("No place details for \(placeID)")
            }
        }
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            let trimmedText = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if trimmedText.characters.count > 0 {
                if let timer = debounceTimer {
                    timer.invalidate()
                }
                debounceTimer = NSTimer(timeInterval: 0.25, target: self, selector: Selector("callAutoCompleteAndTableReload:"), userInfo: trimmedText, repeats: false)
                NSRunLoop.currentRunLoop().addTimer(debounceTimer!, forMode: "NSDefaultRunLoopMode")
                return
            }
        }
        self.tableView?.hidden = true
    }
    
    // MARK: API Calls
    
    func callAutoCompleteAndTableReload(timer: NSTimer) {
        if let text = timer.userInfo {
            let trimmedText = text as! String
            MapHelpers.placeAutocomplete(placesClient, query: trimmedText) { (predictions, error) -> Void in
                if let predictions = predictions {
                    self.predictions = predictions
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.hidden = false
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
