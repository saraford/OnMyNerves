//
//  NewReleaseViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 12/19/15.
//  Copyright © 2015 Sara Ford. All rights reserved.
//

import UIKit

class NewReleaseViewController: UIViewController {

    var textToShow:String!
    
    @IBOutlet weak var lightboxView: UIView!
    @IBOutlet weak var messageText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageText.text = textToShow
        
        lightboxView.layer.cornerRadius = 10.0
        lightboxView.layer.masksToBounds = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeWindow(sender: AnyObject) {
        
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
