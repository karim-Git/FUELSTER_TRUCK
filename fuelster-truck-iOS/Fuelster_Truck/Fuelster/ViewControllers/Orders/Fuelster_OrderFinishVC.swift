//
//  Fuelster_OrderFinishVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 19/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_OrderFinishVC: Fuelster_BaseViewController,UITextFieldDelegate
{

    @IBOutlet weak var orderTopView: UIView!
    @IBOutlet weak var deliverTimeLbl: UILabel!
    @IBOutlet weak var quantityTF: RBATextField!
    @IBOutlet weak var priceLbl: UILabel!
    
    override func viewDidLoad()
    
    {
        super.viewDidLoad()
        
        var sliderVC : UIViewController!
        sliderVC = self.slideMenuController()
       // sliderVC.navigationItem.titleView = nil
        //To fix the Nav title alignment issue on iPhone 6 & 6s
        let selftitle = "Finish Order"
        let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
        titleLabel.text = selftitle
        titleLabel.font = UIFont.appRegularFontWithSize18()
        self.navigationItem.titleView = titleLabel

        self.quantityTF.applyTextFieldPrimaryTheme()
        self.quantityTF.initToolBar()
        if let statusView = NSBundle.mainBundle().loadNibNamed("Fuelster_OrderStatusView", owner: self, options: nil).first as? Fuelster_OrderStatusView
        {
            statusView.frame = self.orderTopView.bounds
            statusView.setupOrderStatus(self.orderModel.order!)
            self.orderTopView.addSubview(statusView)
        }
        
        self.deliverTimeLbl.text = String.getStringFromCurrentDate()
        self.quantityTF.text = orderModel.order?.quantity?.stringValue
        let fuelPrice:String? = "\((orderModel.order!.pricePerGallon!) * Double(orderModel.order!.quantity!))"
        self.priceLbl.text! = "\(fuelPrice!)"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func completeOrderButtonAction(sender: AnyObject) {
        
        let actionsArr:[()->()] = [{
            _ in
            //actual price, filledQuantity
            self.orderModel.requestForUpdateOrder(["status":OrderStatusCompleted,"_id":(self.orderModel.order?.orderId)!,"actualPrice":self.priceLbl.text!,"filledQuantity":self.quantityTF.text!], success: { (result) in
                //print(result)
                dispatch_async(dispatch_get_main_queue()) {
                  //  self.loginAlertVC.presentAlertWithMessage("Order Completed successfully.", controller: self)
                    self.loginAlertVC.presentAlertWithActions([{
                        _ in
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        }], buttonTitles:["Ok"], controller: self, message: "Order updated successfully")
                }
                
            }) { (error) in
                //print(error)
                dispatch_async(dispatch_get_main_queue()) {
                    self.loginAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self)
                    return
                }
            }

            },{
                _ in
                
            }]
        
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles:["Complete Order","No"], controller: self, message: "Are you sure you want to Complete the order?")
    }

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }

    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField.text?.characters.count > 0 {
            self.priceLbl.text = "\((orderModel.order!.pricePerGallon!) * Double(textField.text!)!)"
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
