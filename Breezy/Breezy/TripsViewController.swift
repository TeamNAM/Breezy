//
//  TripsViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/16/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

let apiTrips = [["name": "Mexico", "address": "1800 Paradise Dr. Hermosillo Mx 02932"]]

class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tripTableView: UITableView!
    var trips = apiTrips
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addTripCellNib = UINib(nibName: "AddTripCell", bundle: NSBundle.mainBundle())
        let tripCellNib = UINib(nibName: "TripCell", bundle: NSBundle.mainBundle())
        
        tripTableView.delegate = self
        tripTableView.dataSource = self
        
        tripTableView.registerNib(addTripCellNib, forCellReuseIdentifier: "AddTripCell")
        tripTableView.registerNib(tripCellNib, forCellReuseIdentifier: "TripCell")
        tripTableView.rowHeight = UITableViewAutomaticDimension
        tripTableView.estimatedRowHeight = 150
        tripTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count == 0 ? 1 : trips.count+1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddTripCell", forIndexPath: indexPath) as! AddTripCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TripCell", forIndexPath: indexPath) as! TripCell
            cell.place = trips[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView.cellForRowAtIndexPath(indexPath) is AddTripCell {
            let newTripController = NewTripViewController(nibName: "NewTripViewController", bundle: NSBundle.mainBundle())
            self.navigationController?.pushViewController(newTripController, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
