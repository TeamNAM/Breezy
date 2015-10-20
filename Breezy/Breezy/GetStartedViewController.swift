//
//  GetStartedViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts

class GetStartedViewController: UIViewController, PlaceLookupViewDelegate {
    
    // MARK: Properties
    
    var locationManager: CLLocationManager!
    var contactStore: CNContactStore!
    
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.locationManager = CLLocationManager()
//        switch CLLocationManager.authorizationStatus() {
//            case .Denied, .NotDetermined, .Restricted:
//                self.locationManager.requestAlwaysAuthorization()
//            default: ()
//        }
//
//        self.contactStore = CNContactStore()
//        switch CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts) {
//            case .Denied, .NotDetermined, .Restricted:
//                self.contactStore.requestAccessForEntityType(CNEntityType.Contacts) { (granted: Bool, error: NSError?) -> Void in
//                    if let error = error {
//                        print("Access denied: \(error)")
//                    } else {
//                        print("Got access")
//                    }
//                }
//            default: ()
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let aStoryboard = UIStoryboard(name: "PlaceLookupViewController", bundle: nil)
        let vc = aStoryboard.instantiateViewControllerWithIdentifier(PlaceLookupViewController.storyboardID) as! PlaceLookupViewController
        vc.delegate = self
        presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    // MARK: PlaceLookupViewDelegate
    
    func placeLookupViewController(placeLookupViewController: PlaceLookupViewController, didSelectPlace selectedPlace: Place) {
        print("Selected place!")
        print(selectedPlace)
    }
}
