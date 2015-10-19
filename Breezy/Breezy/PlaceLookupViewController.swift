//
//  PlaceLookupViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceLookupViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    var placesClient: GMSPlacesClient!
    var debounceTimer: NSTimer?
    
    var predictions = [GMSAutocompletePrediction]()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placesClient = GMSPlacesClient()
        
        // Set up tableview
        self.tableView.dataSource = self
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
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PlacePredictionCell.reuseIdentifier) as! PlacePredictionCell
        cell.prediction = self.predictions[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.predictions.count
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
        self.tableView.hidden = true
    }
    
    // MARK: API Calls
    
    func callAutoCompleteAndTableReload(timer: NSTimer) {
        if let userInfo = timer.userInfo {
            let trimmedText = userInfo as! String
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
