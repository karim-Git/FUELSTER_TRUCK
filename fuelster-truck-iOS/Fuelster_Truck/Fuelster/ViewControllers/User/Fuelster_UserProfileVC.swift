//
//  Fuelster_UserProfileVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 19/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import SDWebImage

class Fuelster_UserProfileVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    //MARK: UI Outlets
    
    //User info
     @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneTF: REFormattedNumberField!
    @IBOutlet weak var emailTF: RBATextField!
    
    //Address info
     @IBOutlet weak var addressContainerView: UIView!
     @IBOutlet weak var addressLine1Label: UILabel!
     @IBOutlet weak var addressLine2Label: UILabel!
     @IBOutlet weak var addressLine3Label: UILabel!
     @IBOutlet weak var addressLine4Label: UILabel!
     @IBOutlet weak var addressSeperaterLabel: UILabel!
    
    //Emergency contact info
     @IBOutlet weak var emergencyContactLabel: UILabel!
     @IBOutlet weak var callContactPerson: UILabel!
    
     //MARK: Glbal Variables
    let userModel =  UserModel.sharedInstance
    let alertVC = RBAAlertController()
    
    
    
    
    @IBOutlet weak var emergencyContactBtn: UIButton!
    //MARK: === View starts ===
    override func viewDidLoad()
    {
        super.viewDidLoad()
        

        self.phoneTF.format = "(XXX) XXX-XXXX"
        self.emailTF.adjustsFontSizeToFitWidth = true
        self.emailTF.addLeftView("Email_small")
        self.phoneTF.addLeftView("call_small")
        //self.profileContainerView.applyScecondaryBackGroundGradient()
        self.profileContainerView.applyPrimaryShadow()
        
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width/2
        profilePicImageView.layer.masksToBounds = true
        
        let sliderVC = self.slideMenuController()
        sliderVC!.navigationItem.rightBarButtonItems = []

        sliderVC!.navigationItem.titleView = nil
        //To fix the Nav title alignment issue on iPhone 6 & 6s
        let selftitle = "Profile"
        let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
        titleLabel.text = selftitle
        titleLabel.font = UIFont.appRegularFontWithSize18()
        self.navigationItem.titleView = titleLabel
    }

   
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
      //  self.profileContainerView.applyScecondaryBackGroundGradient()
        self.profilePicImageView.image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(kUserProfilePicture)
        
       // self.profilePicButton .image(SDImageCache.sharedImageCache().imageFromDiskCacheForKey(kUserProfilePicture), forState: .Normal)
            //

        self.view.initHudView(.Indeterminate, message:kHudLoadingMessage)

            userModel.requestForUserProfileDetails(
                { (result) in
                    dispatch_async(dispatch_get_main_queue())
                    {
                        //print("UserProfileDetails === === === \(result)")
                        self.view.hideHudView()
                        
                        self.updateUI()
                    }
                }) { (error) in
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.view.hideHudView()
                        //Handle Error
                    }

            }
    }
    
    
    
    @IBAction func emergencyNumberBtn(sender: AnyObject) {
        self.view.callContactPerson((userModel.userInfo![kuserEmergencyNumber]! as? String)!)
    }

    //Update ui with data from server
    func updateUI() -> Void
    {
        self.profilePicImageView.sd_setImageWithURL(NSURL.init(string: userModel.userInfo![kUserProfilePicture] as! String), placeholderImage:  UIImage.init(named: "Profilepic") )
        self.userNameLabel.text = "\(userModel.userInfo![kUserFirstName]!) \(userModel.userInfo![kUserLastName]!)"
        self.emailTF.text = userModel.userInfo![kUserEmail] as? String
        self.phoneTF.text = userModel.userInfo![kUserPhone] as? String
        
        if userModel.userInfo![kUserAddress] != nil {
            let driverAddress = userModel.userInfo![kUserAddress] as? [NSObject:AnyObject]
            self.addressContainerView.hidden = false
            addressLine1Label.text = driverAddress![kuserLine1] as? String
            addressLine2Label.text = driverAddress![kuserLine2] as? String
            addressLine3Label.text = driverAddress![kuserCity] as? String
            addressLine4Label.text = driverAddress![kuserState] as? String
        }
        else {
            self.addressContainerView.hidden = true
        }
        
        if userModel.userInfo![kuserEmergencyNumber] != nil {
            self.emergencyContactBtn.hidden = false
            self.emergencyContactLabel.hidden = false
            self.emergencyContactBtn.setTitle(userModel.userInfo![kuserEmergencyNumber]! as? String, forState:.Normal)
        }
        else {
            self.emergencyContactBtn.hidden = true
            self.emergencyContactLabel.hidden = true
        }

    }

    
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    
    
}
