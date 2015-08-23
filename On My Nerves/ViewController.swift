//
//  ViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 7/31/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit
import AVFoundation

var fabrics : [Fabric] = [Fabric]()
var fabricNamesArray : [String] = [String]()
var fabricTimesArray : [Int] = [Int]()

class ViewController: UIViewController {

    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var startStopTimerButton: UIButton!
    @IBOutlet weak var currentFabricName: UILabel!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var circleCounter: CircleCounterView!
    
    var startTime:NSDate!
    var myStopTime:NSDate!
    var timeRemaining:Int!
    
    // for updating the countdown timer in the UI
    var fabricTimer = NSTimer()

    // the current Fabric for showing on the UI by default and reset
    var currentFabricIndex: Int = 0
    
    // for handling missed/ignored notifications
    private var foregroundNotification: NSObjectProtocol!
    
    // we be rocking them beats
    var alarmAudio:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmAudio = AVAudioPlayer()
        alarmAudio = self.setupAudioPlayerWithFile("IronBacon", type:"m4a")
        alarmAudio.numberOfLoops = -1 // play until stop() is called
        alarmAudio.prepareToPlay();
        
        // recreate the arrays saving the data
        if NSUserDefaults.standardUserDefaults().objectForKey("fabricNames") != nil {
            
            println("loading the data")
            
            fabricNamesArray = NSUserDefaults.standardUserDefaults().objectForKey("fabricNames") as! [String]
            
            // bug: even if the objectForKey exists, it might be a 0 value. who knew?
            if (fabricNamesArray.count > 0) {
                
                fabricTimesArray = NSUserDefaults.standardUserDefaults().objectForKey("fabricTimes") as! [Int]
                
                // create the Fabric class and fill it in
                for var index = 0; index < fabricNamesArray.count; index++ {
                    
                    var newFabric = Fabric()
                    
                    newFabric.fabricName = fabricNamesArray[index]
                    
                    newFabric.fabricTime = fabricTimesArray[index]
                    
                    fabrics.append(newFabric)
                }
                
                // show the initial UI
                self.resetFabricDetails()
                
            } // end if there is valid saved data
            
        } // end if the key exists on disk, implying there is saved data

        
        
        // first check if the user missed a notification
        foregroundNotification = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: NSOperationQueue.mainQueue()) {
            [unowned self] notification in
            
            // next, if we're running...
            if (self.fabricTimer.valid) {
                
                println("must have missed a notification")
                
                // from docs: current scheduled local notifications - a notification is only current if it has *not* gone off yet. otherwise this list will be 0.
                var notifications = UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification]
                
                // if the count is 0, means either user has tapped notification or has missed it
                if (notifications.count == 0) {
                    
                    // if Now > myStopTime, either user tapped or opened app after missing notification. either way we need to stop and clear the notifications
                    if (NSDate().compare(self.myStopTime) == NSComparisonResult.OrderedDescending) {
                        
                        self.displayTimeLabel.text = "0:00"
                        
                        // pretend the user hit the notification
                        self.doSomethingForNow()
                        
                    }
                    
                }
            }
        }
        
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        // needed for some reason - i forget
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        // this is the event that is fired after each scheduled Fabric Time, regardless user taps or app is active
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doSomethingForNow", name: "FabricSwitch", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resetToDefaults", name: "Terminating", object: nil)
        
        
    }// view did load
    
    
    @IBAction func cancelFabrics(sender: UIButton) {
    
        // we're not running and need to pause
//        startStopTimerButton.setTitle("Start", forState: UIControlState.Normal)
  
        //STARTHERE
        var myImage = UIImage(named: "playButton")
        startStopTimerButton.setImage(myImage, forState: UIControlState.Normal)
        
        stopTimer()
        
        // refresh the UI
        currentFabricIndex = 0
        resetFabricDetails()
        
    }
    
    
    @IBAction func nextFabric(sender: UIButton) {

        // verify just in case
        if (currentFabricIndex < fabrics.count - 1) {
            
            // if we're currently running, keep going
            if (fabricTimer.valid) {
                
                stopTimer()
                
                currentFabricIndex++
                
                resetFabricDetails()
                
                startTimer()
                
            } else {
                
                currentFabricIndex++
                
                resetFabricDetails()
                
            }
        
        }
        
    }
    
    
    
    @IBAction func prevButton(sender: UIButton) {

        // verify just in case
        if (currentFabricIndex > 0) {
            
            // if we're currently running, keep going
            if (fabricTimer.valid) {
                
                stopTimer()
                
                currentFabricIndex--
                
                resetFabricDetails()
                
                startTimer()
                
            } else {
                
                currentFabricIndex--
                
                resetFabricDetails()
                
            }
            
        }
        
    }
    
    

    var fabricCounter: Int = 0
    var countdownTime: Int!
    var isPaused:Bool = false
    var elapsedTimePaused: Int!
    @IBAction func startPauseTimer(sender: UIButton) {
        
//        printFabrics()
        
        // we're not running and need to start
        if !(fabricTimer.valid) {
            
           // startStopTimerButton.setTitle("Pause", forState: UIControlState.Normal)
            var myImage = UIImage(named: "pauseButton")
            startStopTimerButton.setImage(myImage, forState: UIControlState.Normal)
            
            // no editing while running
            // cannot set the individual button to disabled directly
            self.navigationController!.navigationBar.userInteractionEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGrayColor()
            
            
            if (isPaused) {
                
                // need to carry over the elapsed time
                elapsedTimePaused = timeElapsed
                
                isPaused = false
                
            } else {
            
                // show countdown
                displayTimeLabel.text = "\(fabrics[fabricCounter].fabricTime)"
                
                // show the UI
                resetFabricDetails()
                timeRemaining = fabrics[currentFabricIndex].fabricTime
                
            }
            
            startTimer()
        }
        else {

            // there is no pause on a NSTimer, so we kill timer and recreate
            isPaused = true
            
            var myImage = UIImage(named: "playButton")
            startStopTimerButton.setImage(myImage, forState: UIControlState.Normal)
            
            // stop Timer and cancel the notifications
            stopTimer()
            
            // okay it's fine now to edit
            self.navigationController!.navigationBar.userInteractionEnabled = true
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 255, alpha: 255)
 
        }

    }
    
    func printFabrics() {
        
        for fabric in fabrics {
            println(fabric.fabricName)
            println(fabric.fabricTime)
            println()
        }
        
        println("-----------------")
    }
    
    func resetToDefaults() {
        
        currentFabricIndex = 0
        resetFabricDetails()
    }
    

    func resetFabricDetails() {

        var currentFabric = fabrics[currentFabricIndex]
  
        timeRemaining = currentFabric.fabricTime
        displayTimeLabel.text = "\(timeRemaining)"
                
        currentFabricName.text = currentFabric.fabricName
        
        circleCounter.counter = 0
        circleCounter.NumOfSeconds = 0
        
        elapsedTimePaused = 0
        timeElapsed = 0
        
        navBarTitle.title = "On My Nerves"
    }
    
    // Oh boy oh boy! here we go!!!
    func startTimer() {
        
        // so we grab the current time and the fabric time to it
        startTime = NSDate()
        //println("Start time at...")
       // printDate(startTime)
       
        myStopTime = NSDate(timeIntervalSinceNow: NSTimeInterval(timeRemaining))
       // println("Stop time at...")
       // printDate(myStopTime)
        
        // this minuteTimer is ONLY used to display the timer countdown in the UI
        // so each second it will go from 9:59, 9:58, blah blah blah
        // the notification below is what stops this timer
        fabricTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateFabricTime"), userInfo: nil, repeats: true)
        
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
        
        resetFabricDetails()
        
      //  startStopTimerButton.setTitle("Start", forState: UIControlState.Normal)

        var myImage = UIImage(named: "playButton")
        startStopTimerButton.setImage(myImage, forState: UIControlState.Normal)
        
        // and can edit by default
        self.navigationController!.navigationBar.userInteractionEnabled = true
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 255, alpha: 255)

    }
    
    // the actual NSTimer loop - this is only used to update the 0:59 text and nothing else
    var timeElapsed:Int = 0
    func updateFabricTime() {
        
        //Find the difference between current time and the original start time
        // if coming back from pause, add elapsedTimePaused; otherwise this is 0
        timeElapsed = Int(floor(NSDate().timeIntervalSinceDate(startTime))) + elapsedTimePaused
        
        // current display time
        timeRemaining = timeRemaining - 1

        // update circle timer
        circleCounter.counter = timeElapsed
        circleCounter.NumOfSeconds = fabrics[currentFabricIndex].fabricTime
        
        displayTimeLabel.text = "\(timeRemaining)"
        
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

        if (fabrics.count > 0) {
            resetFabricDetails()
            
            // disable all play controls
            startStopTimerButton.enabled = true
            prevButton.enabled = true
            nextButton.enabled = true
            cancelButton.enabled = true
            
        } else {
            
            // disable all play controls
            startStopTimerButton.enabled = false
            prevButton.enabled = false
            nextButton.enabled = false
            cancelButton.enabled = false
        }
        
    }
    
    // this is fired after every scheduled FabricTime interval via the notification service
    // this is fired regardless user taps notification or it comes while app is running
    func doSomethingForNow() {
        
            //  NSLog("I'm stopping the timer")
            var trueStopTime = NSDate()
            
            //   NSLog("Stop Time:")
            // printDate(trueStopTime)
            
            stopTimer()

            // in case there was any paused time
            elapsedTimePaused = 0
            
            // start blasting the alarm
            alarmAudio.play()
            
            // continue to next Fabric or end
            currentFabricIndex++
            if (currentFabricIndex < fabrics.count) {
                
                // rock on
                showAlertAndContinue("Fabric Done!", message: "Move to next fabric")
                
            } else {
                
                showAlertToEnd("We're all done!", message: "Kick ass!")
            }

            
            // clear the notification
            UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    

    func showAlertAndContinue(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        // after the user dismisses the alert we can start the next 1 minute run
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            action in
            
            // refreshing the UI here so it doesn't appear behind the alert. Feels odd
            self.resetFabricDetails()
            
            // stop the alarm
            if (self.alarmAudio.playing) {
                self.alarmAudio.stop()
                self.alarmAudio.currentTime = 0.0
            }

            self.startTimer()
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func showAlertToEnd(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // after the user dismisses the alert we can start the next 1 minute run
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            action in
            
            // println("yo we've stopped the timer")
            
            // stop the alarm
            if (self.alarmAudio.playing) {
                self.alarmAudio.stop()
                self.alarmAudio.currentTime = 0.0
            }

            // we're all done
            self.resetUI()
            
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

    // cut and pasted from SO
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
        var path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        var url = NSURL.fileURLWithPath(path!)
        
        var error: NSError?
        
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        return audioPlayer!
    }

    
}

