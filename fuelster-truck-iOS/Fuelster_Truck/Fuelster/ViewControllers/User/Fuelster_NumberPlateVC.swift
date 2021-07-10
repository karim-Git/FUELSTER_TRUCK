//
//  Fuelster_NumberPlateVC.swift
//  Fuelster
//
//  Created by Prasad on 9/15/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_NumberPlateVC: Fuelster_BaseViewController,UITextFieldDelegate
{
    
    @IBOutlet weak var numberPlateRegisterGoButton: UIButton!
    @IBOutlet weak var numberPlateTextField: RBATextField!
    @IBOutlet weak var bottomIllustrater: UIImageView!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        numberPlateTextField.applyTextFieldPrimaryTheme()
        numberPlateTextField.applyTextFieldPrimaryTheme()
        
        self.applyBottomLineForIllustreter()
        

    }
    
    
   override func viewDidLayoutSubviews()
    {
        let scrollView = self.view as! TPKeyboardAvoidingScrollView
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width , scrollView.frame.size.height  )
    }
    
    func applyBottomLineForIllustreter()
    {
        let seperaterLabel = UILabel(frame: CGRect(x: -100, y:bottomIllustrater.frame.size.height , width: self.view.frame.size.width+100 , height: 0.5))
        seperaterLabel.backgroundColor = UIColor.appUltraLightFontColor()
        bottomIllustrater.clipsToBounds = false
        bottomIllustrater.addSubview(seperaterLabel)
    }

    
    //Go button
    @IBAction func numberPlateRegisterGoButtonAction(sender: AnyObject)
    {
        let (valid,tf) = self.validateFields()
        
        if  valid == false
        {
            if tf == numberPlateTextField
            {
                self.loginAlertVC.presentAlertWithMessage(kvalidNumberPlateationMessage, controller: self)
                return
            }
        }
        
        //Logic for single time launch
        self.numberPlateTextField.resignFirstResponder()
        self.view .initHudView(.Indeterminate, message: kHudWaitingMessage)
        
        let validateTruckNumberBody = userModel.requestForValidateTruckNumberRequestBody([self.numberPlateTextField.text!])
        userModel.requestForValidateTruckNumber(validateTruckNumberBody, success: { (result) in
            
            dispatch_async(dispatch_get_main_queue())
            {
                self.view .hideHudView()
                let vc = self.getViewControllerWithIdentifier(LOGIN_VC)
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
        }) { (error) in
            //print(error)
            dispatch_async(dispatch_get_main_queue()) {
                self.view .hideHudView()
                self.loginAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self)
            }
            
            return
        }
        
        //=== === === === === service call === === === === ===

        
        
        
        
        
        
        
        
        
   
        
        //TO PASS vechicle number plate to login
        let truckNumber = numberPlateTextField.text
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(truckNumber, forKey: kTruckNumber)
    }
        
    
    
    //To validate the fields
    func validateFields() -> (Bool,UITextField?)
    {
        if (numberPlateTextField.text?.characters.count <= 0)
        {
            return (false,numberPlateTextField)
        }
        return (true,nil)
    }
   
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }// called when 'return' key pressed. return NO to ignore.

    
    /*func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        //flet str = textField.text! + string
        //numberPlateTextField.text = textField.text!.uppercaseString;
        numberPlateTextField.text = numberPlateTextField.text!+string.uppercaseStringr
        return true
    }*/

}
