//
//  StatsViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 9/4/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet weak var statsTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayStats()
        
    
    }

    func displayStats() {
        
        // load data
        if NSUserDefaults.standardUserDefaults().objectForKey("fabricCompleted") != nil {
            
            fabricCompletedArray = NSUserDefaults.standardUserDefaults().objectForKey("fabricCompleted") as! [String]

            // display data
            var text:String = ""
            for stat in fabricCompletedArray {
                
                text += stat + " "
                
            }
            
            statsTextField.text = text
            
        }
        else {
            
            statsTextField.text = "Sorry, nothing to display"
            
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func CloseWindow(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
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
