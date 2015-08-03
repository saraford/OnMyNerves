//
//  ViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 7/31/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit

var fabricNameList = [String]()
var fabricTimeList = [Int]()
var fabricImageList = [String]()

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init the arrays from the data we have in storage
        if NSUserDefaults.standardUserDefaults().objectForKey("fabricNameList") != nil {
            
            fabricNameList = NSUserDefaults.standardUserDefaults().objectForKey("fabricNameList") as! [String]
            
        }

        // init the arrays from the data we have in storage
        if NSUserDefaults.standardUserDefaults().objectForKey("fabricTimeList") != nil {
            
            fabricTimeList = NSUserDefaults.standardUserDefaults().objectForKey("fabricTimeList") as! [Int]
            
        }
        
        // init the arrays from the data we have in storage
        if NSUserDefaults.standardUserDefaults().objectForKey("fabricImageList") != nil {
            
            fabricImageList = NSUserDefaults.standardUserDefaults().objectForKey("fabricImageList") as! [String]
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

