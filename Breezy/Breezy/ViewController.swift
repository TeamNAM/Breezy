//
//  ViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/12/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import CoreData
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
    
    //example code
    User.userData?.work = Place(lat: 1.0, lng: 2.0, addressDescription: "10 Downing St")
    User.userData?.home = Place(lat: 155.5, lng: 12.0, addressDescription: "1 Kennedy St")
    
    let vc = TripsViewController(nibName: "TripsViewController", bundle: NSBundle.mainBundle())
    addSubView(vc)
  }
    
    func addSubView(viewController: UIViewController) {
        
        self.addChildViewController(viewController)
//        viewController.view.translatesAutoresizingMaskIntoConstraints = false
//        viewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        viewController.didMoveToParentViewController(self)
        self.view.addSubview(viewController.view)
    }
}

