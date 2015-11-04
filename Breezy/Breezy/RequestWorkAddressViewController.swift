//
//  RequestWorkAddressViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 11/4/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class RequestWorkAddressViewController: UIViewController {
    
    @IBAction func addWorkAddress(sender: UIButton) {
        let vc = PlaceLookupViewController.instantiateFromStoryboard()
        vc.lookupCanceledHandler = {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        vc.placeSelectedHandler = { (selectedPlace: Place) -> Void in
            User.sharedInstance.work = selectedPlace
            self.dismissViewControllerAnimated(true, completion: nil)
            AppDelegate.sharedDelegate().showTabViewController()
        }
        let navVC = UINavigationController(rootViewController: vc)
        self.presentViewController(navVC, animated: true, completion: nil)
    }
    
    @IBAction func onSkip(sender: AnyObject) {
        AppDelegate.sharedDelegate().showTabViewController()
        User.sharedInstance.hasViewedWelcome = true
    }
}
