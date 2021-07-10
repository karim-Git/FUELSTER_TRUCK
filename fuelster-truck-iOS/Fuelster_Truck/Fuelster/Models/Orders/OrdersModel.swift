//
//  OrdersModel.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 23/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import CoreData

class OrdersModel: NSObject {

    static let  sharedInstance = OrdersModel()
    var allOrders:[Order]? = []
    var order = Order?()
    let model = Model.sharedInstance
    var isNextPage = false
    var notificationsArr : [Notifications]? = []
    
    
    func fetchNotifications() -> Void {
        let fetchRequest = NSFetchRequest(entityName: "Notifications")
        self.notificationsArr?.removeAll()

        do {
            let appdelegate = UIApplication.sharedApplication().delegate as? AppDelegate
            let results = try appdelegate!.managedObjectContext.executeFetchRequest(fetchRequest)
             self.notificationsArr? = (results as? [Notifications])!
        } catch {
            let fetchError = error as NSError
            //print(fetchError)
        }


    }
    //MARK:API Request methods
    func requestForUserOrderList(pageCount:Int,status:String, success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void ) -> Void {
        
        ServiceModel.connectionWithBody(nil, method: GETMETHOD, service: "\(kGetOrders)/?status=\(status)", successBlock: { (response) in
            //print(response)
            self.isNextPage = (response["isNextPage"] as? Bool)!
          // if pageCount == 1
            self.allOrders?.removeAll()

            let totalOrders = response["result"] as! [AnyObject]
            for orderDict in totalOrders
            {
                var order = Order()
                order = order.initWithOrderInfo(orderDict as! [NSObject:AnyObject])
                self.allOrders?.append(order)
            }
            self.allOrders!.sortInPlace({ $0.updatedAt!.compare($1.updatedAt!) == .OrderedDescending })
            success(result: response)
            
        }) { (error) in
            
            failureBlock(error:error)
        }
    }
    
    
    func requestForOrderDetails(orderId:String,success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(nil, method: GETMETHOD, service: "\(kOrderSave)/\(orderId)", successBlock: { (response) in
            print(response)
            
            success(result: response)
        }) { (error) in
            
            failureBlock(error:error)
        }
        
    }
    
    func requestForUserOrderList(pageCount:Int, success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void ) -> Void {
        
        ServiceModel.connectionWithBody(nil, method: GETMETHOD, service: "\(kGetOrders)?status=Completed,Canceled", successBlock: { (response) in
            //print(response)
            if pageCount == 1
            {
                self.allOrders?.removeAll()
            }
            self.isNextPage = response["isNextPage"] as! Bool
            let totalOrders = response["result"] as! [AnyObject]
            for orderDict in totalOrders
            {
                var order = Order()
                order = order.initWithOrderInfo(orderDict as! [NSObject:AnyObject])
                self.allOrders?.append(order)
            }
            success(result: response)
            
        }) { (error) in
            
            failureBlock(error:error)
        }
    }

    
    func requestForNewOrderForUser(orderInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void  {
        
        ServiceModel.connectionWithBody(orderInfo, method: POSTMETHOD, service: kOrderSave, successBlock: { (response) in
           
            success(result: response)
            //print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }

    }
    
    
    func requestForUpdateOrder(orderInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(orderInfo, method: PUTMETHOD, service:"\(kOrderSave)/\(orderInfo[kFuelId]!)", successBlock: { (response) in
           
            success(result: response)
            //print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }

    }
    
    
    func requestForDeleteOrder(orderInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(nil, method: DELETEMETHOD, service: "\(kGetOrderInfo)/\(orderInfo[kOrderId])", successBlock: { (response) in
            
            success(result: response)
            //print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }

    }
    
    
    func requestForOrderEstimatedTime(locationInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void  {
        
        ServiceModel.connectionWithBody(locationInfo, method: POSTMETHOD, service: "\(kGetOrders)/\(kGetOrderEstimatedTime)", successBlock: { (response) in
           
            success(result: response)
            //print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }

    }
    

    func resetNotifications() -> Void {
        
            let appdelegate = UIApplication.sharedApplication().delegate as? AppDelegate

            let entites = appdelegate!.managedObjectModel.entities
            
            for entity in entites
            {
                
                let fetchRequest = NSFetchRequest()
                fetchRequest.entity = NSEntityDescription.entityForName(entity.name!, inManagedObjectContext: appdelegate!.managedObjectContext)
                if Float(UIDevice.currentDevice().systemVersion)  >= 9.0
                {
                    if #available(iOS 9.0, *) {
                        let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                        do {
                            try appdelegate!.persistentStoreCoordinator.executeRequest(delete, withContext:appdelegate!.managedObjectContext)
                        } catch let error as NSError {
                            //print("Error occured while deleting: \(error)")
                        }
                    
                    } else {
                        
                        fetchRequest.includesPropertyValues = false
                        do {
                            if let results = try appdelegate!.managedObjectContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                                for (_,result) in results.enumerate() {
                                    appdelegate!.managedObjectContext.deleteObject(result)
                                    notificationsArr?.removeFirst()
                                }
                                
                                try appdelegate!.managedObjectContext.save()
                                
                            }
                        } catch let error as NSError {
                            // LOG.debug("failed to clear core data")
                            //print("error deletig coredata enity \(entity.name) with error \(error.localizedDescription)")
                            
                        }
                    }
            }
        }
    }
}
