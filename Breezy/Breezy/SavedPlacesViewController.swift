//
//  SavedPlacesViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/20/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class SavedPlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PlaceLookupViewDelegate {
    
    // MARK: - Static initializer
    
    static func instantiateFromStoryboard() -> UIViewController {
        return UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
    }
            
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
        
        print(User.userData?.home)
        print(User.userData?.work)
        print(User.userData?.other)
    }
    
    // MARK: - Button Handlers
    
    @IBAction func onAddPlace(sender: UIBarButtonItem) {
        let vc = PlaceLookupViewController.instantiateFromStoryboard(self)
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - PlaceLookupViewDelegate
    
    func placeLookupViewController(placeLookupViewController: PlaceLookupViewController, didSelectPlace selectedPlace: Place) {
//        User.userData?.addOtherPlace(selectedPlace)
        User.userData?.addHome(selectedPlace)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(SavedPlaceCell.reuseIdentifier) as! SavedPlaceCell
        switch indexPath.row {
        case 0:
            cell.placeType = PlaceType.Home
            cell.place = User.userData?.home
        case 1:
            cell.placeType = PlaceType.Work
            cell.place = User.userData?.work
        default:
            cell.placeType = PlaceType.Other
            cell.place = nil
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
}
