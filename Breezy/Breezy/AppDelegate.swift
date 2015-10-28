//
//  AppDelegate.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/12/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import CoreData
import ForecastIOClient
import GoogleMaps
import UIKit

var appData: NSMutableDictionary?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties
    
    var window: UIWindow?
    var navigationDelegate: NavigationControllerDelegate?
    
    // MARK: App Life Cycle
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        print("Documents Directory: \(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!)")
        _currentUser = self.dataFromDisk()
        
        // Set API keys from Credentials.plist file
        let credentials = Credentials.defaultCredentials
        ForecastIOClient.apiKey = credentials.forecastKey
        GMSServices.provideAPIKey(credentials.googleKey)

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        
        self.navigationDelegate = NavigationControllerDelegate()
        
        if User.sharedInstance.hasViewedWelcome {
            self.showTabViewController()
        } else {
            self.window?.rootViewController = WelcomeViewController.instantiateFromStoryboard()
        }
        
        
        return true
    }
    
    func dataFromDisk() -> User {
        let archivedUser = NSKeyedUnarchiver.unarchiveObjectWithFile(pathForKeyedArchive) as? User
        return archivedUser ?? User()
    }
    
    private func saveToDisk(){
        print("saved to disk")
        NSKeyedArchiver.archiveRootObject(User.sharedInstance, toFile: pathForKeyedArchive)
    }
    
    private var pathForKeyedArchive:String{
        return (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as NSString).stringByAppendingPathComponent("archive.plist")
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        self.saveToDisk()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits
        self.saveToDisk()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveToDisk()
    }
    
    func showTabViewController() {
        // Create tab bar controller
        let todayVC = TodayViewController.instantiateFromStoryboard()
        todayVC.title = "Today"
        todayVC.tabBarItem.image = UIImage(named: "calendar icon")
        
        let tripsVC = TripsViewController.instantiateFromStoryboard()
        tripsVC.title = "Trips"
        tripsVC.tabBarItem.image = UIImage(named: "paper airplane")
        
        let tabBarVC = UITabBarController()
        let viewControllers = [todayVC, tripsVC]
        let embeddedVCs = viewControllers.map { (vc) -> UINavigationController in
            return UINavigationController(rootViewController: vc)
        }
        tabBarVC.viewControllers = embeddedVCs
        
        self.window?.rootViewController = tabBarVC
    }
    
    // MARK: - Delegate access in view controllers
    
    static func sharedDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}

