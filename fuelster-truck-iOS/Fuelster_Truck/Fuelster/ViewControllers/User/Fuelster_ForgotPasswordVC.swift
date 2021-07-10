//
//  Fuelster_ForgotPasswordVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 19/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_ForgotPasswordVC: Fuelster_BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var bottomIllustrater: UIImageView!


    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTF.applyTextFieldPrimaryTheme()
        self.emailTF.addLeftView("Email_small")
        self.emailTF.leftView?.alpha = 0.7
        
        self.applyBottomLineForIllustreter()
    }
    
    func applyBottomLineForIllustreter()
    {
        let seperaterLabel = UILabel(frame: CGRect(x: -100, y:bottomIllustrater.frame.size.height , width: self.view.frame.size.width+100 , height: 0.5))
        seperaterLabel.backgroundColor = UIColor.appUltraLightFontColor()
        bottomIllustrater.clipsToBounds = false
        bottomIllustrater.addSubview(seperaterLabel)
    }


    @IBAction func dismissForgotPasswordVC(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
        @IBAction func continueButtonAction(sender: AnyObject)
        {
        
        if self.emailTF.text?.validateEmail() == false
        {
            self.loginAlertVC.presentAlertWithMessage(kEmailvalidationMessage, controller: self)
            return
        }
        else
        {
            self.emailTF.resignFirstResponder()
            self.view .initHudView(.Indeterminate, message: kHudWaitingMessage)

            let forgotBody = userModel.requestForForgotPasswordBody([self.emailTF.text!])
            userModel.requestForUserForgotPassword(forgotBody, success: { (result) in
              ///  print(result)
                dispatch_async(dispatch_get_main_queue()) {
                    self.view .hideHudView()
                    let actionsArr:[()->()] = [{
                        _ in
                      //  self.dismissViewControllerAnimated(true, completion: nil)

                        }]
                   // self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: ["Ok"], controller: self, message: ((result["result"]as?[NSObject:AnyObject])!["success"] as? String)!)
                    self.presentSuccessResetView()
                   // self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: ["Ok"], controller: self, message: (result["result"]as?[NSObject:AnyObject])["result"])
 
                    
                   // self.dismissViewControllerAnimated(true, completion: nil)
                }

            }) { (error) in
                //print(error)
                dispatch_async(dispatch_get_main_queue()) {
                    self.view .hideHudView()
                    self.loginAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self)
                }

                return
            }

        }
    }
   

    func  presentSuccessResetView() -> Void
    {
        let vc: Fuelster_ForgotPWConfirmationVC = self.getViewControllerWithIdentifier(FORGOT_PWD_CONFIRMATION_VC) as! Fuelster_ForgotPWConfirmationVC
        vc.email = emailTF.text
        self.presentViewController(vc, animated: true, completion: nil)   }
     func textFieldShouldReturn(textField: UITextField) -> Bool
     {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
