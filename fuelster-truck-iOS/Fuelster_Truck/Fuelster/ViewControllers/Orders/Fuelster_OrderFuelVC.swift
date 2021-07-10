//
//  Fuelster_OrderFuelVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 30/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_OrderFuelVC: Fuelster_BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var fuelSlider: UISlider!
    @IBOutlet weak var processingView: UIView!
    @IBOutlet weak var orderDeclinedView: UIView!
    @IBOutlet weak var estimatedPriceLbl: UILabel!
    @IBOutlet weak var estimatedDeliveryLbl: UILabel!
    @IBOutlet weak var helpTextView: UITextView!
    @IBOutlet weak var fuelTypeBtn: UIButton!
    
    var fuelTypeStr = ""
    var fuelQuantity:Int = 0
    var fuelPrice:Float = 1.99
    var fuelTypesArray : NSMutableArray!
    var popupTblView : UITableView!
    var popup : RBAPopup!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fuelSlider.setThumbImage(UIImage(named: "sliderThumb")!, forState: .Normal)
        fuelSlider.createSliderGradient()
        fuelSlider.setMinimumTrackImage(fuelSlider.createSliderGradient(), forState: .Normal)
        
        fuelQuantity = Int(fuelSlider.value)
        self.estimatedPriceLbl.text = "$\(fuelPrice*Float(fuelQuantity))"
        
        fuelTypesArray = NSMutableArray()

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        
    }
    
    
    func showPopUp(view:UIView) -> Void
    {
        if popupTblView == nil
        {
            let frame = CGRectMake(0, 0, view.frame.size.width, 150)
            popupTblView = UITableView.init(frame: frame)
            popupTblView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            popupTblView.delegate = self
            popupTblView.dataSource = self
        }
        
        let frame = CGRectMake(0, 0, view.frame.size.width, 150)
        popupTblView.frame = frame
        self.view.endEditing(true)
        popupTblView.reloadData()
        popup = RBAPopup.init(customView: popupTblView)
        popup.presentPointingAtView(view, inView: self.view, animated: true)
    }

    @IBAction func closeButtonAction(sender: AnyObject) {
        
        self.showOrderStatusView(self.orderDeclinedView,show: true)
        self.orderDeclinedView.sendSubviewToBack(self.view)
    }
    

    @IBAction func sliderValueChangedAction(sender: AnyObject) {
        
        fuelQuantity = Int(fuelSlider.value)
        //print(fuelQuantity)
        self.estimatedPriceLbl.text = "$\(fuelPrice*Float(fuelQuantity))"
    }

    
    @IBAction func fuelTypeButtonAction(sender: AnyObject) {
        
        showPopUp(sender as! UIView)

    }
    
    
    @IBAction func confirmOrderButtonAction(sender: AnyObject) {
        
        let actionsArr:[()->()] = [{
            _ in
            //print("Order Confimred")
             
            let newOrder =  self.orderModel.requestForCreateOrderBody([""], location: [""], user: [""], vehicle: [""])
            self.showOrderStatusView(self.processingView,show: true)
            self.view.bringSubviewToFront(self.processingView)

            self.orderModel.requestForNewOrderForUser(newOrder, success: { (result) in
                self.showOrderStatusView(self.processingView,show: false)
                self.processingView.sendSubviewToBack(self.view)
                
            }) { (error) in
                self.showOrderStatusView(self.processingView,show: false)
                self.processingView.sendSubviewToBack(self.view)
                
                self.showOrderStatusView(self.orderDeclinedView,show: true)
                self.view.bringSubviewToFront(self.orderDeclinedView)
            }
            
            },{
                _ in
                //print("Order Cancelled")
                self.showOrderStatusView(self.orderDeclinedView,show: true)
                self.view.bringSubviewToFront(self.orderDeclinedView)
                
            }]
        
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: ["Confirm","Cancel"], controller: self, message: "Do  you want to confirm the order?")
    }
    
    
    func showOrderStatusView(statusView:UIView,show:Bool) -> Void {
        
        statusView.hidden = !show
        self.navigationController?.navigationBarHidden = show
    }
    
    
    @IBAction func orderRetryButtonAction(sender: AnyObject) {
        
        self.showOrderStatusView(self.orderDeclinedView,show: true)
        self.orderDeclinedView.sendSubviewToBack(self.view)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return fuelTypesArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        fuelTypeBtn.setTitle(fuelTypesArray[indexPath.row] as? String, forState: .Normal)
    }
    
    
    deinit {
        
    }

}
