//
//  RequestWorkAddressViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 11/4/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class RequestWorkAddressViewController: UIViewController {
    @IBOutlet weak var iconImageView: UIImageView!
    override func viewDidLoad() {
        var image = iconImageView.image
        image = image?.imageWithRenderingMode(.AlwaysTemplate)
        iconImageView.image = image
        iconImageView.contentMode = .ScaleAspectFit
        iconImageView.tintColor = UIColor.whiteColor()
    }
    
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
