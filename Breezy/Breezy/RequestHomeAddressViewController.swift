//
//  RequestHomeAddressViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 11/4/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class RequestHomeAddressViewController: UIViewController {
    
    
    @IBAction func addHomeAddress(sender: UIButton) {
        let vc = PlaceLookupViewController.instantiateFromStoryboard()
        vc.lookupCanceledHandler = {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        vc.placeSelectedHandler = { (selectedPlace: Place) -> Void in
            User.sharedInstance.home = selectedPlace
            self.dismissViewControllerAnimated(true, completion: nil)
            self.showNextScreen()
        }
        let navVC = UINavigationController(rootViewController: vc)
        self.presentViewController(navVC, animated: true, completion: nil)
    }
    
    func showNextScreen() {
        self.performSegueWithIdentifier("showRequestWorkAddress", sender: self)
    }
}
