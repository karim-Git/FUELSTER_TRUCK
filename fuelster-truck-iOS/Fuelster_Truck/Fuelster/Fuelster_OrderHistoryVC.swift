//
//  Fuelster_OrderHistoryVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 23/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_OrderHistoryVC: UITableViewController,CustomeCellDelegate {

    let orderModel = OrdersModel.sharedInstance
    var orderPageCount =  1
    var pageLoading = false
    @IBOutlet var refreshButton: UIBarButtonItem!
     var noOrdersFoundView: NoSearchResult!
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        noOrdersFoundView = self.addNoDataMessageView("No orders found.")
        let sliderVC = self.slideMenuController()
        
        sliderVC!.navigationItem.rightBarButtonItems = []
        sliderVC!.navigationItem.rightBarButtonItem = refreshButton
        
        sliderVC!.navigationItem.titleView = nil
        //To fix the Nav title alignment issue on iPhone 6 & 6s
        let selftitle = "Order History"
        let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
        titleLabel.text = selftitle
        titleLabel.font = UIFont.appRegularFontWithSize18()
        self.navigationItem.titleView = titleLabel

        let nib = UINib(nibName: ORDERHISTORYCELL, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: ORDERHISTORYCELL)
        let nib1 = UINib(nibName: LOADINGCELL, bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: LOADINGCELL)

        self.tableView.contentInset = UIEdgeInsetsMake(0,0,65,0)
        
        self.tableView.separatorColor = UIColor.clearColor()
    }

    
    @IBAction func refreshButtonAction(sender: AnyObject)
    {
        self.orderPageCount = 1
        self.view.initHudView(.Indeterminate, message: "Loading...")
        self.getOrderList()

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.orderPageCount = 1
        self.view.initHudView(.Indeterminate, message: "Loading...")

        self.getOrderList()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   func getOrderList()->Void
   {
        orderModel.requestForUserOrderList(orderPageCount,success: { (result) in
            dispatch_async(dispatch_get_main_queue()) {
             //   print(result)
                self.view.hideHudView()

                self.tableView.reloadData()
                self.pageLoading = false
            }
        
        }) { (error) in
            dispatch_async(dispatch_get_main_queue()) {
                self.view.hideHudView()
                self.tableView.reloadData()
            }
        }

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if  (orderModel.allOrders?.count)! == 0{
            noOrdersFoundView.hidden = false
            return 0
        }
        
        noOrdersFoundView.hidden = true
        
        return (orderModel.allOrders?.count)!
    }

    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if indexPath.row == (orderModel.allOrders?.count)! && orderModel.isNextPage == true{
            if self.pageLoading == false {
                self.pageLoading = true
                self.orderPageCount += 1
                self.getOrderList()
            }
        }
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:OrderHistoryCell = tableView.dequeueReusableCellWithIdentifier(ORDERHISTORYCELL, forIndexPath: indexPath) as! OrderHistoryCell
        
        if self.orderModel.allOrders?.count == 0 {
            return cell
        }

        let order = orderModel.allOrders![indexPath.row]
        cell.configureCell(order,_delegate:self)
        cell.tag = indexPath.row
       // cell.contentView.applyPrimaryShadow()
        
        if order.status == OrderStatusCancelled
        {
            cell.orderPriceLbl.hidden = true
            cell.orderDateLbl.text =  order.updatedAt!.getStringFromParseFullDate()//((order.statusHistory![2])[kOrderUpdatedAt] as? String)?.getFullStringFromParseDate()
            cell.orderStatusLbl.textColor = UIColor.redColor()
            var flaggedBy = ""
            if order.flaggedBy == nil  {
                flaggedBy = "Auto cancelled. Credit/Debit card declined"
            }
            else
            {
                flaggedBy = (order.flaggedBy!)
            }

            if flaggedBy == "Customer"  {
                flaggedBy = "Customer"
            }
            if flaggedBy == "System"  {
                flaggedBy = "Fuelster"
            }
            if flaggedBy == "Card"  {
                flaggedBy = "Auto cancelled. Credit/Debit card declined"
            }
            
            cell.orderStatusLbl.text = "Cancelled by \(flaggedBy)"
            cell.orderStatusImgView.image = UIImage.init(named: "Cancel_Small")
            cell.orderStatusImgView.hidden = false
            if order.fuelType == "87" {
                cell.fuelTypeLbl.text = "\(order.fuelType!) Regular - \(order.quantity!) gal"
            }
            else {
                cell.fuelTypeLbl.text = "\(order.fuelType!) Premium - \(order.quantity!) gal"
            }
        }
            
        else if order.status == OrderStatusCompleted
        {
            cell.orderDateLbl.text =  order.updatedAt!.getStringFromParseFullDate()//((order.statusHistory![3])[kOrderUpdatedAt] as? String)?.getFullStringFromParseDate()
            cell.orderPriceLbl.hidden = false
            cell.orderPriceLbl.text = "$\(order.chargedPrice!)"
            cell.orderStatusLbl.textColor = UIColor.init(red: 126.0/255.0, green: 211.0/255.0, blue: 33.0/255.0, alpha: 1)
            cell.orderStatusImgView.image = UIImage.init(named: "Confirm_Small")
            cell.orderStatusImgView.hidden = false
                if order.fuelType == "87" {
                    cell.fuelTypeLbl.text = "\(order.fuelType!) Regular - \(order.filledQuantity!) gal"
                }
                else {
                    cell.fuelTypeLbl.text = "\(order.fuelType!) Premium - \(order.filledQuantity!) gal"
                }
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None


        return cell
    }
 
    
   override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == orderModel.allOrders?.count {
            return 40
        }
        return 226
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        
        
        //self.pushViewControllerWithIdentifier(ORDER_DETAILVC)
    }

    
    //MARK: CUstomCellDelegate methods
    
    func cellPushButtonAction(cell:UITableViewCell) -> Void
    {
        orderModel.order = orderModel.allOrders![cell.tag]
        self.pushViewControllerWithIdentifier(ORDER_DETAILVC)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
