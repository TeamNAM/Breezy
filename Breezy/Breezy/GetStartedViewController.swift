//
//  GetStartedViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import CoreLocation

class GetStartedViewController: UIViewController {
    
    // MARK: Properties
    
    var locationManager: CLLocationManager!
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager = CLLocationManager()
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
    }

}
