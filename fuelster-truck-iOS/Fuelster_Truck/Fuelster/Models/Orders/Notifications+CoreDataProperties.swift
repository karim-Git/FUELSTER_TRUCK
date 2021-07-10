//
//  Notifications+CoreDataProperties.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 27/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Notifications {

    @NSManaged var alertMessage: String?
    @NSManaged var quantity: NSNumber?
    @NSManaged var fuelType: String?
    @NSManaged var notificationTime: String?
    @NSManaged var orderId: String?
    @NSManaged var price: NSNumber?
    @NSManaged var status: String?
    @NSManaged var time: String?
    @NSManaged var title: String?

}
