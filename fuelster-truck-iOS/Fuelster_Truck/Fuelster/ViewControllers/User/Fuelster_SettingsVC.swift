//
//  Fuelster_SettingsVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 23/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit


class Fuelster_SettingsVC: Fuelster_BaseViewController
{

    @IBOutlet weak var vehiclePlateLbl: UILabel!
    @IBOutlet weak var resetPasswordBtn: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let sliderVC = self.slideMenuController()
        sliderVC!.navigationItem.rightBarButtonItems = []
        sliderVC!.navigationItem.titleView = nil
        //To fix the Nav title alignment issue on iPhone 6 & 6s
        resetPasswordBtn.applyPrimaryShadow()
        let selftitle = "Settings"
        let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
        titleLabel.text = selftitle
        titleLabel.font = UIFont.appRegularFontWithSize18()
        self.navigationItem.titleView = titleLabel


        let defs = NSUserDefaults.standardUserDefaults()
        //print(defs.objectForKey(kTruckNumber))
        if defs.objectForKey(kTruckNumber) != nil
        {
            self.vehiclePlateLbl.text = defs.objectForKey(kTruckNumber) as? String
        }
        else
        {
            self.vehiclePlateLbl.text = ""
        }
        
    }
    
    override func viewDidLayoutSubviews()
    {
        let scrollView = self.view as! TPKeyboardAvoidingScrollView
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width , scrollView.frame.size.height  )
    }
    

    @IBAction func resetPasswordButtonAction(sender: AnyObject)
    {
        if let preview = NSBundle.mainBundle().loadNibNamed("ResetPassword", owner: self, options: nil).first as? ResetPassword
        {
            preview.frame = self.view.frame
            preview.parent = self
            self.view.addSubview(preview)
            self.view.bringSubviewToFront(preview)
            self.navigationController?.navigationBarHidden = true
        }
    }
   
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
