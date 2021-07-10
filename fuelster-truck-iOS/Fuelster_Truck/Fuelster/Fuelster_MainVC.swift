//
//  Fuelster_MainVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 19/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_MainVC: Fuelster_BaseViewController
{
    //UI Out lets
    @IBOutlet var ordersTableView: UITableView!
    @IBOutlet var newOrdersButton: UIButton!
    @IBOutlet var acceptedOrdersButton: UIButton!
    @IBOutlet var notificationButton: UIBarButtonItem!
     @IBOutlet var refreshButton: UIBarButtonItem!
    var isNewOrders = true
    var selectedRow = -1 //Indicates selected Vechile index in array
    // let orderModel = OrdersModel.sharedInstance
    var orderPageCount =  1
    var cancelView : OrderCancellationView!
    
    //Gloabla variable
    var sliderVC : UIViewController!
    let locationManager = O1LocationManager.sharedInstance()
    var pollingTImer = NSTimer()
    
     var noOrdersFoundView: NoSearchResult!
    
    //MARK: === View starts ===
    
    func notificationMethod()
    {
        self.refreshButtonAction(nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationMethod), name:"MainOrdersRefresh", object: nil)

        noOrdersFoundView = self.addNoDataMessageView("No orders found.")
        self.applyNavigationBarUI()
        self.addImageOnNavBar()
        
        sliderVC = self.slideMenuController()
        self.locationManager.start()

        //Topbar / Title view / Navigation bar
        let titleView = UIImageView.init(frame:CGRectMake(self.view.center.x-37.5,0.0,40,40))
        titleView.image =  UIImage.init(named: "Logo_Small")
        titleView.contentMode = .ScaleAspectFit
        sliderVC.navigationItem.titleView = titleView
        sliderVC.navigationItem.rightBarButtonItems = [notificationButton,refreshButton]
        self.newOrdersButtonAction(newOrdersButton);
        self.view.hideHudView()

        //Set custom cell to thje table
        let nib = UINib(nibName: "HomeNewOrdersCell", bundle: nil)
        self.ordersTableView.registerNib(nib, forCellReuseIdentifier: "HomeNewOrdersCell")
        let nib1 = UINib(nibName: LOADINGCELL, bundle: nil)
        self.ordersTableView.registerNib(nib1, forCellReuseIdentifier: LOADINGCELL)
        
        ordersTableView.tableFooterView = self.emptyViewToHideUnNecessaryRows()
        isNewOrders = true
        //Location pooling
        self.pollTruckLocation()
        pollingTImer = NSTimer.scheduledTimerWithTimeInterval(120, target: self, selector: #selector(pollTruckLocation), userInfo: nib, repeats: true)
        
        self.ordersTableView.separatorColor = UIColor.clearColor()
    }
    
    //view Will Appear
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.addImageOnNavBar()
        
        
        if (isNewOrders)
        {
            self.newOrdersButtonAction(newOrdersButton);
        }
        else
        {
            
            self.acceptedOrdersButtonAction(newOrdersButton);
        }
 



        
        var requestOrders = ""
        if isNewOrders == true {
            requestOrders = "New"
        }
        else {
            requestOrders = "Accepted"
        }
    }
    
    
    func addImageOnNavBar()
    {
        sliderVC = self.slideMenuController()
        sliderVC.title = "Select Your Vehicle"
        let titleView = UIImageView.init(frame:CGRectMake(self.view.center.x-37.5,0.0,40,40))
        titleView.image =  UIImage.init(named: "Logo_Small")
        titleView.contentMode = .ScaleAspectFit
        sliderVC.navigationItem.titleView = titleView
    }
    
    //Navigation Bars UI
    func applyNavigationBarUI()
    {
        //White navigation bar
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        let navigationBar = navigationController!.navigationBar
        navigationBar.tintColor = UIColor.appFontColor()
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.backgroundColor = UIColor.whiteColor()
        
        //White Status bar
        navigationBar.clipsToBounds = false
        let statusBarLabel = UILabel(frame: CGRect(x: 0, y: -20, width: self.view.frame.size.width , height: 20))
        statusBarLabel.backgroundColor = UIColor.whiteColor()
        navigationBar.addSubview(statusBarLabel)
        
        //Seperater color
        let seperaterLabel = UILabel(frame: CGRect(x: 0, y:navigationBar.frame.size.height-0.2 , width: self.view.frame.size.width , height: 0.2))
        seperaterLabel.backgroundColor = UIColor.appUltraLightFontColor()
        navigationBar.addSubview(seperaterLabel)
    }

    
    
    
    func getOrderList(status:String) -> Void {
        self.orderModel.requestForUserOrderList(1, status: status, success: {
            (result) in
           // print(result)
            dispatch_async(dispatch_get_main_queue())
            {
                self.view.hideHudView()
                self.ordersTableView.reloadData()
            }
        }) { (error) in
            
            dispatch_async(dispatch_get_main_queue())
            {
                self.view.hideHudView()
                self.ordersTableView.reloadData()

            }
        }
        
    }
    
    //MARK: === Toggle Button Actions ===
    @IBAction func newOrdersButtonAction(sender: AnyObject)
    {
        //Update Colors
        

        self.view.initHudView(.Indeterminate, message: "Loading...")

        
        newOrdersButton.setBackgroundImage(UIImage(named: "BlueGradientButton"), forState: .Normal)
        
        acceptedOrdersButton.setBackgroundImage(nil, forState: .Normal)
        acceptedOrdersButton.backgroundColor = UIColor.textFieldPrimaryBackgroundColor()
        
        newOrdersButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        acceptedOrdersButton.setTitleColor(UIColor.appFontColor(), forState: .Normal)
        
        isNewOrders = true
        self.getOrderList(OrderStatusNew)
        
        ordersTableView .reloadData()
        
               
    }
    
    @IBAction func acceptedOrdersButtonAction(sender: AnyObject)
    {
        //Update Colors
        self.view.initHudView(.Indeterminate, message: "Loading...")

        acceptedOrdersButton.setBackgroundImage(UIImage(named: "BlueGradientButton"), forState: .Normal)
        newOrdersButton.setBackgroundImage(nil, forState: .Normal)
        newOrdersButton.backgroundColor =  UIColor.textFieldPrimaryBackgroundColor()
        
        acceptedOrdersButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        newOrdersButton.setTitleColor(UIColor.appFontColor(), forState: .Normal)
        
        isNewOrders = false
        self.getOrderList(OrderStatusAccepted)
        
        ordersTableView .reloadData()
        
    }
    
    @IBAction func notificationButtonAction(sender: AnyObject)
    {
        self.pushViewControllerWithIdentifier(NOTIFICATIONVC)
    }
    
    @IBAction func refreshButtonAction(sender: AnyObject!)
    {
        self.view.initHudView(.Indeterminate, message: "Loading...")

        if (isNewOrders)
        {
            self.getOrderList(OrderStatusNew)
        }
        else
        {
            self.getOrderList(OrderStatusAccepted)
        }
        ordersTableView .reloadData()
    }

    //MARK: === Orders Table View ===
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if  (orderModel.allOrders?.count)! == 0{
            noOrdersFoundView.hidden = false
            return 0
        }
        noOrdersFoundView.hidden = true
        return (orderModel.allOrders?.count)!
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if orderModel.allOrders?.count == 0  {
            let loadingCell:LoadingCell = tableView.dequeueReusableCellWithIdentifier(LOADINGCELL, forIndexPath: indexPath) as! LoadingCell
            loadingCell.loadingIndicator .startAnimating()
            loadingCell.loadingIndicator.hidden = true
            loadingCell.loadingLbl.text = "No Orders found"
            return loadingCell
        }
        
        let cell:HomeNewOrdersCell = tableView.dequeueReusableCellWithIdentifier("HomeNewOrdersCell")! as! HomeNewOrdersCell
        cell.delegate = self
        cell.tag = indexPath.row
        
        //cell.applyScecondaryBackGroundGradient()
       // cell.contentView.applyPrimaryShadow()
      //  cell.applyPrimaryShadow()
        
        if self.orderModel.allOrders?.count == 0 {
            return cell
        }
        cell.configureCell(self.orderModel.allOrders![indexPath.row], _delegate: self)
        if(isNewOrders == true)
        {
        }
        else
        {
            
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        //cell.gradientLayer.frame = CGRectMake(0, 0, tableView.frame.size.width, 280)
        //cell.applyPrimaryShadow()
        return cell
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == (orderModel.allOrders?.count)! && orderModel.isNextPage == true{
            self.orderPageCount += 1
            self.getOrderList("\(self.orderPageCount)")
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
//        if(isNewOrders == true)
//        {
//        return 280
//        }
//        else
//        {
//            return 240
//        }
        
        return 300
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if 0 == self.orderModel.allOrders?.count {
            return
        }
        self.orderModel.order = self.orderModel.allOrders![indexPath.row]
        self.pushViewControllerWithIdentifier(ORDER_DETAILVC)
    }
    
    
    func emptyViewToHideUnNecessaryRows() -> UIView?
    {
        //Return this clear color view for footer
        let view = UIView(frame: CGRectMake(0, 0, 320, 100))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    
    //MARK: === Pool Truck functionality ===
    func pollTruckLocation() -> Void
    {
        if self.locationManager.currentLocation == nil{
            let actionsArr:[()->()] = [{
                _ in
                self.locationManager.start()
                }]
            
           // self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: ["Refresh"], controller: self, message: "No location found.Please check your location service.")
            return
        }
        let defs =  NSUserDefaults.standardUserDefaults()
        if (defs.objectForKey(kUserAuthToken) == nil)  {
            pollingTImer.invalidate()
        }
        //print(self.locationManager.currentLocation)
        var pollBody = model.preparePollLocationeUpdateRequestBody([String(self.locationManager.currentLocation.coordinate.longitude),String(self.locationManager.currentLocation.coordinate.latitude)])
        pollBody["type"] = "truck"
        userModel.requestForTruckPollLocation(pollBody, success: { (result) in
            dispatch_async(dispatch_get_main_queue()) {
                //print(result)
            }
            }, failureBlock: { (error) in
                dispatch_async(dispatch_get_main_queue()) {
                    //print(error.localizedDescription)
                }
        })
    }
    
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if keyPath == MYLOCATIONKEYPATH
        {
            
        }
    }
    
    
    deinit
    {
        //let mapView = GoogleMapView.sharedInsatnce()
       // mapView.removeObserver(self, forKeyPath:MYLOCATIONKEYPATH)
    }
    
    
    
    
    //MARK: Cell delegate methods ACCEPT / CANCEL / COMPLETE orders
    
    
    func HomeNewOrderCellAcceptOrder(cell: UITableViewCell)
    {
        self.orderModel.order = self.orderModel.allOrders![cell.tag]
        
        let actionsArr:[()->()] = [{
            _ in
            self.updateOrderWithInfo(["status":OrderStatusAccepted,"_id":(self.orderModel.order?.orderId)!])
            },{
                _ in
                
            }]
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles:["Accept Order","No"], controller: self, message: "Are you sure you want to accept the order?")
    }
    
    
    func HomeNewOrderCellCancelOrder(cell: UITableViewCell)
    {
        
        self.orderModel.order = self.orderModel.allOrders![cell.tag]
        
        let  messgae = "Do you want to cancel the Order?"
        let  status = "Cancel"
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
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles:[status,"No"], controller: self, message: messgae)
        
    }
    
    func HomeAcceptedOrdrsCellCompleteOrder(cell: UITableViewCell)
    {
        
        self.orderModel.order = self.orderModel.allOrders![cell.tag]
        
        let   messgae = "Do you want to complete the Order?"
        let  status = "Comlplete"
        let actionsArr:[()->()] = [{
            _ in
            self.updateOrderWithInfo(["status":OrderStatusCompleted,"_id":(self.orderModel.order!.orderId)!,"actualPrice":(self.orderModel.order?.price!)!,"filledQuantity":(self.orderModel.order?.quantity!)!])
            },{
                _ in
                
            }]
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles:[status,"No"], controller: self, message: messgae)
        
        
    }
    
    
    
    override func cancelOrder(cancelReason:String) -> Void {
        self.updateOrderWithInfo(["status":OrderStatusCancelled,"_id":(self.orderModel.order!.orderId)!,"cancelReason":cancelReason])
    }
    
    func updateOrderWithInfo(orderInfo:[NSObject:AnyObject]) -> Void {
        
        self.orderModel.requestForUpdateOrder(orderInfo, success: { (result) in
            //print(result)
            dispatch_async(dispatch_get_main_queue()) {
                if self.cancelView != nil
                {
                    self.cancelView.hidden = true
                    self.navigationController?.navigationBarHidden = false
                    self.cancelView.sendSubviewToBack(self.view)
                }
                self.loginAlertVC.presentAlertWithMessage("Order updated successfully", controller: self)
                
                for (index,order) in (self.orderModel.allOrders?.enumerate())!
                {
                    if (order.orderId == self.orderModel.order?.orderId)
                    {
                        self.orderModel.allOrders?.removeAtIndex(index)
                        self.ordersTableView.reloadData()
                        return
                    }
                }
            }
            
        }) { (error) in
            //print(error)
            dispatch_async(dispatch_get_main_queue()) {
                self.loginAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self)
                return
            }
        }
    }
    
    
    
    
    
    
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}
