//
//  RBAAlertController.swift
//  DrillLogs
//
//  Created by Sandeep Kumar on 17/06/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class RBAAlertController: NSObject {

    var presentController :UIViewController!
    var rbaAlert : UIAlertController!
    
    
    func initAlertController(message:String, controller:UIViewController) {
       
        self.presentController = controller
        rbaAlert = UIAlertController (title: "", message: message, preferredStyle: .Alert)
    }
    
    func initAlertControllerWithTitle(title:String, message:String, controller:UIViewController) {
        
        self.presentController = controller
        rbaAlert = UIAlertController (title: title, message: message, preferredStyle: .Alert)
    }
    

    
    func presentAlertWithMessage(message:String, controller:UIViewController)  {
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.initAlertController(message, controller: controller)
            let okAction = UIAlertAction (title: "OK", style: .Default, handler: nil)
            self.rbaAlert.addAction(okAction)
            self.presentController .presentViewController(self.rbaAlert, animated: true, completion: nil)
        }
    }
    
    func presentAlertWithTitleAndMessage(title:String, message:String, controller:UIViewController)  {
        
        dispatch_async(dispatch_get_main_queue()) {
            //  self.initAlertController(title:title message:message , controller: controller)
            self.initAlertControllerWithTitle(title, message:message , controller: controller)
            
            let okAction = UIAlertAction (title: "OK", style: .Default, handler: nil)
            self.rbaAlert.addAction(okAction)
            self.presentController .presentViewController(self.rbaAlert, animated: true, completion: nil)
        }
    }
    

    
    
    func presentPasswordAlert(controller:UIViewController)  {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.initAlertController("Enter your E-mail.", controller: controller)
            self.rbaAlert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = "E-mail"
            })
            let okAction = UIAlertAction (title: "Submit", style: .Default, handler: {(action: UIAlertAction!) in
                
                let textField = self.rbaAlert.textFields![0]
                
                if  ((textField.text?.validateEmail()) == true)
                {
                    
                }
                else
                {
                    self.presentAlertWithMessage("Please enter valid E-mail.", controller: controller)
                }
                
                
            })
            self.rbaAlert.addAction(okAction)
            
            self.presentController.presentViewController(self.rbaAlert, animated: true, completion: nil)
        }

    }
    
    
    
    func presentAlertWithActions(actions:[()->()], buttonTitles:[String], controller:UIViewController, message:String) -> Void {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.initAlertController(message, controller: controller)
            
            for (idx,title) in buttonTitles.enumerate()
            {
                let buttonAction = UIAlertAction (title: title, style: .Default, handler: {(action: UIAlertAction!) in
                    let action = actions[idx]
                    action()
                })
                self.rbaAlert.addAction(buttonAction)
            }
            
            self.presentController.presentViewController(self.rbaAlert, animated: true, completion: nil)
        }
        
    }
    
    
    func  serverSuccessResponse(reponseDictionary: [NSObject : AnyObject]!, withKeyString keyString: String!, statusCode status: Int) {
        self.presentController.view.hideHudView()

        if status != 200
        {
            //self.showLoginControls(true)
            self.presentAlertWithMessage(reponseDictionary!["error"] as! String, controller: self.presentController)
        }
        else
        {
            self.presentAlertWithMessage("Password reset link sent to your mail.\n Please check.", controller: self.presentController)
        }
        
    }
    
    
    func serverErrorResponse(error: NSError!, withKeyString keyString: String!) {
        self.presentAlertWithMessage(error.localizedDescription, controller: self.presentController)
        
    }

    
}
