//
//  Model.swift
//  DrillLogs
//
//  Created by Sandeep Kumar Rachha on 24/06/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit


class Model: NSObject {
    
    static let  sharedInstance = Model()
    let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let menuArr = [["title":MENU_HOME,"Icon":MENU_HOME_IMAGE], ["title":MENU_PROFILE,"Icon":MENU_PROFILE_IMAGE], ["title":MENU_ORDER_HISTORY,"Icon":MENU_ORDER_HISTORY_IMAGE], ["title":MENU_SETTINGS,"Icon":MENU_SETTINGS_IMAGE], ["title":MENU_SIGNOUT,"Icon":MENU_SIGNOUT_IMAGE]]
    var pickerArr = [String]?()
    
    let cancelledReasonArr = ["TCannot deliver on time","Required fuel type unavailable","Required fuel QTY unavailable","Other"]

    //MARK: login User profile array
    let loginParamsArr = [kUserEmail,kUserPassword,kUserRole, kDeviceToken, kVehicleNumber]
    let registartionParamsArr = [kUserFirstName,kUserLastName,kUserEmail,kUserPhone,kUserPassword]
    let forgotPasswordParamsArr = [kUserEmail]
    let resetPasswordParamsArr = [kUserOldPassword,kUserNewPassword]
    let profileUpdateParamsArr = [kUserFirstName,kUserLastName,kUserEmail,kUserPhone,kUserProfilePicture]

    
    //MARK: Vehicle Array Keys
    let vehicleSaveParamArr = [kVehicleTitle,kVehicleMake,kVehicleModel,kVehicleNumber,kVehicleFuel,kVehicleCard,kVehiclePicture]
   //  let vehicleSaveParamArr = [kVehicleTitle,kVehicleMake,kVehicleModel,kVehicleNumber,kVehicleFuel,kVehicleCard]
    
     let validateTruckNumberParamsArr = [kTruckNumber]

    //MARK: Card Array keys
    let cardSaveParamArr = [kCardholderName ,kCardNumber,kCardCvv,kCardHolderName,kCardExpiry,kCardZipcode]
    
    
    //MARK: Order Array keys
    let orderLocationParamArr = [kOrderLongitude,kOrderLatiitude]
    let orderCreateParamArr = [kFuelType,kOrderQuantity,kFuelPrice]
    let orderUserParamArr = [kUserId,kUserFirstName,kUserLastName]
    let orderVehicleParamArr = [kVehicleId,kVehicleCard]

    //MARK: login User Profile request Body

    func prepareLoginRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let loginRequestBody = self.prepareRequestBody(params, keys: loginParamsArr)
        
        return loginRequestBody
    }
    
    
    func prepareRegistrationRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let loginRequestBody = self.prepareRequestBody(params, keys: registartionParamsArr)
        
        return loginRequestBody
    }
    
    func prepareForgotRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let loginRequestBody = self.prepareRequestBody(params, keys: forgotPasswordParamsArr)
        
        return loginRequestBody
    }
    
    
    //Validate Truck Number
    func prepareValidateTruckNumberRequestBody(params:[AnyObject]) ->[NSObject:AnyObject]
    {
        
        let validateTruckNumberRequestBody = self.prepareRequestBody(params, keys: validateTruckNumberParamsArr)
        
        return validateTruckNumberRequestBody
    }


    func prepareresetPasswordRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let loginRequestBody = self.prepareRequestBody(params, keys: resetPasswordParamsArr)
        
        return loginRequestBody
    }
    
    func prepareProfileUpdateRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let (updatedParams, updateKeys) = self.updateParamsAndKeys(params, keys: profileUpdateParamsArr)
        let loginRequestBody = self.prepareRequestBody(updatedParams, keys: updateKeys)

        return loginRequestBody
    }

    
    func preparePollLocationeUpdateRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let (updatedParams, updateKeys) = self.updateParamsAndKeys(params, keys: orderLocationParamArr)
        let locationRequestBody = self.prepareRequestBody(updatedParams, keys: updateKeys)
        let defs = NSUserDefaults.standardUserDefaults()
        var pollLocationBody = [NSObject:AnyObject]()
        pollLocationBody["location"] = locationRequestBody
        pollLocationBody["createdBy"] = defs.objectForKey(kTruckId) as? String

        return pollLocationBody
    }

    //MARK: Vehicles request Body
    func prepareVehicleSaveRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
       
        let (updatedParams, updateKeys) = self.updateParamsAndKeys(params, keys: vehicleSaveParamArr)
        let vehicleSaveRequestBody = self.prepareRequestBody(updatedParams, keys: updateKeys)
        return vehicleSaveRequestBody
    }
    
    func updateParamsAndKeys(params:[AnyObject],keys:[AnyObject]) -> ([AnyObject],[AnyObject])
    {
        var updateParams  = [AnyObject] ()
        var updateKeys   = [AnyObject] ()
        for  (index,value) in params.enumerate()
        {
            if ((value as? String) != nil)
            {
                let valueString:String = value as! String
                if (valueString.characters.count > 0) {
                    updateParams.append(value)
                    updateKeys.append(keys[index])
                }
            }
            if ((value as? NSData) != nil)
            {
                updateParams.append(value)
                updateKeys.append(keys[index])
            }
        }
        return(updateParams,updateKeys)
    }
    
    func prepareVehicleUpdateRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
         let (updatedParams, updateKeys) = self.updateParamsAndKeys(params, keys: vehicleSaveParamArr)
        var vehicleUpdateRequestBody = self.prepareRequestBody(updatedParams, keys: updateKeys)
        //Add vehcile ID at last position
        vehicleUpdateRequestBody[""] = ""
        return vehicleUpdateRequestBody
    }
    

    func prepareVehicleDeleteRequestBody(params:[AnyObject]) -> [NSObject:AnyObject] {
     
        let vehicleDeleteRequestBody = self.prepareRequestBody(params, keys: vehicleSaveParamArr)
        return vehicleDeleteRequestBody

    }
    
    
    //MARK: Cards request Body
    func prepareCardSaveRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let cardSaveRequestBody = self.prepareRequestBody(params, keys: cardSaveParamArr)
        return cardSaveRequestBody
    }
    
    
    func prepareCardUpdateRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        var cardUpdateRequestBody = self.prepareRequestBody(params, keys: cardSaveParamArr)
        //Add Card ID at last position
        cardUpdateRequestBody[""] = ""
        return cardUpdateRequestBody
    }
    
    
    func prepareCardDeleteRequestBody(params:[AnyObject]) -> [NSObject:AnyObject] {
        
        let cardDeleteRequestBody = self.prepareRequestBody(params, keys: cardSaveParamArr)
        return cardDeleteRequestBody
        
    }
    
    
    //MARK: Orders request Body

    func prepareCreateOrderRequestBody(params:[AnyObject],location:[AnyObject],user:[AnyObject],vehicle:[AnyObject]) ->[NSObject:AnyObject] {
        
        var cardSaveRequestBody = self.prepareRequestBody(params, keys: vehicleSaveParamArr)
        cardSaveRequestBody[kOrderLocation] = self.prepareRequestBody(location, keys: orderLocationParamArr)
        cardSaveRequestBody[kOrderUser] = self.prepareRequestBody(user, keys: orderUserParamArr)
        cardSaveRequestBody[kOrderVehicle] = self.prepareRequestBody(vehicle, keys: orderVehicleParamArr)


        return cardSaveRequestBody
    }
    
    
    func prepareEstimatedDeliveryTimeRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let cardUpdateRequestBody = self.prepareRequestBody(params, keys: vehicleSaveParamArr)
        return cardUpdateRequestBody
    }


    func prepareRequestBody(params:[AnyObject],keys:[AnyObject]) -> [NSObject:AnyObject] {
        var requestBody = [String:AnyObject]()
        
        for (idx,key) in keys.enumerate()
        {
            requestBody[key as! String] = params[idx]
        }
        return requestBody
    }
   
    
}
