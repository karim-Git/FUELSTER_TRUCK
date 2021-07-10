//
//  Order.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 23/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Order: NSObject {
    
    var fuelType :String?
    var quantity :NSNumber?
    var filledQuantity :NSNumber?
    var price :Double?
    var pricePerGallon :Double?

    var status :String?
    var orderNumber : String?
    var cancelReason :String?
    var estimatedTime :String?
    var estimatedTimeStart :String?
    var estimatedTimeEnd :String?

    var deliveryTime :String?
    var createAt :String?
    var rating :NSNumber?
    var updatedAt :String?
    var flaggedBy :String?
    var orderId :String?
    var actualPrice : Double?
    var chargedPrice : Double?
    var location:[NSObject:AnyObject]?
    var user :[NSObject:AnyObject]?
    var mapthumbnail :String?
    var vehicle:[NSObject:AnyObject]?
    var truck :[NSObject:AnyObject]?
    var statusHistory : [[NSObject:AnyObject]]?
    func initWithOrderInfo(orderInfo:[NSObject:AnyObject]) -> Order {
        
        
        if self.orderId == nil {
            self.orderId = orderInfo["_id"] as? String
        }
        
        self.updateOrderWithInfo(orderInfo)
        return self
    }
    
    
    func updateOrderWithInfo(orderInfo:[NSObject:AnyObject]) -> Void {
        
        self.fuelType = orderInfo["fuelType"] as? String
        self.orderNumber = orderInfo["orderNumber"] as? String
        self.quantity = orderInfo["quantity"] as? NSNumber
        self.filledQuantity = orderInfo["filledQuantity"] as? NSNumber
        self.price = orderInfo["price"] as? Double
        self.pricePerGallon = orderInfo["pricePerGallon"] as? Double

        if orderInfo["actualPrice"] != nil {
            self.actualPrice = orderInfo["actualPrice"] as? Double
        }
        
        if orderInfo["chargedPrice"] != nil {
            self.chargedPrice = orderInfo["chargedPrice"] as? Double
        }

        self.status = orderInfo["status"] as? String
        self.cancelReason = orderInfo["cancelReason"] as? String
        self.estimatedTime = orderInfo["estimatedTime"] as? String
        self.estimatedTimeStart = orderInfo["estimatedTimeStart"] as? String
        self.estimatedTimeEnd = orderInfo["estimatedTimeEnd"] as? String

        self.deliveryTime = orderInfo["deliveryTime"] as? String
        self.createAt = orderInfo["createAt"] as? String
        self.updatedAt = orderInfo["updatedAt"] as? String
        self.rating = orderInfo["rating"] as? NSNumber
        self.flaggedBy = orderInfo["flaggedBy"] as? String
        self.mapthumbnail = orderInfo["mapThumbnail"] as? String
        self.location = orderInfo["location"] as? [NSObject:AnyObject]
        self.user = orderInfo["user"] as? [NSObject:AnyObject]
        self.vehicle = orderInfo["vehicle"] as? [NSObject:AnyObject]
        self.truck = orderInfo["truck"] as? [NSObject:AnyObject]
        self.statusHistory = orderInfo["history"] as? [[NSObject:AnyObject]]
        
    }
    
    
    func orderStatusHistiry(status:String) -> [NSObject:AnyObject]? {
        
        let predicate = NSPredicate(format:"status = %@",status)
        let filterArr = self.statusHistory?.filter({ predicate.evaluateWithObject($0)})
        if ((filterArr?.count) != nil) {
            return filterArr![0]
        }
        
        return nil
    }
    
}
