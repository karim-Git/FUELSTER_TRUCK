//
//  Fuelster_OrderDetailView.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 02/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_OrderDetailView: UIView {

    @IBOutlet weak var orderLocationImg: UIImageView!
    
    @IBOutlet weak var orderVehicleModelLbl: UILabel!
    @IBOutlet weak var orderVehicleLbl: UILabel!
    
    @IBOutlet weak var orderLocationLbl: UILabel!
    @IBOutlet weak var orderDeliveryTimeLbl: UILabel!
    var parentVC = Fuelster_OrderDetailVC()

    @IBOutlet weak var vehicleImg: UIImageView!
    
    private var gradient : CAGradientLayer = CAGradientLayer()

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        self.gradient = self.applyScecondaryBackGroundGradient()
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action:  #selector(self.tapGestureAction(_:)))
        self.orderLocationImg.addGestureRecognizer(tapGesture)
       
    }
 
    @IBAction func mapButtonAction(sender: AnyObject) {
        let mapVC = self.parentVC.getViewControllerWithIdentifier("OrderMapVC")
        self.parentVC.presentViewController(mapVC, animated: true, completion: nil)
    }
    
    func tapGestureAction(sender:UITapGestureRecognizer) -> Void {
        
    }
    
    func setupOrderDetails(order:Order) -> Void {
        self.orderLocationImg.sd_setImageWithURL(NSURL.init(string:order.mapthumbnail!), placeholderImage: nil)
        let vehicleTitle = order.vehicle![kVehicleTitle] as? String
        self.orderVehicleLbl.text = "Vehicle:\(vehicleTitle!)"
        let make = order.vehicle![kVehicleMake]!as? String
        let model = order.vehicle![kVehicleModel]as? String
        
        self.orderVehicleModelLbl.text = "Make and Model:\(make!) \(model!)"
        
        if order.vehicle![kVehiclePicture] != nil {
            self.vehicleImg.sd_setImageWithURL(NSURL.init(string:order.vehicle![kVehiclePicture]! as! String), placeholderImage: UIImage.init(named: "CarImage"))
        }
        
     //   self.orderLocationLbl.text.getgetLocationAddressWithLatitudeAndLongitude kLocationLongitude
        String.getLocationAddressWithLatitudeAndLongitude(order.location![kLocationLattitude]! as! Double, longitude: order.location![kLocationLongitude]! as! Double, success: {
            (result) in
                //print(result)
                dispatch_async(dispatch_get_main_queue())
                {
                    let addressDictionary = result as? [NSObject:AnyObject]
                    self.orderLocationLbl.text = (addressDictionary!["Name"] as? String)! + ", " + (addressDictionary!["City"] as? String)! + ", " + (addressDictionary!["CountryCode"] as? String)!
                }
            }, failureBlock: { (error) in
                dispatch_async(dispatch_get_main_queue())
                {
                    self.orderLocationLbl.text = "Location Not found"
                }
        })
        
       // self.orderDeliveryTimeLbl.text = "ETD:\(order.estimatedTime!)"
        
        let startTime = order.estimatedTimeStart!.getStringFromParseTime()
        let startAM = order.estimatedTimeStart!.getStringFromParseAMPM()
        let endTime = order.estimatedTimeEnd!.getStringFromParseTime()
        let endAM = order.estimatedTimeEnd!.getStringFromParseAMPM()
        
        let estimatedStart = startTime! + " " + startAM!
        let estimatedEnd = endTime! + " " + endAM!
        
        let timeString: NSString = "ETD:" + estimatedStart + " - " + estimatedEnd
        self.orderDeliveryTimeLbl.attributedText = timeString.getBoldAttributeString()

        //self.orderCardImg.
    }
}
