//
//  OrderHistoryCell.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 23/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import QuartzCore

class HomeNewOrdersCell: UITableViewCell
{

    @IBOutlet var VehicleImgTopConstraint: NSLayoutConstraint!
    @IBOutlet var VehicleLblTopConstraint: NSLayoutConstraint!
    //UI Outlets
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var fuelTypeLbl: UILabel!
    @IBOutlet weak var fuelQuantityLbl: UILabel!
    @IBOutlet weak var vehicleNumberLbl: UILabel!
    @IBOutlet weak var vehicleModelLbl: UILabel!

    @IBOutlet weak var addressBgView: UIView!
    @IBOutlet weak var locationIconImgView: UIImageView!

    @IBOutlet weak var addressLine1Lbl: UILabel!
    @IBOutlet weak var addressLine2Lbl: UILabel!
    @IBOutlet weak var estimatedTimelLbl: UILabel!
    
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var completeOrderButton: UIButton!
    
    weak var delegate:CustomeCellDelegate?
    var gradientLayer: CAGradientLayer!
    //MARK: Initialization code for cell design
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        
    
        
        self.profileImgView.layer.masksToBounds = true
        self.profileImgView.layer.cornerRadius = profileImgView.frame.size.width/2
        
        self.acceptBtn.layer.masksToBounds = true
        self.acceptBtn.layer.cornerRadius = 20
        self.acceptBtn.applyPrimaryShadow()
        self.acceptBtn.layer.cornerRadius = 50
        
        self.cancelBtn.layer.masksToBounds = true
        self.cancelBtn.backgroundColor = UIColor.whiteColor()
        self.cancelBtn.layer.borderColor = UIColor (white: 0.5, alpha: 1).CGColor
        self.cancelBtn.layer.borderWidth = 0.5;
        self.cancelBtn.applyPrimaryShadow()
        self.cancelBtn.layer.cornerRadius = 20

        self.addressBgView.layer.masksToBounds = true
        self.addressBgView.backgroundColor = UIColor.whiteColor()
        self.addressBgView.layer.borderColor = UIColor (white: 0.9, alpha: 1).CGColor
        self.addressBgView.layer.borderWidth = 0.5;
        self.addressBgView.applyPrimaryShadow()
        self.addressBgView.layer.cornerRadius = 5
        
      //  self.contentView.applyScecondaryBackGroundGradient()
    //    self.contentView.backgroundColor = UIColor.gradientFromColor(UIColor.whiteColor(), toColor:  UIColor.init(red: 226.0/255.0, green: 229.0/255.0, blue: 236.0/255.0, alpha: 1.0)  , withHeight: 260)
        
           //  self.applyPrimaryShadow()
        
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true

      // gradientLayer =   self.contentView.applyScecondaryBackGroundGradient()
        
    
        //self.contentView.resetPrimaryShadow()

}
    
    
    //MARK: Configure Cell
    func configureCell(order:Order, _delegate:Fuelster_BaseViewController) -> Void
    {
        delegate = _delegate
        
        let GrdientView = UILabel(frame: CGRect(x: 0 , y:0 , width: self.frame.size.width+20 , height: 260))
       // self.contentView.addSubview(GrdientView)
        GrdientView.backgroundColor = UIColor.gradientFromColor(UIColor.whiteColor(), toColor:  UIColor.textFieldPrimaryBackgroundColor() , withHeight: 260)
      //  GrdientView.applyPrimaryShadow()
      //  self.contentView.sendSubviewToBack(GrdientView)
      

        if(order.status == OrderStatusNew)
        {
            VehicleLblTopConstraint.constant = 10
             VehicleImgTopConstraint.constant = 10
            self.fuelQuantityLbl.hidden = false
            self.acceptBtn.hidden = false
            self.cancelBtn.hidden = false

        }
        else
        {
            VehicleLblTopConstraint.constant = 30
             VehicleImgTopConstraint .constant = 30
            self.fuelQuantityLbl.hidden = true
            self.acceptBtn.hidden = true
            self.cancelBtn.hidden = true
        }
        
        let placeHolderImg = UIImage.init(named: "Car_Orange")
        if order.vehicle![kVehiclePicture] == nil{
            profileImgView.image = placeHolderImg
        }
        else {
            self.profileImgView.sd_setImageWithURL(NSURL.init(string:order.vehicle![kVehiclePicture]! as! String), placeholderImage: placeHolderImg)
        }
        
        self.profileNameLbl.text = order.user![kUserFirstName]! as! String
        
        
        if order.fuelType == "87" {
            self.fuelTypeLbl.text = "\(order.fuelType!) Regular"
        }
        else {
            self.fuelTypeLbl.text = "\(order.fuelType!) Premium"
        }
        let orderNumber = order.orderNumber!
        self.orderIdLbl.text = "Order Id: \(orderNumber)"
        self.fuelQuantityLbl.text = "\(order.quantity!) gal"
        let vehicleNumber = (order.vehicle![kVehicleNumber]as? String)
        self.vehicleNumberLbl.text = "Vehicle No:\(vehicleNumber!)"
        
        let make = order.vehicle![kVehicleMake]!as? String
        let model = order.vehicle![kVehicleModel]as? String
        
        self.vehicleModelLbl.text = "\(make!) \(model!)"
        
       // self.addressLine1Lbl.text =
        //self.addressLine2Lbl
        
        let startTime = order.estimatedTimeStart!.getStringFromParseTime()
        let startAM = order.estimatedTimeStart!.getStringFromParseAMPM()
        let endTime = order.estimatedTimeEnd!.getStringFromParseTime()
        let endAM = order.estimatedTimeEnd!.getStringFromParseAMPM()
        
        let estimatedStart = startTime! + " " + startAM!
        let estimatedEnd = endTime! + " " + endAM!
        
        let timeString: NSString = estimatedStart + " - " + estimatedEnd
        self.estimatedTimelLbl.attributedText = timeString.getBoldAttributeString()

        //self.estimatedTimelLbl.text = order.estimatedTime!
        
        String.getLocationAddressWithLatitudeAndLongitude(order.location![kLocationLattitude]! as! Double, longitude: order.location![kLocationLongitude]! as! Double, success: {
            (result) in
            //print(result)
            dispatch_async(dispatch_get_main_queue())
            {
                let addressDictionary = result as? [NSObject:AnyObject]
                self.addressLine1Lbl.text = (addressDictionary!["Name"] as? String)! + ", "
                self.addressLine2Lbl.text = (addressDictionary!["City"] as? String)! + ", " + (addressDictionary!["CountryCode"] as? String)!
            }
            }, failureBlock: { (error) in
                dispatch_async(dispatch_get_main_queue())
                {
                    self.addressLine1Lbl.text = "Location Not found"
                }
        })

    }
    
    
    
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

 
    
    
    //MARK : Accept / Camcel Buttion Actions
    
    @IBAction func HomeNewOrderCellAcceptOrder(sender: UIButton)
    {
        self.delegate?.HomeNewOrderCellAcceptOrder!(self)
    }
    
    
    @IBAction func HomeNewOrderCellCancelOrder(sender: UIButton)
    {
        self.delegate?.HomeNewOrderCellCancelOrder!(self)
    }
    
    
    
    @IBAction func HomeAcceptedOrdrsCellCompleteOrder(sender: UIButton)
    {
        self.delegate?.HomeAcceptedOrdrsCellCompleteOrder!(self)
    }
    
    
    

    

}
