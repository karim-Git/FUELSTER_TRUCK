//
//  ViewController_ext.swift
//  DrillLogs
//
//  Created by Sandeep Kumar on 21/06/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation
import UIKit
import Flurry_iOS_SDK

extension UIViewController
{
    func storyBoard() -> UIStoryboard {
        
        let storyboard = UIStoryboard.init(name:"Main" , bundle: nil)
        
        return storyboard
    }
    
    func  getViewControllerWithIdentifier(identifier:String) -> UIViewController {
        
        let sb = self.storyBoard()
        let vc = sb.instantiateViewControllerWithIdentifier(identifier)
        return vc
    }
    
    func pushViewControllerWithIdentifier(identifier:String) -> Void
    {
        let vc = self.getViewControllerWithIdentifier(identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Multiple Storyboards
    func storyBoardWithName(name:String) -> UIStoryboard {
        
        let storyboard = UIStoryboard.init(name:name , bundle: nil)
        
        return storyboard
    }
    
    func  getViewControllerWithIdentifierAndStoryBoard(identifier:String, storyBoard:String) -> UIViewController {
        
        let sb = self.storyBoardWithName(storyBoard)
        let vc = sb.instantiateViewControllerWithIdentifier(identifier)
        return vc
    }
    func pushViewControllerWithIdentifierAndStoryBoard(identifier:String, storyBoard:String) -> Void
    {
        let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier,storyBoard: storyBoard)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func applyTintColorForLeftBarButtonWith(color:UIColor)  {
        self.navigationItem.leftBarButtonItem?.tintColor = color
    }
    
    func applyTintColorForRightBarButtonWith(color:UIColor)  {
        self.navigationItem.rightBarButtonItem?.tintColor = color
    }
    
    func deviceWidth() -> CGFloat {
        
        let  width  = UIScreen.mainScreen().bounds.size.width
        
        return width
        
    }
    
    func deviceHeight() -> CGFloat {
        
        let  height  = UIScreen.mainScreen().bounds.size.height
        
        return height
    }
    
    
    func deviceSize() -> CGSize {
        
        let  size  = UIScreen.mainScreen().bounds.size
        
        return size
    }
    
    
    func getStringFromSelectedDate(date:NSDate) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, YYYY h:mm:ss a"//"dd-MM-YYYY hh:mm a"
        let dateStr = formatter.stringFromDate(date)
        
        return dateStr;
    }
    
    
    func presentAlertController(alertControllerToPresent: O1AlertController, animated flag: Bool, completion: () -> Void) {
       
        if (alertControllerToPresent is UIAlertController) {
            self.presentViewController((alertControllerToPresent as! UIViewController), animated: flag, completion: completion)
        }
        else {
            alertControllerToPresent.presentAlertAnimated(flag, by: self, completion: completion)
            
        }
    }
    func addNoDataMessageView(message : String) -> NoSearchResult! {
        
        if let preview = NSBundle.mainBundle().loadNibNamed("NoSearchResult", owner: self, options: nil).first as? NoSearchResult
        {
            preview.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
            self.view.addSubview(preview)
            self.view.bringSubviewToFront(preview)
            preview.hidden = true
            preview.center = self.view.center
            preview.showMessage(message)
            return preview
        }
        return nil
    }

    
    //MARK:--- Flurry Events
    func logFlurryEvent(event:String) -> Void
    {
        Flurry.logEvent(event)
    }
}


