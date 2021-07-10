//
//  Fuelster_LoginVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 09/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore

class Fuelster_LoginVC: Fuelster_BaseViewController,UITextFieldDelegate
{
    
    @IBOutlet weak var loginScrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var emailTF: RBATextField!
    @IBOutlet weak var passwordTF: RBATextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var bottomIllustrater: UIImageView!

    
    @IBOutlet weak var forgotPasswordButton: UIButton!


    
    
    let fieldValidator = RAFieldValidator.sharedInsatnce()
    let locationManager = O1LocationManager.sharedInstance()

    //Viewdid load
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.emailTF.applyTextFieldPrimaryTheme()
        self.emailTF.addLeftView("Email_small")
        self.emailTF.leftView?.alpha = 0.7
        self.passwordTF.applyTextFieldPrimaryTheme()
        self.passwordTF.addLeftView("Password_small")
        
        self.applyBottomLineForIllustreter()

        
        
        
        //Apply unnderline for forgot pwd button
        let fullString = forgotPasswordButton.titleLabel?.text
        
        let range = ((fullString! as NSString)).rangeOfString(fullString!)
        let underlineAttributedString = NSMutableAttributedString(string:fullString!)
        
        //Under line
        underlineAttributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: range)
        forgotPasswordButton.setAttributedTitle(underlineAttributedString, forState: .Normal)
        
        //Font
        underlineAttributedString.addAttribute(NSFontAttributeName, value: UIFont.appRegularFontWithSize12() , range: NSRange(location: 0, length: fullString!.characters.count))
        
        //Text Color
        underlineAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.appLightFontColor() , range: NSRange(location: 0, length: fullString!.characters.count))

        self.applyBottomLineForIllustreter()

    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        
        fieldValidator.requiredFields = [["Field":self.emailTF,"Key":"Email"],["Field":self.passwordTF,"Key":"Password"]]
        signInButton.applyPrimaryShadow()
        
        
         checkAutoLogin()
    }
    
    
    func checkAutoLogin()
    {
        let (username,password) = RBAKeyChainWrapper.getCredentialsFromKeychain()
        
        if (username.characters.count > 0 && password.characters.count > 0)
        {
            self.showLoginControls(false)
            emailTF.text = username
            passwordTF.text = password
            signInButtonAction(signInButton)
        }
        else
        {
            emailTF.text = ""
            passwordTF.text = ""
            self.showLoginControls(true)
        }
    }
    
    
    func showLoginControls(show:Bool) ->Void
    {
        emailTF.hidden = !show
        passwordTF.hidden = !show
        forgotPasswordButton.hidden = !show
        signInButton.hidden = !show
        //self.view.sendSubviewToBack(bgImg)
    }
    
    
    
    func applyBottomLineForIllustreter()
    {
        let seperaterLabel = UILabel(frame: CGRect(x: -100, y:bottomIllustrater.frame.size.height , width: self.view.frame.size.width+100 , height: 0.5))
        seperaterLabel.backgroundColor = UIColor.appUltraLightFontColor()
        bottomIllustrater.clipsToBounds = false
        bottomIllustrater.addSubview(seperaterLabel)
    }
    
    
  
    //SignIn Button Action
    @IBAction func signInButtonAction(sender: AnyObject)
    {
        self.logFlurryEvent(kFlurryLogin)
        self.loginScrollView.contentOffset = CGPointZero
        let validator = fieldValidator.validateReuiredFields()
        
        if (validator == nil)
        {
            if self.emailTF.text?.validateEmail() == true
            {
                //Device token
                let defaults = NSUserDefaults.standardUserDefaults()
                var deviceTokenString = defaults.stringForKey("deviceTokenString")
                if deviceTokenString == nil
                {
                    deviceTokenString = "1234"
                }
                //print(deviceTokenString)
                
                //Vehicle numbe plate
                var truckNumber = defaults.stringForKey(kTruckNumber)
                if truckNumber == nil
                {
                    truckNumber = "AP12K1820"
                }
                 //print(truckNumber)
                
                //Passing values to server
                self.view .initHudView(.Indeterminate, message: kHudLoggingMessage)
                let userInfo = userModel.requestForLoginBody([self.emailTF.text!,self.passwordTF.text!,"Driver", deviceTokenString!, truckNumber! ])
                userModel.requestForUserSignIn(userInfo, success:
                    {(result) in
                    //print("============  login result \(result) "     )
                  //  print("============  login userInfo \(result) "     )
                    self.keychain .saveCredentialsInKeychain(self.emailTF.text!, password: self.passwordTF.text!)
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.view .hideHudView()
                        self.presentMenuVC()
                    }
                    return
                    
                })
                {(error) in
                    //print(error)
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.view .hideHudView()
                        self.showLoginControls(true)

                        self.loginAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self)
                    }
                }
            }
            else {
                loginAlertVC.presentAlertWithMessage(kEmailvalidationMessage, controller: self)
                return
            }
        }
            
        else
        {
            let tf = validator["Field"] as! UITextField
            if tf == self.emailTF
            {
                loginAlertVC.presentAlertWithMessage(kEmailvalidationMessage, controller: self)
                return
            }
            else
            {
                loginAlertVC.presentAlertWithMessage(kSignUpAllDetailsMessage, controller: self)
                return
            }
        }
    }
    
    //Slide menu
    func presentMenuVC() -> Void
    {
        let nvc = self.getViewControllerWithIdentifier("NavigationVC")
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
