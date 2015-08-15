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
            "Yep\n\n" +
            "Alarm music is a trimmed 8 second version of Iron Bacon by Kevin MacLeod (incompetech.com)\n" +
            "Licensed under Creative Commons: By Attribution 3.0\n" +
            "http://creativecommons.org/licenses/by/3.0/\n\n" +
        "Copyright (c) 2015 Sara Ford. All rights reserved."
        
        
        HelpAboutText.font = UIFont(name: HelpAboutText.font.fontName, size: 18)
        
        HelpAboutText.scrollRangeToVisible(NSRange(location:0, length:0))

        
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
