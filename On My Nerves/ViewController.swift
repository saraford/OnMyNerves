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

    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var startStopTimerButton: UIButton!
    @IBOutlet weak var currentFabricImage: UIImageView!
    @IBOutlet weak var currentFabricName: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    
    // if true, user opened app without tapping notification so we need to skip the real notification
    var skipBecauseUserDidNotTapNotification:Bool = false;
    
    // for updating the countdown timer in the UI
    var fabricTimer = NSTimer()

    // the current Fabric for showing on the UI by default and reset
    var currentFabricIndex: Int = 0
    
    // for handling missed/ignored notifications
    // private var foregroundNotification: NSObjectProtocol!
    
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
            
            // show the initial UI
            resetFabricDetails()
            
        }
        
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        // needed for some reason - i forget
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        // this is the event that is fired after each scheduled Fabric Time, regardless user taps or app is active
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doSomethingForNow", name: "FabricSwitch", object: nil)
        
    }
    
    
    @IBAction func resetFabrics(sender: UIButton) {
    
        // we're not running and need to pause
        startStopTimerButton.setTitle("Start", forState: UIControlState.Normal)
        
        stopTimer()
        
        // refresh the UI
        currentFabricIndex = 1
        resetFabricDetails()
        
    }
    
    
    

    var fabricCounter: Int = 0
    var countdownTime: Int!
    @IBAction func startPauseTimer(sender: UIButton) {
        
        printFabrics()
        
        // we're not running and need to start
        if !(fabricTimer.valid) {
            
            startStopTimerButton.setTitle("Pause", forState: UIControlState.Normal)
            
            // show countdown
            displayTimeLabel.text = "\(fabrics[fabricCounter].fabricTime)"
            timeElapsedLabel.text = "0:00"
            
            startTimer()
        }
        else {


        }

    }
    
    func printFabrics() {
        
        for fabric in fabrics {
            println(fabric.fabricName)
            println(fabric.fabricTime)
            println(fabric.fabricImageName)
            println()
        }
        
        println("-----------------")
    }
    
    
    

    func resetFabricDetails() {

        var currentFabric = fabrics[currentFabricIndex]
  
        displayTime(displayTimeLabel, time: currentFabric.fabricTime)
        
        currentFabricImage.image = currentFabric.retrieveImage()
        
        currentFabricName.text = currentFabric.fabricName
        
        progressBar.progress = 0.0
        
        timeElapsedLabel.text = "0:00"
    }
    
    // Oh boy oh boy! here we go!!!
    var startTime:NSDate!
    var myStopTime:NSDate!
    var timeRemaining:Int!
    func startTimer() {
        
        // show the UI
        resetFabricDetails()
        timeRemaining = fabrics[currentFabricIndex].fabricTime
        
        // so we grab the current time and the fabric time to it
        startTime = NSDate()
        println("Start time at...")
        printDate(startTime)
        myStopTime = NSDate(timeIntervalSinceNow: NSTimeInterval(timeRemaining))
        println("Stop time at...")
        printDate(myStopTime)
        
        // this minuteTimer is ONLY used to display the timer countdown in the UI
        // so each second it will go from 9:59, 9:58, blah blah blah
        // the notification below is what stops this timer
        fabricTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateFabricTime"), userInfo: nil, repeats: true)
        
        // reset the skip
        skipBecauseUserDidNotTapNotification = false
        
        // schedule local notification
        var notification = UILocalNotification()
        notification.alertBody = "Hello World"
        notification.alertAction = "Next Fabric"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(timeRemaining))
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    func stopTimer() {
        fabricTimer.invalidate()
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    
    }
    
    func resetUI() {
        
        currentFabricIndex = 0
        startStopTimerButton.setTitle("Start", forState: UIControlState.Normal)
    }
    
    // the actual NSTimer loop - this is only used to update the 9:59 text and nothing else
    var timeElapsed:Int = 0
    func updateFabricTime() {
        
        //Find the difference between current time and the original start time
        var timeElapsed:NSTimeInterval = NSDate().timeIntervalSinceDate(startTime)
        var secondsElapsed = Int(round(timeElapsed))
        
        // current display time
        timeRemaining = timeRemaining - 1

        // update progress bar
        progressBar.progress =  Float(timeElapsed) / Float(fabrics[currentFabricIndex].fabricTime)
        
        displayTime(displayTimeLabel, time: timeRemaining)
        
        var timeElapsedToDisplay = Int(floor(timeElapsed))
        displayTime(timeElapsedLabel, time: timeElapsedToDisplay)
        
    }
    
    func displayTime(label: UILabel, time: Int) {
        
        // UI prettiness because Apple can't give me a NSDate.Now.ToString()
        // gods I miss C#
        if (time > 9) {
            label.text = "0:\(time)"
            
        } else {
            label.text = "0:0\(time)"
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        resetFabricDetails()
    }
    
    // this is fired after every scheduled FabricTime interval via the notification service
    // this is fired regardless user taps notification or it comes while app is running
    func doSomethingForNow() {
        
        // skip only if we're being called from viewDidLoad to skip the call from the notification
        if !(skipBecauseUserDidNotTapNotification) {

            //  NSLog("I'm stopping the timer")
            var trueStopTime = NSDate()
            
            //   NSLog("Stop Time:")
            printDate(trueStopTime)
            
            stopTimer()
            
            // continue to next Fabric or end
            currentFabricIndex++
            if (currentFabricIndex < fabrics.count) {
            
                // rock on
                showAlertAndContinue("Fabric Done!", message: "Move to next fabric")
                
            } else {
                
                // we're all done
                resetUI()
                
                showAlertToEnd("We're all done!", message: "Kick ass!")
            }

            
            // clear the notification
            UIApplication.sharedApplication().cancelAllLocalNotifications()

        }
    }
    
    

    func showAlertAndContinue(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // after the user dismisses the alert we can start the next 1 minute run
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            action in self.startTimer()
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func showAlertToEnd(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // after the user dismisses the alert we can start the next 1 minute run
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            action in println("yo we've stopped the timer")

            
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    

    func printDate(date:NSDate) {
        var formatter = NSDateFormatter();
        formatter.dateFormat = "HH:mm:ss";
        let defaultTimeZoneStr = formatter.stringFromDate(date);
        
        NSLog(defaultTimeZoneStr);
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

