//
//  Fuelster_MenuVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 19/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import SDWebImage
import QuartzCore

class Fuelster_MenuVC: Fuelster_BaseViewController,UIGestureRecognizerDelegate
{
    
    
    var sliderVC : UIViewController!
    var selectedRow = 0
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
   
     var tapGesture: UITapGestureRecognizer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor .clearColor()
        
        //Customise Background View behind table view and profile pic
        self.menuBackgroundView.backgroundColor = UIColor .whiteColor()
        self.menuBackgroundView.layer.cornerRadius = 10
        self.menuBackgroundView.layer.borderColor = UIColor.clearColor().CGColor
        
        //Customise profile pic
        self.profilePicImageView.layer.cornerRadius = 50
        self.profilePicImageView.layer.borderColor = UIColor.clearColor().CGColor
        self.profilePicImageView.layer.masksToBounds = true
        //self.profilePicImageView.image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(kUserProfilePicture)
        
        self.profilePicImageView.sd_setImageWithURL(NSURL.init(string: userModel.userInfo![kUserProfilePicture] as! String), placeholderImage:  UIImage.init(named: "Profilepic") )
       // SDImageCache.sharedImageCache().storeImage(self.profilePicImageView.image, forKey:kUserProfilePicture)
       

        self.userNameLbl.adjustsFontSizeToFitWidth = true;
 
        self.menuTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.menuTableView.separatorColor = UIColor.clearColor()
        self.addTapGestuter()
        
        
    }
    
    
    func addTapGestuter()  {
        
        if tapGesture == nil {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
            tapGesture?.delegate = self
            self.view.addGestureRecognizer(tapGesture!)
        }
        
    }
    
    func viewTapped()  {
        closeLeft()
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool
    {
        if (touch.view != self.view) { // accept only touchs on superview, not accept touchs on subviews
            return false;
        }
        return true
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.userNameLbl.text = userModel.userInfo![kUserFirstName] as? String
      //  self.profilePicImageView.image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(kUserProfilePicture)
            self.profilePicImageView.sd_setImageWithURL(NSURL.init(string: userModel.userInfo![kUserProfilePicture] as! String), placeholderImage:  UIImage.init(named: "Profilepic") )
      self.menuTableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return model.menuArr.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell = self.menuTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        // Configure the cell...
        cell.imageView?.image = UIImage.init(named: model.menuArr[indexPath.row]["Icon"]!)
        cell.textLabel?.text = model.menuArr[indexPath.row]["title"]
     

        cell.selectionStyle = .None

        cell.textLabel?.font = UIFont.appRegularFontWithSize14()
        cell.textLabel?.textColor = UIColor.appFontColor()
        
        cell.selectionStyle = .None
        
        if indexPath.row == selectedRow
        {
            cell.textLabel?.textColor = UIColor.appTheamColor()
        }
        
        if(indexPath.row ==  model.menuArr.count-1)
        {
            cell.textLabel?.textColor = UIColor.grayColor();
        }
        
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        selectedRow = indexPath.row
        self.sliderVC = self.slideMenuController()
        
        if indexPath.row == model.menuArr.count-1
        {
                let actionsArr:[()->()] = [
                    {
                        //OK button
                    _ in
                    self.userModel.requestForUserSignOut({ (response) in
                        dispatch_async(dispatch_get_main_queue()) {
                            let locationManager = O1LocationManager.sharedInstance()
                            locationManager.stop()

                            self.keychain.wipeKeychainData()
                            self.sliderVC.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                            return;
                        }
                        
                        }, failureBlock: { (error) in
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                self.loginAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self.sliderVC)
                            }
                    })
                    
                    },
                    {
                        //Cancel button
                    }
            ]
                
                self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: ["Sign Out","Cancel"], controller: self.sliderVC, message: "Do you want to Sign Out?")
        }
        
        if indexPath.row == 0
        {
            self.orderModel.allOrders?.removeAll()

            slideMenuController()!.changeMainViewController(self.getViewControllerWithIdentifier(MAINVC),close: true)
            return
        }
        
        self.sliderVC.title = model.menuArr[indexPath.row]["title"]
        
        if  (indexPath.row == 1)
        {
            slideMenuController()!.changeMainViewController(self.getViewControllerWithIdentifier(PROFILEVC),close: true)
            return
        }
        
        if  (indexPath.row == 2)
        {
            self.orderModel.allOrders?.removeAll()
            slideMenuController()!.changeMainViewController(self.getViewControllerWithIdentifier(ORDER_HISTORY_VC),close: true)
            return
        }
        
        
        if  (indexPath.row == 3)
        {
            slideMenuController()!.changeMainViewController(self.getViewControllerWithIdentifier(SETTINGSVC),close: true)
            return
        }
        
    }
    
    
     func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
     {
        var rowHeight = UITableViewAutomaticDimension
        if(self.view.frame.size.height < 500)
        {
            rowHeight = 35
        }
        /*
        if(indexPath.row == 5)
        {
           return rowHeight+75;
        }
        else
        {
            return rowHeight;
        }
 */
        return rowHeight;

    }
    
}
