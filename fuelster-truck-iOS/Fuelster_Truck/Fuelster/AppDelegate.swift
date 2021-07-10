//
//  AppDelegate.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 08/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import Stripe
import Flurry_iOS_SDK
import CoreData

import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    
    var window: UIWindow?
    var sliderVC = SlideMenuController()
    var notificationView = Fuelster_NotificationView.instanceFromNib()
    
    
    //sandeep commit
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        
        //Set NumberPlate for first launch and Login Screen from next time
        self.setRootViewController()
        self.addNotifyView()
        
        let defs = NSUserDefaults.standardUserDefaults()
        if defs.objectForKey(kUserAuthToken) as? String == nil {
            let keychain = RBAKeyChainWrapper.sharedInstance
            keychain.wipeKeychainData()
        }
        //est Secret key :  sk_test_EdDvN1PFhxHP1CEY7573OhF9
        // test Publishable key : pk_test_HWexv0EcvwROn2aNo8r9a58U
        
        // APPSTORE Publishable key: pk_live_wtBvjfuMgYmTUSsDVJ3hZZAh
        
        //Stripe key
        STPPaymentConfiguration.sharedConfiguration().publishableKey = "pk_test_HWexv0EcvwROn2aNo8r9a58U"
        setFlurry()
        setFabrics()
        //Push notification
        registerForPushNotifications(application)
        
        self.customappearance()
        return true
    }
    
    
    //Set NumberPlate for first launch and Login Screen from next time
    func setRootViewController()
    {
        window =  UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let launchTimes = NSUserDefaults.standardUserDefaults().boolForKey("showLogin")
        
        if launchTimes == true //Number plate View
        {
            let rootController = storyboard.instantiateViewControllerWithIdentifier(LOGIN_VC)
            
            if let window = self.window
            {
                window.rootViewController = rootController
            }
        }
            
        else //Login view
        {
            let rootController = storyboard.instantiateViewControllerWithIdentifier(NUMBER_PLATE_VC)
            
            if let window = self.window
            {
                window.rootViewController = rootController
            }
        }
        
    }
    
    
    
    func registerForPushNotifications(application: UIApplication)
    {
        let notificationSettings = UIUserNotificationSettings(forTypes: [ .Sound, .Alert], categories: nil)
        
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings)
    {
        if notificationSettings.types != .None
        {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

        self.showNotifiyView()
       // print("=== === ==== userInfo \(userInfo)")
        let message = (userInfo["body"] as? [NSObject:AnyObject])!["message"] as? String
        let title = (userInfo["body"] as? [NSObject:AnyObject])!["title"] as? String
        let order = (userInfo["body"] as? [NSObject:AnyObject])!["order"] as? [NSObject:AnyObject]
        let entityDescription = NSEntityDescription.entityForName("Notifications", inManagedObjectContext: self.managedObjectContext)
        let entity = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
        
        entity.setValue(order!["quantity"] as! Double, forKey: "quantity")
        entity.setValue(order!["fuelType"] as! String, forKey: "fuelType")
        entity.setValue(order!["time"] as! String, forKey: "notificationTime")
        entity.setValue(order!["time"] as! String, forKey: "time")
        entity.setValue(message, forKey: "title")
        entity.setValue(order!["_id"] as! String, forKey: "orderId")
        entity.setValue(order!["price"] as! Double, forKey: "price")
        entity.setValue(order!["status"] as! String, forKey: "status")
        entity.setValue(message, forKey: "alertMessage")
        
        /*
        if sliderVC.childViewControllers.count>0
        {
            let vc = sliderVC.childViewControllers[0]
            
            let rbaAlert = UIAlertController (title: "", message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction.init(title: "Ok", style: .Default , handler)
            rbaAlert.addAction(okAction)
            vc.presentViewController(rbaAlert, animated: true, completion: nil)
        }
        
        */
        
        let notifiAlert = UIAlertView()
        var NotificationMessage : AnyObject? =  userInfo["alert"]
        notifiAlert.title = kappName
        notifiAlert.message = message
        notifiAlert.addButtonWithTitle("OK")
        notifiAlert.show()
        notifiAlert.delegate = self

        
        
        
        do {
            try entity.managedObjectContext?.save()
        } catch {
            //print(error)
        }
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["message"] as? NSString {
                    //Do stuff
                }
            } else if let alert = aps["alert"] as? NSString {
                //Do stuff
            }
        }
        
        
    }
    
    func customappearance() -> Void
    {
        let image = UIImage.init(named: "Back_Small")
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-400.0, 0), forBarMetrics: UIBarMetrics.Default)
        
        //        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarPosition: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var deviceTokenString = ""
        
        for i in 0..<deviceToken.length
        {
            deviceTokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        //print("Device Token========== :", deviceTokenString)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(deviceTokenString, forKey: "deviceTokenString")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        //print("Failed to register:", error)
    }
    
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // addNotifyView()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    
    func setFlurry()  {
        Flurry.startSession("NSYV66QVTHNW6982FJRF")
    }
    
    func  setFabrics()  {
        Fabric.with([STPAPIClient.self, Crashlytics.self])
    }
    
    func addNotifyView()
    {
        notificationView.frame = CGRectMake(0, 0, self.window!.frame.size.width, 66)
        notificationView.hidden = true
        self.window?.addSubview(notificationView)
    }
    
    func showNotifiyView()
    {
        
        if sliderVC.childViewControllers.count>0 {
            let vc = sliderVC.childViewControllers[0]
            
            if (vc.isKindOfClass(Fuelster_NotificationListVC))
            {
                return
            }
            notificationView.hidden = false
        }
        
    }
    
    func pushNotificationVC()
    {
        let vc = sliderVC.childViewControllers[0]
        //        //print("navigating from %@",sliderVC.childViewControllers)
        //        //print("navigating from %@",vc)
        vc.pushViewControllerWithIdentifier("Fuelster_NotificationListVC")
        
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "uk.co.plymouthsoftware.core_data" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Fuelster_Truck", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Fuelster.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                //NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    

    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        let topvc = self.topViewController()
        print(topvc?.classForCoder)
        print(Fuelster_MainVC.classForCoder())
        
        
        if(Fuelster_OrderDetailVC.classForCoder() == topvc?.classForCoder )
        {
            let orderDetailsVC = topvc as! Fuelster_OrderDetailVC
            orderDetailsVC.refreshButtonAction([:])
        }
        
        if(Fuelster_MainVC.classForCoder() == topvc?.classForCoder )
        {
            let mainVC = topvc as! Fuelster_MainVC
            mainVC.refreshButtonAction([:])
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("MainOrdersRefresh", object: nil)
        //OrderDetailsRefresh
         NSNotificationCenter.defaultCenter().postNotificationName("OrderDetailsRefresh", object: nil)
    }
    
    
    
    //To get the top /current view contorller
    func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let slideVc = base as? SlideMenuController {
            return topViewController(slideVc.mainViewController)
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
     
        return base
    }
    
    



    
    
    
    
}

