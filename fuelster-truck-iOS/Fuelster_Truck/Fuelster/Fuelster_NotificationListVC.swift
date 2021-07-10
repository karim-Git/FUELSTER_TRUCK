//
//  Fuelster_NotificationListVC.swift
//  Fuelster
//
//  Created by Kareem on 16/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_NotificationListVC: Fuelster_BaseViewController {
    
    @IBOutlet var clearAllBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton : UIBarButtonItem!
      var noOrdersFoundView: NoSearchResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "NotificationCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "NotificationCell")
        //self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0)

        self.navigationItem.leftBarButtonItem = closeButton
         noOrdersFoundView = self.addNoDataMessageView("No notifications found.")
        var sliderVC : UIViewController!
        sliderVC = self.slideMenuController()
       // sliderVC.navigationItem.titleView = nil
        //To fix the Nav title alignment issue on iPhone 6 & 6s
        let selftitle = "Notifications"
        let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
        titleLabel.text = selftitle
        titleLabel.font = UIFont.appRegularFontWithSize18()
        self.navigationItem.titleView = titleLabel

        tableView.separatorStyle = .None
        self.orderModel.fetchNotifications()
        self.tableView.reloadData()
       closeButton.target = self
       closeButton.action = #selector(closeButtonTapped(_:))

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearNotificationAction(sender: AnyObject) {
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: --- TableView methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if  (orderModel.notificationsArr?.count)! == 0{
            noOrdersFoundView.hidden = false
            return 0
        }
        
        noOrdersFoundView.hidden = true
        return (self.orderModel.notificationsArr?.count)!;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:NotificationCell = tableView.dequeueReusableCellWithIdentifier("NotificationCell")! as! NotificationCell
        
       let notification = self.orderModel.notificationsArr![indexPath.row]
        cell.tag = indexPath.row
        cell.messageLabel.text =  notification.alertMessage
        cell.timeLabel.text =  notification.time!.getNotificationTime()
        cell.fuelTypeLbl.text =  notification.fuelType!.orderFuelTypeName()
        let qty = notification.quantity!
        cell.fuelQtyLbl.attributedText =  "Fuel Quantity: \(qty) gal".getBoldAttributeStringWithBoldFont(UIFont.appBoldFontWithSize13(),normalFont: UIFont.appRegularFontWithSize12())
 
        cell.delegate = self
       
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
       
        return 100.0;
        
    }
    
    // MARK: ---- Button Actions
    @IBAction func closeButtonTapped(sender: UIButton) {
         self.navigationController?.popViewControllerAnimated(true)
    }
    
    func cellPushButtonAction(cell:UITableViewCell) -> Void
    {
        let notification = self.orderModel.notificationsArr![cell.tag]
        
        self.refreshButtonAction(notification.orderId!)
    }
    
    
    func refreshButtonAction(orderId:String) {
        
        self.view.initHudView(.Indeterminate, message: "Refreshing...")
        orderModel.requestForOrderDetails(orderId, success: {
            (result) in
            
            dispatch_async(dispatch_get_main_queue()) {
                let newOrder = Order()
                self.orderModel.order = newOrder.initWithOrderInfo(result as! [NSObject : AnyObject])
                self.view.hideHudView()
                self.pushViewControllerWithIdentifier(ORDER_DETAILVC)
            }
        }) { (error) in
            
            dispatch_async(dispatch_get_main_queue()) {
                self.view.hideHudView()
                self.loginAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self)
                
            }
        }
    }
    


}
