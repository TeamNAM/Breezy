//
//  RequestLocationAccessViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/26/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import CoreLocation
import UIKit

class RequestLocationAccessViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    private var locationManager: CLLocationManager!
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            manager.requestWhenInUseAuthorization()
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            self.showNextScreen()
        default:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "If you later decide to enable weather alerts, open this app's settings and set location access to 'While Using the App'.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Got it, thanks", style: .Cancel) { (action) in
                self.showNextScreen()
            }
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func onLocationAllowed(sender: UIButton) {
        
        // This will fire the didChangeAuthorizationStatus delegate method, where we'll request permission.
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
    }
    
    func showNextScreen() {
        self.performSegueWithIdentifier("showRequestHomeAddress", sender: self)
    }
    
}
