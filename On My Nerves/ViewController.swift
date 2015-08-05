//
//  ViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 7/31/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit

var fabrics : [Fabric] = [Fabric]()
var fabricNamesArray : [String] = [String]()
var fabricTimesArray : [Int] = [Int]()
var fabricImagenamesArray : [String] = [String]()


class ViewController: UIViewController {

    @IBOutlet weak var times: UILabel!
    @IBOutlet weak var startStopTimer: UIButton!
    @IBOutlet weak var currentFabricImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // recreate the arrays saving the data        
        if NSUserDefaults.standardUserDefaults().objectForKey("fabricNames") != nil {
            
            fabricNamesArray = NSUserDefaults.standardUserDefaults().objectForKey("fabricNames") as! [String]
            fabricTimesArray = NSUserDefaults.standardUserDefaults().objectForKey("fabricTimes") as! [Int]
            fabricImagenamesArray = NSUserDefaults.standardUserDefaults().objectForKey("fabricImagenames") as! [String]
            
            // create the Fabric class and fill it in
            for var index = 0; index < fabricNamesArray.count; index++ {
                
                var newFabric = Fabric()
                
                newFabric.fabricName = fabricNamesArray[index]
                
                newFabric.fabricTime = fabricTimesArray[index]
                
                newFabric.fabricImageName = fabricImagenamesArray[index]
                
                fabrics.append(newFabric)
            }
            
        }
        
    }

    
    @IBAction func startStopTimer(sender: UIButton) {
        
        times.text = "Times:  \(fabrics[0].fabricTime)"
    

    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

