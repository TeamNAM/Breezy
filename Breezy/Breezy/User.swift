//
//  User.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/18/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var _currentUser: User?

class User{
    var userEntity: NSManagedObject?
    weak var home: Place?{
        didSet{
            if home != nil{
                setPlace("home", place: home!)
            }
        }
    }
    weak var work: Place?{
        didSet{
            if work != nil{
                setPlace("work", place: work!)
            }
        }
    }

    var otherPlaces: [Place]?
    var trips: [NSDictionary]?
    
    init(userEntity: NSManagedObject){
        self.userEntity = userEntity
    }
    
    class var userData: User? {
        get {
            if _currentUser == nil {
                var user:NSManagedObject?
                let managedObjectContext = AppDelegate.sharedDelegate().managedObjectContext
                let fetchRequest = NSFetchRequest(entityName: "User")
                let entityUser = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
                do {
                    let results = try managedObjectContext.executeFetchRequest(fetchRequest) as NSArray
                    if results.count != 0 {
                        user = results.objectAtIndex(0) as! NSManagedObject
                        print(user)
                    } else {
                        user = NSManagedObject.init(entity: entityUser!, insertIntoManagedObjectContext: managedObjectContext)
                        do {
                            try user!.managedObjectContext!.save()
                        } catch {
                            print("could not create new user")
                        }
                    }
                    
                } catch let error as NSError {
                    print("could not fetch - error")
                }
                let otherPlace = Place(lat: 13.4, lng: 12.2, addressDescription: "other place 2", placeType: .Other, recommendationIcon: nil, recommendationMessage: nil, detailedMessage: nil)
                _currentUser = User(userEntity: user!)
                _currentUser!.addOtherPlace(otherPlace)
                print(_currentUser?.userEntity?.valueForKey("other")!.count)
            }
            return _currentUser
        }
    }
    
    func setPlace(key: String, place: Place){
        let managedObjectContext = AppDelegate.sharedDelegate().managedObjectContext
        let placeEntity = NSEntityDescription.entityForName("Place", inManagedObjectContext: managedObjectContext)
        let placeObject = NSManagedObject.init(entity: placeEntity!, insertIntoManagedObjectContext: managedObjectContext)
        placeObject.setValue(place.lat, forKey: "lat")
        placeObject.setValue(place.lng, forKey: "lng")
        placeObject.setValue(place.addressDescription, forKey: "addressDescription")
        do {
            try placeObject.managedObjectContext?.save()
            _currentUser?.userEntity?.setValue(placeObject, forKey: key)
            try _currentUser?.userEntity?.managedObjectContext?.save()
            
        } catch {
            print("Error in setting home address")
        }
    }
    
    func addOtherPlace(place: Place){
        //TODO(Anvisha)
    }
}