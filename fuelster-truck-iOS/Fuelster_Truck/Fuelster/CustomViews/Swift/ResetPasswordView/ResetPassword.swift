//
//  ResetPassword.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 02/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class ResetPassword: UIView,UITextFieldDelegate {

    @IBOutlet weak var oldPsswordTF: RBATextField!
    @IBOutlet weak var newPasswordTF: RBATextField!
    @IBOutlet weak var confirmPasswordTF: RBATextField!
    let model = Model.sharedInstance
    var parent = UIViewController()
    let fieldValidator = RAFieldValidator.sharedInsatnce()
    let resetAlertVC = RBAAlertController()

     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
        fieldValidator.requiredFields = [["Field":oldPsswordTF,"Key":"oldPssword"],["Field":newPasswordTF,"Key":"newPassword"],["Field":confirmPasswordTF,"Key":"confirmPassword"]]
        self.oldPsswordTF.applyTextFieldPrimaryTheme()
        self.newPasswordTF.applyTextFieldPrimaryTheme()
        self.confirmPasswordTF.applyTextFieldPrimaryTheme()

        self.oldPsswordTF.addLeftView("Password_small")
        self.newPasswordTF.addLeftView("Password_small")
        self.confirmPasswordTF.addLeftView("Password_small")
     }
 
    @IBAction func saveButtonAction(sender: AnyObject) {
     
        let validator = fieldValidator.validateReuiredFields()
        if (validator == nil) {

            if oldPsswordTF.text != RBAKeyChainWrapper.userPassword() {
                resetAlertVC.presentAlertWithMessage("Old Password is not correct.", controller: self.parent)
                return
            }
            
            
            if newPasswordTF.text?.characters.count<6 || newPasswordTF.text?.characters.count>20{
                
                resetAlertVC.presentAlertWithMessage(kPasswordValidationMaxLengthMessage, controller: self.parent)
                return
            }
            
            if oldPsswordTF.text?.characters.count<6 || oldPsswordTF.text?.characters.count>20{
                
                resetAlertVC.presentAlertWithMessage(kPasswordValidationMaxLengthMessage, controller: self.parent)
                return
            }

            
            if newPasswordTF.text != confirmPasswordTF.text {
                resetAlertVC.presentAlertWithMessage("New password and confirm password should be same.", controller: self.parent)
                return
            }
            self.initHudView(.Indeterminate, message: kHudWaitingMessage)

           // let resetBody = model.prepareresetPasswordRequestBody([newPasswordTF.text!])
            let resetBody = model.prepareresetPasswordRequestBody([self.oldPsswordTF.text!,self.newPasswordTF.text!])
            let userModel = UserModel.sharedInstance
            userModel.requestForResetPassword(resetBody, success: { (result) in
                
                //print("====== update password resetBody  \(resetBody) " )
                  //print("\n\n ====== update password responce \(result) " )
                
                
                //print(result)
                dispatch_async(dispatch_get_main_queue()) {
                        //kRequestErrorMessage]
                    self.hideHudView()
                    self.resetAlertVC.presentAlertWithMessage("Password changed Successfully.", controller: self.parent)
                    self.parent.navigationController?.navigationBarHidden = false
                    self.removeFromSuperview()
                    }

                }, failureBlock: { (error) in
                    //print(error)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.hideHudView()
                        self.resetAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self.parent)
                        return
                    }
                    
            })
        }
        else {
            let tf = validator["Field"] as! UITextField
            
            if tf == oldPsswordTF {
                resetAlertVC.presentAlertWithMessage(kSignUpAllDetailsMessage, controller: self.parent)
                return
            }
            else {
                resetAlertVC.presentAlertWithMessage(kSignUpAllDetailsMessage, controller: self.parent)
                return
            }


        }
    }

    @IBAction func closeButtonAction(sender: AnyObject) {
        
        self.parent.navigationController?.navigationBarHidden = false
        self.removeFromSuperview()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == oldPsswordTF {
            newPasswordTF.becomeFirstResponder()
        }
        else if textField == newPasswordTF {
            confirmPasswordTF.becomeFirstResponder()
        }
        else
        {
            confirmPasswordTF.resignFirstResponder()
        }
        
        return true
    }
}
