////
//  User.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 17/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    static let  sharedInstance = UserModel()
    let model = Model.sharedInstance
    var userInfo = [NSObject:AnyObject]?()
    let keychain = RBAKeyChainWrapper.sharedInstance
    var vehicleCount = 0
    var cardCount = 0
    func requestForUserRegistartion(userInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        var keys = Array(userInfo.keys)
        keys.append("profilePicture")
        var body = Array(userInfo.values)
        body.append("".dataUsingEncoding(NSUTF8StringEncoding)!)
       /* ServiceModel.connectionWithBody(userInfo, method: POSTMETHOD , service: kUserSignUp, successBlock: { (response) in
            
            //print(response)
            success(result: response)
        }) { (error) in
            
            failureBlock(error: error)
        }*/

        ServiceModel.connectionWithMultiformBody(body, withNames: keys, method: POSTMETHOD, service: kUserSignUp, dataType: "png", successBlock: { (response) in
            
            //print(response)
            success(result: response)

            }) { (error) in
                failureBlock(error: error)

        }
    }
    
    
    func requestForUserSignIn(signInInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(signInInfo, method: POSTMETHOD , service: kUserLogin, successBlock: { (response) in
            
            //print(response)
            self.userInfo = response["result"] as? [NSObject:AnyObject]
            let token = response["token"] as? [NSObject:AnyObject]
            
            self.keychain.saveTokensInKeychain(token![kUserAuthToken] as! String, refreshToken:token![kUserRefreshToken] as! String)
            success(result: response)

            }) { (error) in
                
                failureBlock(error: error)
        }
        
    }
    
    
     func requestForUserSignOut(success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
      
        var deviceTokenString = NSUserDefaults.standardUserDefaults().stringForKey("deviceTokenString")
        
        if deviceTokenString == nil {
            deviceTokenString = "1234"
        }
        
        let bodyDict = NSDictionary.init(object: deviceTokenString!, forKey: kDeviceToken)
        
        ServiceModel.connectionWithBody(bodyDict as [NSObject : AnyObject], method: POSTMETHOD , service: kUserLogout, successBlock: { (response) in
           
            //print(response)
            success(result: response)

        }) { (error) in
            
            failureBlock(error: error)
       }

    }
    
    
     func requestForUserForgotPassword(emailIfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(emailIfo, method: POSTMETHOD , service: kUserForgotPassword, successBlock: { (response) in
           
            //print(response)
            success(result: response)

        }) { (error) in
            
            failureBlock(error: error)
        }
    }
    
    
    //Validate Truck Number
    func requestForValidateTruckNumber(truckNumberInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(truckNumberInfo, method: POSTMETHOD , service: kValidateTruckNumber, successBlock: { (response) in
            
            //print(response)
           
            let defs = NSUserDefaults.standardUserDefaults()

            defs.setObject(response["result"]!![kTruckNumber] as! String, forKey: kTruckNumber)
            defs.setObject(response["result"]!![kTruckId] as! String, forKey: kTruckId)
         //   defs.setObject(response["result"]!![kTruckDriverId] as! String, forKey: kTruckDriverId)
            defs.setBool(true, forKey: "showLogin")
            defs.synchronize()
            success(result: response)
            
        }) { (error) in
            
            let defs = NSUserDefaults.standardUserDefaults()
            defs.setBool(false, forKey: "showLogin")
            defs.synchronize()

            failureBlock(error: error)
        }
    }

    
    
    
    
     func requestForEmailVerification(verificationCode:String,success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
    }
    
    
     func requestForResetPassword(passwordInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
         //print(passwordInfo)
        ServiceModel.connectionWithBody(passwordInfo, method: POSTMETHOD , service: kUserResetPassword, successBlock: { (response) in
          
            //print(response)
            success(result: response)

        }) { (error) in
            
            failureBlock(error: error)
        }

    }
    
    
    func requestForUserProfileDetails(success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(nil, method: GETMETHOD , service:"\(kGetUserInfo)\(self.userInfo![kUserId]!)", successBlock: { (response) in
            
             //   //print(response)
                self.userInfo![kUserProfilePicture] = (response["result"] as? [NSObject:AnyObject])![kUserProfilePicture]
                self.userInfo![kUserRole] = (response["result"] as? [NSObject:AnyObject])![kUserRole]
                self.userInfo![kUserEmail] = (response["result"] as? [NSObject:AnyObject])![kUserEmail]
                self.userInfo![kUserFirstName] = (response["result"] as? [NSObject:AnyObject])![kUserFirstName]
                self.userInfo![kUserLastName] = (response["result"] as? [NSObject:AnyObject])![kUserLastName]
               self.cardCount = ((response["result"] as? [NSObject:AnyObject])!["cardCount"] as? Int)!
               self.vehicleCount = ((response["result"] as? [NSObject:AnyObject])!["vehicleCount"]  as? Int)!

                success(result: response)
            
        }) { (error) in
            
                failureBlock(error: error)
        }

    }
    
    
    
    func requestForUserProfileUpdate(user:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(user, method: PUTMETHOD , service:kGetUserUpdate, successBlock: { (response) in
            
            //print(response)
            self.userInfo = response["result"] as? [NSObject:AnyObject]

            success(result: response)
            
        }) { (error) in
            
            failureBlock(error: error)
        }
   }
    
    
    func requestForTruckPollLocation(user:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(user, method: POSTMETHOD , service:kUpdateLocation, successBlock: { (response) in
            
            //print(response)
            
            success(result: response)
            
        }) { (error) in
            
            failureBlock(error: error)
        }
    }
    
    
    
    
    
    
    
}



