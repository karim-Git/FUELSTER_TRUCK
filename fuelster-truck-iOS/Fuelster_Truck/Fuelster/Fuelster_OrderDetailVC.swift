//
//  Fuelster_OrderDetailVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 06/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_OrderDetailVC: Fuelster_BaseViewController {

    @IBOutlet weak var orderDetailSV: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var orderStatusView: UIView!
    @IBOutlet weak var orderDetailView: UIView!
    
    @IBOutlet weak var orderPlacedTimeLbl2: UILabel!
    @IBOutlet weak var orderPlacedTimeLbl1: UILabel!
    
    @IBOutlet weak var orderplacedTimeLbl: UILabel!
    @IBOutlet weak var orderPlacedStatusLbl: UILabel!
    @IBOutlet weak var orderPlacedLine: UIView!
    @IBOutlet weak var orderPlacedStatusView: UIImageView!
    
    @IBOutlet weak var orderConfirmedTimeLbl2: UILabel!
    @IBOutlet weak var orderConfirmedTimeLbl1: UILabel!
    @IBOutlet weak var orderConfimedTimeLbl: UILabel!
    @IBOutlet weak var orderConfimedStatusLbl: UILabel!
    @IBOutlet weak var orderConfimedLine: UIView!
    @IBOutlet weak var orderConfimedStatusView: UIImageView!
    @IBOutlet weak var orderCancelReasonLbl: UILabel!
    
    @IBOutlet weak var orderEnrouteStatusLbl: UILabel!
    @IBOutlet weak var orderEnrouteLine: UIView!
    @IBOutlet weak var orderEnrouteStatusView: UIImageView!
    @IBOutlet weak var orderEnrouteLbl2: UILabel!
    @IBOutlet weak var orderEnrouteLbl1: UILabel!
    @IBOutlet weak var orderEnrouteTimeLbl: UILabel!
    
    @IBOutlet weak var deiveredView: UIView!

    @IBOutlet weak var fuelPriceLbl: UILabel!
    @IBOutlet weak var fuelDeliveredLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    var cancelView : OrderCancellationView!
    @IBOutlet weak var cancelBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var acceptButtonTopCOnstraint: NSLayoutConstraint!
    
    @IBOutlet var refreshBtn: UIBarButtonItem!
    
    func notificationMethod()
    {
        self.refreshButtonAction(nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationMethod), name:"OrderDetailsRefresh", object: nil)
        self.navigationItem.rightBarButtonItem = refreshBtn

        //let sliderVC : self.slideMenuController()
       // sliderVC.navigationItem.titleView = nil
        //To fix the Nav title alignment issue on iPhone 6 & 6s
        let selftitle = "Order Details"
        let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
        titleLabel.text = selftitle
        titleLabel.font = UIFont.appRegularFontWithSize18()
        self.navigationItem.titleView = titleLabel

        
        if let statusView = NSBundle.mainBundle().loadNibNamed("Fuelster_OrderStatusView", owner: self, options: nil).first as? Fuelster_OrderStatusView
        {
            statusView.frame = self.orderStatusView.bounds//CGRectMake(0.0, 0.0, self.orderStatusView.frame.size.width, self.orderStatusView.frame.size.height)
            statusView.setupOrderStatus(self.orderModel.order!)
            self.orderStatusView.addSubview(statusView)
        }
        
        if let detailView = NSBundle.mainBundle().loadNibNamed("Fuelster_OrderDetailView", owner: self, options: nil).first as? Fuelster_OrderDetailView
        {
            detailView.frame = self.orderDetailView.bounds
            detailView.setupOrderDetails(orderModel.order!)
            detailView.parentVC = self

            self.orderDetailView.addSubview(detailView)
            self.orderDetailView.layer.cornerRadius = 15.0
            detailView.layer.cornerRadius = 15.0

        }
        
        self.orderPlacedLine.backgroundColor = UIColor.init(red: 24.0/255.0, green: 184.0/255.0, blue: 215.0/255.0, alpha: 1.0)
       
        let statusHistory = orderModel.order?.orderStatusHistiry(OrderStatusNew)
      //  print(statusHistory!)

        self.orderplacedTimeLbl.text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseDate()
        self.orderPlacedTimeLbl1.text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseTime()
        self.orderPlacedTimeLbl2.text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseAMPM()

        let orderNumber = orderModel.order?.orderNumber!
        self.orderPlacedStatusLbl.text = "Order placed: \(orderNumber!)"
        self.orderPlacedStatusView.image = UIImage.init(named: "Order_Status_Blue")
        self.orderDetailView.applyScecondaryBackGroundGradient()
      
        //Setup for Order Tracking
        if orderModel.order?.status == OrderStatusCompleted {
            self.updateOrderCompleteStatus(true)
        }
        else
        {
            self.updateOrderCompleteStatus(false)

        }
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLayoutSubviews()
    {
        
        if orderModel.order?.status == OrderStatusCompleted
        {
            self.orderDetailSV.contentSize = CGSizeMake(self.view.frame.size.width, self.deiveredView.frame.origin.y+self.deiveredView.frame.size.height+50)
        }
        else
        {
            self.orderDetailSV.contentSize = CGSizeMake(self.view.frame.size.width, self.acceptBtn.frame.origin.y+self.acceptBtn.frame.size.height+100)
        }

    }


    @IBAction func refreshButtonAction(sender: AnyObject!) {
        
        self.view.initHudView(.Indeterminate, message: "Refreshing...")
        orderModel.requestForOrderDetails(orderModel.order!.orderId!, success: {
            (result) in
            
            dispatch_async(dispatch_get_main_queue()) {
                self.orderModel.order?.initWithOrderInfo(result as! [NSObject : AnyObject])
                self.view.hideHudView()
                
                let statusView = self.orderStatusView.subviews[0] as? Fuelster_OrderStatusView
                statusView!.setupOrderStatus(self.orderModel.order!)
                
                let detailView = self.orderDetailView.subviews[0] as? Fuelster_OrderDetailView
                detailView!.setupOrderDetails(self.orderModel.order!)
                //self.setupDriverInfo()
                //Setup for Order Tracking
                if self.orderModel.order?.status == OrderStatusCompleted {
                    self.updateOrderCompleteStatus(true)
                }
                else
                {
                    self.updateOrderCompleteStatus(false)
                }
                
            }
        }) { (error) in
            
            dispatch_async(dispatch_get_main_queue()) {
                self.view.hideHudView()
                
            }
        }
    }
  
    
    func setupDriverInfo() ->  Void
    {
       let filledQty = (orderModel.order?.filledQuantity!)!
         let filledPrice = (orderModel.order?.chargedPrice!)!
        
        self.fuelDeliveredLbl!.text =  "\(filledQty) gal"
        self.fuelPriceLbl!.text = "$\(filledPrice)"
    }
    
    
    func updateOrderConfirmedStatus(enable:Bool) -> Void
    {
        
         // if enable true order completed or confirmed

        if enable == true
        {
             self.orderConfimedLine.backgroundColor = UIColor.init(red: 24.0/255.0, green: 184.0/255.0, blue: 215.0/255.0, alpha: 1.0)
            self.orderConfimedTimeLbl.hidden = false
            self.orderConfirmedTimeLbl1.hidden = false
            self.orderConfirmedTimeLbl2.hidden = false

            let statusHistory = orderModel.order?.orderStatusHistiry(OrderStatusAccepted)
           // print(statusHistory!)

             self.orderConfimedTimeLbl.text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseDate()
            self.orderConfirmedTimeLbl1.text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseTime()
            self.orderConfirmedTimeLbl2 .text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseAMPM()

             self.orderConfimedStatusLbl.text = "Order Accepted"
             self.orderConfimedStatusView.image = UIImage.init(named: "Order_Status_Blue")
            
             self.acceptBtn.applyPlainStyle()
             self.acceptBtn .setTitle("Call customer", forState: .Normal)
             self.acceptBtn .setTitleColor(UIColor.blackColor(), forState: .Normal)
            
             self.cancelBtn.setBackgroundImage(UIImage.init(named: "Btn_BG_Small"), forState: .Normal)
             self.cancelBtn .setTitle("Complete Order", forState: .Normal)
             self.cancelBtn.applyPrimaryShadow()
             self.cancelBtn .setTitleColor(UIColor.whiteColor(), forState: .Normal)
            
            acceptButtonTopCOnstraint.constant = -60
            cancelBtnTopConstraint.constant = -60

        }
        else
        {
            // Order can be Cancelled,New
            self.orderConfimedLine.backgroundColor = UIColor.lightGrayColor()
            self.orderConfimedTimeLbl.hidden = true
            self.orderConfirmedTimeLbl1.hidden = true
            self.orderConfirmedTimeLbl2.hidden = true

            self.orderConfimedStatusLbl.text = "Order yet to be confirmed"
           
            self.cancelBtn.applyPlainStyle()
            self.cancelBtn .setTitle("Cancel", forState: .Normal)
            self.cancelBtn .setTitleColor(UIColor.blackColor(), forState: .Normal)
            
            self.acceptBtn.setBackgroundImage(UIImage.init(named: "Btn_BG_Small"), forState: .Normal)
            self.acceptBtn .setTitle("Accept", forState: .Normal)
            self.acceptBtn.applyPrimaryShadow()
            self.acceptBtn .setTitleColor(UIColor.whiteColor(), forState: .Normal)

            acceptButtonTopCOnstraint.constant = -60
            cancelBtnTopConstraint.constant = -60
            if orderModel.order?.status == OrderStatusNew {
                self.orderCancelReasonLbl.hidden = true
                self.orderConfimedStatusView.image = UIImage.init(named: "Order_Status_Gray")
            }
            else {
                //Order can be Cancelled
                self.orderCancelReasonLbl.hidden = false
                self.acceptBtn.hidden = true
                self.cancelBtn.hidden = true
                self.orderConfimedTimeLbl.hidden = false
                self.orderConfirmedTimeLbl1.hidden = false
                self.orderConfirmedTimeLbl2.hidden = false

                let cancelReason = orderModel.order?.cancelReason!
                self.orderCancelReasonLbl.text = "Reason:\(cancelReason!)"
                let statusHistory = orderModel.order?.orderStatusHistiry(OrderStatusCancelled)
              //  print(statusHistory!)
              
                self.orderConfimedTimeLbl.text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseDate()
                self.orderConfirmedTimeLbl1.text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseTime()
                self.orderConfirmedTimeLbl2 .text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseAMPM()

                var flaggedBy = orderModel.order?.flaggedBy!
                if flaggedBy == "Customer"  {
                    flaggedBy = "Customer"
                }
                if flaggedBy == "System"  {
                    flaggedBy = "Fuelster"

                }
                if flaggedBy == "Card"  {
                    flaggedBy = "Auto cancelled.Credit/Debit card declined"
                }
                
                if flaggedBy == nil  {
                    flaggedBy = "Auto cancelled."
                    flaggedBy = "Auto cancelled. Credit/Debit card declined"
                }

                self.orderConfimedStatusLbl.text = "Order Cancelled by \(flaggedBy!)"
                self.orderConfimedLine.backgroundColor = UIColor.init(red: 24.0/255.0, green: 184.0/255.0, blue: 215.0/255.0, alpha: 1.0)
                self.orderConfimedStatusView.image = UIImage.init(named: "Order_Status_Declined")
            }
        }
    }
    
    
    func updateOrderCompleteStatus(enable:Bool) -> Void
    {
        
        // if enable true order completed, confirmed

        self.orderEnrouteLine.hidden = !enable
        self.orderEnrouteStatusLbl.hidden = !enable
        self.orderEnrouteStatusView.hidden = !enable
        self.deiveredView.hidden = !enable
        self.acceptBtn.hidden = enable
        self.cancelBtn.hidden = enable
        
        if enable == true
        {
            
            self.orderConfimedLine.backgroundColor = UIColor.init(red: 24.0/255.0, green: 184.0/255.0, blue: 215.0/255.0, alpha: 1.0)
            self.orderConfimedTimeLbl.hidden = false
            self.orderConfirmedTimeLbl1.hidden = false
            self.orderConfirmedTimeLbl2.hidden = false
            self.setupDriverInfo()

            var statusHistory = orderModel.order?.orderStatusHistiry(OrderStatusCompleted)
      //      print(statusHistory!)

            self.orderConfimedTimeLbl.text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseDate()
            self.orderConfirmedTimeLbl1.text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseTime()
            self.orderConfirmedTimeLbl2 .text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseAMPM()

            self.orderConfimedStatusLbl.text = "Order Accepted"
            self.orderConfimedStatusView.image = UIImage.init(named: "Order_Status_Blue")

            self.orderEnrouteLine.backgroundColor = UIColor.init(red: 24.0/255.0, green: 184.0/255.0, blue: 215.0/255.0, alpha: 1.0)
            

 
            self.orderEnrouteTimeLbl.hidden = false
            self.orderEnrouteLbl1.hidden = false
            self.orderEnrouteLbl2.hidden = false

            statusHistory = orderModel.order?.orderStatusHistiry(OrderStatusCompleted)
        //    print(statusHistory!)

            self.orderEnrouteTimeLbl.text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseDate()
            self.orderEnrouteLbl1.text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseTime()
            self.orderEnrouteLbl2 .text = (statusHistory![kOrderUpdatedAt] as? String)?.getStringFromParseAMPM()

            self.orderEnrouteStatusLbl.text = "Order Completed"
            self.orderEnrouteStatusView.image = UIImage.init(named: "Order_Status_Blue")

        }
        else
        {
            // else order New, Cancelled,Accepted
            if orderModel.order?.status == OrderStatusAccepted
            {
                self.updateOrderConfirmedStatus(true)
            }
            else
            {
                self.updateOrderConfirmedStatus(false)
            }

        }
        
    }

    
    @IBAction func cancelOrderButtonAction(sender: AnyObject)
    {
        
        let actionsArr:[()->()] = [{
            _ in
            if let cancelView = NSBundle.mainBundle().loadNibNamed("OrderCancellationView", owner: self, options: nil).first as? OrderCancellationView
            {
                self.cancelView = cancelView
                self.cancelView.parentVC = self
                self.cancelView.frame = self.view.frame
                self.view.addSubview(self.cancelView)
                self.view.bringSubviewToFront(self.cancelView)
                self.navigationController?.navigationBarHidden = true
            }
            
            },{
                _ in
                
            }]
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles:["Cancel","No"], controller: self, message: "Are you sure you want to cancel the order?")
    }
    
    @IBAction func updateOrderStatusAction(sender: AnyObject)
    {
        let btn = sender as? UIButton
        if btn?.currentTitle == "Cancel"
        {
            let actionsArr:[()->()] = [{
                _ in
                if let cancelView = NSBundle.mainBundle().loadNibNamed("OrderCancellationView", owner: self, options: nil).first as? OrderCancellationView
                {
                    self.cancelView = cancelView
                    self.cancelView.parentVC = self
                    self.cancelView.frame = self.view.frame
                    self.view.addSubview(self.cancelView)
                    self.view.bringSubviewToFront(self.cancelView)
                    self.navigationController?.navigationBarHidden = false
                }
                
                },{
                    _ in
                    
                }]
            self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles:["Cancel Order","No"], controller: self, message: "Are you sure you want to cancel the order?")
            return

        }
            
        else if btn?.currentTitle == "Accept" {
            let actionsArr:[()->()] = [{
                _ in
                self.updateOrderWithInfo(["status":OrderStatusAccepted,"_id":(self.orderModel.order?.orderId)!])
                },{
                    _ in
                    
                }]
            self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles:["Accept Order","No"], controller: self, message: "Are you sure you want to accept the order?")
            return
            
        }
        else if btn?.currentTitle == "Complete Order"
        {
            self.pushViewControllerWithIdentifier(ORDER_FINISH_VC)
        }
        else if btn?.currentTitle == "Call customer"
        {
            self.callButtonAction(btn!)
        }

    }
    
    override func cancelOrder(cancelReason:String) -> Void
    {
        self.updateOrderWithInfo(["status":OrderStatusCancelled,"_id":(self.orderModel.order?.orderId)!,"cancelReason":cancelReason])
    }


    @IBAction func callButtonAction(sender: AnyObject)
    {
        self.view.callContactPerson((orderModel.order?.user![kUserPhone] as? String)!)
    }

    
    func updateOrderWithInfo(orderInfo:[NSObject:AnyObject]) -> Void
    {
        
        orderModel.requestForUpdateOrder(orderInfo, success: { (result) in
         //   print(result)
            dispatch_async(dispatch_get_main_queue())
            {
                if self.cancelView != nil
                {
                    self.cancelView.hidden = true
                    self.navigationController?.navigationBarHidden = false
                    self.cancelView.sendSubviewToBack(self.view)
                }
               //self.loginAlertVC.presentAlertWithMessage("Order updated successfully.", controller: self)
                self.loginAlertVC.presentAlertWithActions([
                    {
                        
                    _ in
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    }], buttonTitles:["OK"], controller: self, message: "Order updated successfully")
            }
            
        }) { (error) in
           // print(error)
            dispatch_async(dispatch_get_main_queue())
            {
                self.loginAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self)
                return
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
