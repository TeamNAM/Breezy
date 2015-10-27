//
//  WelcomeViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/26/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import CoreLocation
import UIKit

class WelcomeViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Static initializer
    
    static func instantiateFromStoryboard() -> UIViewController {
        return UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
    }
    
    // MARK: - Static properties
    
    static let storyboardID = "WelcomeViewController"
    
    // MARK: - Properties
    
    @IBOutlet weak var locationAccessView: UIView!
    @IBOutlet weak var workAddressView: UIView!
    
    var locationManager: CLLocationManager!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationAccessView.hidden = false
        self.workAddressView.hidden = true
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            manager.requestAlwaysAuthorization()
        case .AuthorizedAlways:
            self.showWorkAddressView()
        default:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "If you later decide to enable weather alerts, open this app's settings and set location access to 'Always'.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Got it, thanks", style: .Cancel) { (action) in
                self.showWorkAddressView()
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
    
    @IBAction func onSkipLocationAccess(sender: UIButton) {
        self.showWorkAddressView()
    }
    
    @IBAction func onSkipWorkAddress(sender: UIButton) {
        User.sharedInstance.hasViewedWelcome = true
        AppDelegate.sharedDelegate().showTabViewController()
    }
    
    @IBAction func onEnterWorkAddress(sender: UIButton) {
        // TODO(nikrad): Implement place look up controller
        User.sharedInstance.hasViewedWelcome = true
        AppDelegate.sharedDelegate().showTabViewController()
    }
    
    func showWorkAddressView() {
        self.workAddressView.hidden = false
        self.workAddressView.frame.origin = CGPoint(x: self.view.frame.width, y: self.view.frame.origin.y)
        UIView.animateWithDuration(0.25, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
            self.locationAccessView.frame.origin = CGPoint(x: -self.view.frame.width, y: self.view.frame.origin.y)
            self.workAddressView.frame.origin = CGPoint(x: self.view.frame.origin.x, y: self.view.frame.origin.y)
        }, completion: nil)
    }
    
}
