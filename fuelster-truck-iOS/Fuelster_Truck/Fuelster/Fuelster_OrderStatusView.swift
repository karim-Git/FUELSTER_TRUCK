//
//  Fuelster_OrderStatusView.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 06/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_OrderStatusView: UIView {

    
    @IBOutlet weak var orderEstimatedPriceLbl: UILabel!
    @IBOutlet weak var fuelTypeLbl: UILabel!
    @IBOutlet weak var orderQunatityLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!

    @IBOutlet weak var customerImg: UIImageView!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        self.fuelTypeLbl.adjustsFontSizeToFitWidth = true
        self.applyHorizantalPrimaryBackGroundGradient()
        self.customerImg.layer.cornerRadius = self.customerImg.frame.size.width/2
        self.customerImg.layer.masksToBounds = true
    }
    
    func setupOrderStatus(order:Order) -> Void {
        
        self.customerImg.layer.cornerRadius = self.customerImg.frame.size.width/2
        self.customerImg.layer.masksToBounds = true
        
        let qtyString: NSString =   NSString.localizedStringWithFormat("%@ gal",order.quantity!)
        self.orderQunatityLbl.attributedText =  qtyString.getBoldAttributeString()

        if order.fuelType == "87" {
            self.fuelTypeLbl.text = "\(order.fuelType!) Regular"
        }
        else {
            self.fuelTypeLbl.text = "\(order.fuelType!) Premium"
        }

        
        self.customerNameLbl.text = order.user![kUserFirstName] as? String
       
        if  order.user![kUserProfilePicture] != nil{
            self.customerImg.sd_setImageWithURL(NSURL.init(string: order.user![kUserProfilePicture]! as! String), placeholderImage: UIImage.init(named: "Profilepic"))
        }
        
        if order.price != nil  {
            let priceString: NSString =   NSString.localizedStringWithFormat("$ %.2f",order.price!)
            //print(priceString)
            self.orderEstimatedPriceLbl.text = "\(priceString)"
        }
    }


}
