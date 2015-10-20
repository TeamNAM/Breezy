//
//  PlaceLookupViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import GoogleMaps
import UIKit

@objc protocol PlaceLookupViewDelegate {
    optional func placeLookupViewController(placeLookupViewController: PlaceLookupViewController, didSelectPlace selectedPlace: Place)
}

class PlaceLookupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: Static properties
    
    static let storyboardID = "PlaceLookupViewController"
    
    // MARK: Types
    
    // Controller states
    enum ControllerState: Int {
        case SearchStart
        case Searching
        case Confirming
    }
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    
    weak var delegate: PlaceLookupViewDelegate?
    var debounceTimer: NSTimer?
    var placesClient: GMSPlacesClient!
    var predictions = [GMSAutocompletePrediction]()
    var searchBar: UISearchBar!
    var selectedPlace: GMSPlace?
    var startOverButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placesClient = GMSPlacesClient()
        
        // Set up buttons
        self.cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "onTapCancelButton:")
        self.saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "onSavePlace:")
        self.startOverButton = UIBarButtonItem(title: "Start over", style: .Plain, target: self, action: "onTapStartOver:")
        
        // Set up the map
        
        self.mapView.camera = GMSCameraPosition.cameraWithLatitude(37.785834, longitude: -122.406417, zoom: 10)
        
        // Set up tableview
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let resultCellNib = UINib(nibName: "PlacePredictionCell", bundle: nil)
        self.tableView.registerNib(resultCellNib, forCellReuseIdentifier: PlacePredictionCell.reuseIdentifier)
        self.tableView.hidden = true
        
        // Set up search bar
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        self.searchBar = UISearchBar()
        self.searchBar.placeholder = "Search for a place"
        self.searchBar.delegate = self
        self.searchBar.sizeToFit()
        self.setState(ControllerState.SearchStart)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: State setters
    
    func setState(state: ControllerState) {
        switch state {
        case .SearchStart:
            self.mapView.hidden = true
            self.tableView.hidden = true
            self.navigationItem.title = nil
            self.navigationItem.titleView = self.searchBar
            self.navigationItem.leftBarButtonItem = self.cancelButton
            self.navigationItem.rightBarButtonItem = nil
            self.searchBar.becomeFirstResponder()
        case .Searching:
            self.mapView.hidden = true
            self.tableView.hidden = false
            self.navigationItem.title = nil
            self.navigationItem.titleView = self.searchBar
            self.navigationItem.leftBarButtonItem = self.cancelButton
            self.navigationItem.rightBarButtonItem = nil
        case .Confirming:
            self.mapView.hidden = false
            self.tableView.hidden = true
            self.navigationItem.title = self.selectedPlace?.name
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = self.startOverButton
            self.navigationItem.rightBarButtonItem = self.saveButton
        }
    }
    
    // MARK: Button actions
    
    func onTapCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onTapStartOver(sender: AnyObject) {
        self.setState(ControllerState.SearchStart)
    }
    
    func onSavePlace(sender: AnyObject) {
        let place = Place(lat: self.selectedPlace!.coordinate.latitude, lng: self.selectedPlace!.coordinate.longitude, addressDescription: self.selectedPlace!.formattedAddress)
        self.delegate?.placeLookupViewController?(self, didSelectPlace: place)
        dismissViewControllerAnimated(true, completion: nil)
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
        self.selectPlace(indexPath.row)
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.selectPlace(0)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
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
        self.setState(ControllerState.SearchStart)
    }
    
    // MARK: API Calls
    
    func selectPlace(placeIndex: Int) {
        let placeID = self.predictions[placeIndex].placeID
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
                
                self.selectedPlace = place
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.camera = GMSCameraPosition.cameraWithLatitude(place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 10)
                    let marker = GMSMarker()
                    marker.position = place.coordinate
                    marker.map = self.mapView
                    self.setState(ControllerState.Confirming)
                }
            } else {
                print("No place details for \(placeID)")
            }
        }
    }
    
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
