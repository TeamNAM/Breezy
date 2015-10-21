//
//  SavedPlacesViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/20/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class SavedPlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PlaceLookupViewDelegate {
    
    // MARK: - Properties
    
    static let storyboardID = "SavedPlacesViewController"

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        let resultCellNib = UINib(nibName: SavedPlaceCell.reuseIdentifier, bundle: nil)
        self.tableView.registerNib(resultCellNib, forCellReuseIdentifier: SavedPlaceCell.reuseIdentifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    // MARK: - Button Handlers
    
    @IBAction func onAddPlace(sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: PlaceLookupViewController.storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(PlaceLookupViewController.storyboardID) as! PlaceLookupViewController
        vc.delegate = self
        presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    // MARK: - PlaceLookupViewDelegate
    
    func placeLookupViewController(placeLookupViewController: PlaceLookupViewController, didSelectPlace selectedPlace: Place) {
        print("Saved place")
        // TODO: Actually save the place
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(SavedPlaceCell.reuseIdentifier) as! SavedPlaceCell
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
}
