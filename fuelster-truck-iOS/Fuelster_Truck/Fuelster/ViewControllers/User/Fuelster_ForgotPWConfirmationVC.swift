//
//  Fuelster_ForgotPWConfirmationVC.swift
//  Fuelster
//
//  Created by Prasad on 9/19/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_ForgotPWConfirmationVC: UIViewController
{
    //Outlets
     @IBOutlet weak var confirmationMsgLabel: UILabel!
    @IBOutlet weak var okButton : UIButton!
    @IBOutlet weak var bottomIllustrater: UIImageView!

    var email : String!

    //MARK: View start
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.applyBottomLineForIllustreter()
        self.showConfirmationMessage()
    }
    
    @IBAction func okButtonAction(sender : AnyObject)
    {
        UIApplication.sharedApplication().keyWindow?.rootViewController = storyboard!.instantiateViewControllerWithIdentifier(LOGIN_VC)
        return
     /*   //Navigation back to specifica view Login View
        for vc: UIViewController in self.navigationController!.viewControllers
        {
            if (vc is Fuelster_LoginVC) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let VC2 = storyboard.instantiateViewControllerWithIdentifier(LOGIN_VC)
                self.navigationController!.popToViewController(VC2, animated: false)!
            }
        }
        */
    
    }
    
    func showConfirmationMessage() -> Void {
        
        if(email.characters.count > 0)
        {
            
            let string = confirmationMsgLabel.text! + "\n" + email
            confirmationMsgLabel.attributedText = string.boldSubString(email, font: UIFont.appRegularFontWithSize14(), subFont: UIFont.appBoldFontWithSize15())
        }
    }
    func applyBottomLineForIllustreter()
    {
        let seperaterLabel = UILabel(frame: CGRect(x: -100, y:bottomIllustrater.frame.size.height , width: self.view.frame.size.width+100 , height: 0.5))
        seperaterLabel.backgroundColor = UIColor.appUltraLightFontColor()
        bottomIllustrater.clipsToBounds = false
        bottomIllustrater.addSubview(seperaterLabel)
    }

    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

   

}
