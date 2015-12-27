//
//  HelpAboutViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 8/14/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit

class HelpAboutViewController: UIViewController {

    @IBOutlet weak var HelpAboutText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HelpAboutText.text =
            "Hello! \n\n" +
            "Thanks for trying out On My Nerves! \n\n" +
            "This is a nerve desensitization app. If you don't know what that means, this app is not for you.\n\n" +
            "I wrote this app to help me with my physical therapy. Hope it works for you.\n\n" +
            "I drew all the icons, which means I shouldn't give up my day job as an engineer :) \n\n" +
            "To keep things simple, editing the list of fabrics is only available when the overall timer is not running. Either hit startover or finish current desensitization session.\n\n" +
            "Stats are recorded only once a day to keep things simple, meaning if you run the app 2x in the same day, you only get credit for running it once that day. If you need to track more than once a day, contact me via the App Store to request it." +
            "Alarm music is a free trimmed 8 second version of Iron Bacon by Kevin MacLeod (incompetech.com)\n" +
            "Licensed under Creative Commons: By Attribution 3.0\n" +
            "http://creativecommons.org/licenses/by/3.0/\n\n" +
            "Use at own risk\n\n" +
            "Copyright (c) 2015 Sara Ford. All rights reserved."
        
        HelpAboutText.font = UIFont(name: HelpAboutText.font!.fontName, size: 18)
        
        HelpAboutText.scrollRangeToVisible(NSRange(location:0, length:0))

    }

    // force to scroll at the top of the view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        HelpAboutText.setContentOffset(CGPointZero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeHelpAbout(sender: UIButton) {
        
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
