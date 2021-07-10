//
//  Fuelster_NotificationView.swift
//  Fuelster
//
//  Created by Kareem on 16/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_NotificationView: UIView {

    static let  sharedInstance = Fuelster_NotificationView.instanceFromNib()
    @IBOutlet weak var messageLbl: UILabel!
     @IBOutlet weak var closeButton: UIButton!
     @IBOutlet weak var clickHereBtn: UIButton!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        }
  
    class func instanceFromNib() -> UIView {
        
        return UINib(nibName: "Fuelster_Notify", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    
    @IBAction func clickHereTapped(sender: UIButton) {
        
        //print("clickHereTapped")
         self.hidden = true
        Model.sharedInstance.appdelegate.pushNotificationVC()
    }
    
    @IBAction func closeTapped(sender: UIButton) {
        
        //print("closeTapped")
        self.hidden = true
    }
}
