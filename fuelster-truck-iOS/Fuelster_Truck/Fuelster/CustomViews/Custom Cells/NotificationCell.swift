//
//  NotificationCell.swift
//  Fuelster
//
//  Created by Kareem on 16/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

     @IBOutlet weak var messageLabel: UILabel!
         @IBOutlet weak var timeLabel: UILabel!
         @IBOutlet weak var fuelTypeLbl: UILabel!
      @IBOutlet weak var fuelQtyLbl: UILabel!
      @IBOutlet weak var detailsBtn: UIButton!
    var dividerLbl: UILabel!
    weak var delegate:CustomeCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // detailsBtn.applyPrimaryTheme()
        detailsBtn.layer.cornerRadius = 18.0
        detailsBtn.layer.borderWidth = 1.0
        //dividerLbl = UILabel.init(frame: CGRectMake(0, self.frame.size.height - 1 , self.frame.size.width, 1))
      //  dividerLbl.backgroundColor = UIColor.appUltraLightFontColor()
    //    self.contentView.addSubview(dividerLbl)
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func vewDetailsButtonAction(sender: AnyObject) {
        
        self.delegate?.cellPushButtonAction!(self)
    }
    
}
