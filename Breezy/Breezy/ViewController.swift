//
//  ViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/12/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import ForecastIOClient

class ViewController: UIViewController {

  @IBOutlet weak var temperatureLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // San Francisco
    let lat = 37.7833
    let long = 122.4167
    
    ForecastIOClient.sharedInstance.forecast(lat, longitude: long) { (forecast, forecastAPICalls) -> Void in
      let currentTemperature = Int(round(forecast.currently!.temperature!))
      self.temperatureLabel.text = "\(currentTemperature)°"
      
      print("\(1000 - forecastAPICalls!) API calls left today")
    }
    
    //Testing code for Model
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.loadApplicationData()
    print("Home value right now \(User.sharedInstance.home)")
    User.sharedInstance.setHome(6.0, lng: 6.0, addressDescription: "HomeAddress Dummy")
    User.sharedInstance.setWork(1.0, lng: 1.0, addressDescription: "WorkAddress")
    User.sharedInstance.addOther(4.0, lng: 4.0, addressDescription: "Other 1")
    User.sharedInstance.addOther(2.3, lng: 2.3, addressDescription: "Other 2")
    appDelegate.saveApplicationData(appData!)
    
  //  let vc = TripsViewController(nibName: "TripsViewController", bundle: NSBundle.mainBundle())
  //  addSubView(vc)
  }
    
    func addSubView(viewController: UIViewController) {
        
        self.addChildViewController(viewController)
//        viewController.view.translatesAutoresizingMaskIntoConstraints = false
//        viewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        viewController.didMoveToParentViewController(self)
        self.view.addSubview(viewController.view)
    }
}

