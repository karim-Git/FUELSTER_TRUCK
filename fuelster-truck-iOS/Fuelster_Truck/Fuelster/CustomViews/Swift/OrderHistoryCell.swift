//
//  OrderHistoryCell.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 23/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import QuartzCore

class OrderHistoryCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var orderStatusLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var vehicleLbl: UILabel!
    @IBOutlet weak var vehicleModelLbl: UILabel!
    @IBOutlet weak var fuelTypeLbl: UILabel!
    @IBOutlet weak var estimatedPriceLbl: UILabel!
    @IBOutlet weak var vehicleImgView: UIImageView!
    @IBOutlet weak var orderStatusImgView: UIImageView!
    @IBOutlet weak var repeatOrderbtn: UIButton!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var orderPriceLbl: UILabel!
    weak var delegate:CustomeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
        
        
        
     //   self.contentView.applyScecondaryBackGroundGradient()
    //    self.contentView .sendSubviewToBack(bgView)
        
        self.vehicleImgView.layer.cornerRadius = self.vehicleImgView.frame.size.width/2
        self.vehicleImgView.layer.masksToBounds = false
        self.vehicleImgView.clipsToBounds = true
        self.vehicleImgView.layer.borderWidth = 1.0

        viewDetailsBtn.applyPlainStyle()
    }
    
    
    func configureCell(order:Order, _delegate:Fuelster_OrderHistoryVC) -> Void {
        
        delegate = _delegate
        let GrdientView = UILabel(frame: CGRect(x: 0 , y:0 , width: self.frame.size.width+20 , height: 206))
        //self.contentView.addSubview(GrdientView)
        GrdientView.backgroundColor = UIColor.gradientFromColor(UIColor.whiteColor(), toColor:  UIColor.textFieldPrimaryBackgroundColor() , withHeight: 206)
       // GrdientView.applyPrimaryShadow()
        
       // self.contentView.sendSubviewToBack(GrdientView)

        let placeHolderImg = UIImage.init(named: "Car_Orange")
        if order.vehicle![kVehiclePicture] == nil{
            vehicleImgView.image = placeHolderImg
        }
        else {
            self.vehicleImgView.sd_setImageWithURL(NSURL.init(string:order.vehicle![kVehiclePicture]! as! String), placeholderImage: placeHolderImg)
        }
        
        let orderNumber = order.orderNumber!
        self.orderNumberLbl.text = "Order ID:\(orderNumber)"
        //self.orderDateLbl.text = order.estimatedTime
        self.orderStatusLbl.text = order.status
        self.orderStatusLbl.adjustsFontSizeToFitWidth = true
        self.orderStatusImgView.hidden = true
        
        let vehicleTitle = order.vehicle![kVehicleTitle] as? String
        self.vehicleLbl.text = "Vehicle: \(vehicleTitle!)"
        if order.vehicle![kVehicleMake] != nil  && order.vehicle![kVehicleModel] != nil{
            self.vehicleModelLbl.text = "\(order.vehicle![kVehicleMake]!) \(order.vehicle![kVehicleModel]!)"
        }
        
        if order.fuelType != nil  && order.quantity != nil{
            if order.fuelType == "87" {
                self.fuelTypeLbl.text = "\(order.fuelType!) Regular - \(order.quantity!) gal"
            }
            else {
                self.fuelTypeLbl.text = "\(order.fuelType!) Premium - \(order.quantity!) gal"
            }
        }
        
       /* if order.price != nil  {
            self.orderPriceLbl.text = "Estimated Price:\(order.chargedPrice!)"
        }*/
        
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func vewDetailsButtonAction(sender: AnyObject) {
        
        self.delegate?.cellPushButtonAction!(self)
    }
    
    
    @IBAction func repeatOrderButtonAction(sender: AnyObject) {
        
        
    }
}
