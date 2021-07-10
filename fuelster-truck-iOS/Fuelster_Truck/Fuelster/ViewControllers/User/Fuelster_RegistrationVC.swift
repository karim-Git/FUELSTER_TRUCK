//
//  Fuelster_RegistrationVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 09/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_RegistrationVC: Fuelster_BaseViewController {
    
    @IBOutlet weak var firstNameTF: RBATextField!
    @IBOutlet weak var lastNameTF: RBATextField!
    @IBOutlet weak var phoneNumberTF: REFormattedNumberField!
    @IBOutlet weak var emailTF: RBATextField!
    @IBOutlet weak var passwordTF: RBATextField!
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var signupScrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var signupSuccessView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        firstNameTF.applyTextFieldPrimaryTheme()
        lastNameTF.applyTextFieldPrimaryTheme()
        phoneNumberTF.applyTextFieldPrimaryTheme()
        emailTF.applyTextFieldPrimaryTheme()
        passwordTF.applyTextFieldPrimaryTheme()
        
        phoneNumberTF.format = "(XXX) XXX-XXXX"
        signUpButton.applyPrimaryShadow()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func dismissSignupViewController(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func signupButtonAction(sender: AnyObject) {
        
        let (valid,tf) = self.validateFields()
        
        if  valid == false {
            
            if tf == emailTF {
                
                self.loginAlertVC.presentAlertWithMessage(kEmailvalidationMessage, controller: self)
                return
            }
            if tf == phoneNumberTF {
                
                self.loginAlertVC.presentAlertWithMessage(kPhoneNumberValidationMessage, controller: self)
                return
            }
            
            self.loginAlertVC.presentAlertWithMessage(kSignUpAllDetailsMessage, controller: self)
            return
        }
        self.view .initHudView(.Indeterminate, message: kHudRegisteringMessage)

        let signUpBody = userModel.requestForRegistrationBody([firstNameTF.text!,lastNameTF.text!,emailTF.text!,phoneNumberTF.text!,passwordTF.text!])
        
        userModel.requestForUserRegistartion(signUpBody, success: { (result) in
            //print(result)
            dispatch_async(dispatch_get_main_queue()) {
                self.view .hideHudView()
                self.enableViews(false)
            }
            
        }) { (error) in
            //print(error)
            dispatch_async(dispatch_get_main_queue()) {
                self.view .hideHudView()
                self.loginAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self)
            }
        }
    }
    
    
    func validateFields() -> (Bool,UITextField?) {
        
        for v in signupScrollView.subviews {
            
            if v is UITextField {
                
                let tf = v as! UITextField
                
                if tf.text?.characters.count <= 0 {
                    
                    return (false,tf)
                }
            }
        }
        
        if (phoneNumberTF.text?.characters.count < 14) {
            
            return (false,phoneNumberTF)
        }
        
        if ((emailTF.text?.validateEmail()) == false) {
            
            return (false,emailTF)
        }
        
        
        return (true,nil)
    }
    
    
    @IBAction func okButtonAction(sender: AnyObject) {
        
        self.enableViews(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func enableViews(show:Bool) -> Void {
        self.signupSuccessView.hidden = show
        self.signupScrollView.hidden = !show
    }
    
    
    @IBAction func takeImageAction(sender: AnyObject) {
        
        let imagPicker = RBAImagePickerManager()
        imagPicker.setParent(self)
        imagPicker.showImagePicker()
    }
    
    
    //MARK: ImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageButton.setImage(pickedImage, forState: .Normal)
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
