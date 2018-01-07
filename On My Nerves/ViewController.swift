//
//  ViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 7/31/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit
import AVFoundation
import AppCenterAnalytics

var fabrics : [Fabric] = [Fabric]()
var fabricNamesArray : [String] = [String]()
var fabricTimesArray : [Int] = [Int]()
//var fabricCompletedArray : [String] = [String]()

class ViewController: UIViewController {

    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var startStopTimerButton: UIButton!
    @IBOutlet weak var currentFabricName: UILabel!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var circleCounter: CircleCounterView!
    @IBOutlet weak var progressView: OverallProgressView!
    @IBOutlet weak var startLabel: UILabel!    
    @IBOutlet weak var helpAboutButton: UIButton!
    @IBOutlet weak var fabricDisplayView: UIView!
    @IBOutlet weak var createFabricsList: UIButton!
    
    var startTime:Date!
    var myStopTime:Date!
    var timeRemaining:Int!
    
    // for updating the countdown timer in the UI
    var fabricTimer = Timer()

    // the current Fabric for showing on the UI by default and reset
    var currentFabricIndex: Int = 0
    
    // for handling missed/ignored notifications
    fileprivate var foregroundNotification: NSObjectProtocol!
    
    // if true, user opened app without tapping notification so we need to skip the real notification
    var skipBecauseUserDidNotTapNotification:Bool = false;
    
    // we be rocking them beats
    var alarmAudio:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        alarmAudio = AVAudioPlayer()
        alarmAudio = self.setupAudioPlayerWithFile("IronBacon", type:"m4a")
        alarmAudio.numberOfLoops = -1 // play until stop() is called
        alarmAudio.prepareToPlay();
        
        // recreate the arrays saving the data
        if UserDefaults.standard.object(forKey: "fabricNames") != nil {
            
            fabricDisplayView.isHidden = false
            createFabricsList.isHidden = true
            
            fabricNamesArray = UserDefaults.standard.object(forKey: "fabricNames") as! [String]
            
            // bug: even if the objectForKey exists, it might be a 0 value. who knew?
            if (fabricNamesArray.count > 0) {
                
                fabricTimesArray = UserDefaults.standard.object(forKey: "fabricTimes") as! [Int]
                
                // create the Fabric class and fill it in
                for index in 0 ..< fabricNamesArray.count {
                    
                    let newFabric = Fabric()
                    
                    newFabric.fabricName = fabricNamesArray[index]
                    
                    newFabric.fabricTime = fabricTimesArray[index]
                    
                    fabrics.append(newFabric)
                }
                
                // show the initial UI
                //self.resetFabricDetails()
                self.resetUI()
                
            } // end if there is valid saved data
            
        } // end if the key exists on disk, implying there is saved data
        else {
            
            // there is no data, so no buttons are enabled
            prevButton.isEnabled = false
            nextButton.isEnabled = false
            cancelButton.isEnabled = false
            startStopTimerButton.isEnabled = false
            
            // instead of showing the fabric, show the "Edit" button
            fabricDisplayView.isHidden = true
            createFabricsList.isHidden = false
            
            
        }
        
        // first check if the user missed a notification
        foregroundNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) {
            [unowned self] notification in
            
            // next, if we're running...
            if (self.fabricTimer.isValid) {
                
                // from docs: current scheduled local notifications - a notification is only current if it has *not* gone off yet. otherwise this list will be 0.
                let notifications = UIApplication.shared.scheduledLocalNotifications! as [UILocalNotification]
                
                // if the count is 0, means either user has tapped notification or has missed it
                if (notifications.count == 0) {
                    
                    // if Now > myStopTime, either user tapped or opened app after missing notification. either way we need to stop and clear the notifications
                    if (Date().compare(self.myStopTime) == ComparisonResult.orderedDescending) {
                        
                        self.displayTimeLabel.text = "0"
                        
                        // pretend the user hit the notification
                        self.doSomethingForNow()
                        
                        // user did not tap
                        self.skipBecauseUserDidNotTapNotification = true

                    }
                    
                }
            }
        }
        
        
        UIApplication.shared.cancelAllLocalNotifications()
        
        // needed for some reason - i forget
        UIApplication.shared.isIdleTimerDisabled = true
        
        // this is the event that is fired after each scheduled Fabric Time, regardless user taps or app is active
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.doSomethingForNow), name: NSNotification.Name(rawValue: "FabricSwitch"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.resetUI), name: NSNotification.Name(rawValue: "Terminating"), object: nil)
        

        // TODO: STATS: To be replaced by Core Data
        // load any previously saved completions, in case user finishes and we need to tack on
//        if NSUserDefaults.standardUserDefaults().objectForKey("fabricCompleted") != nil {
//            
//            fabricCompletedArray = NSUserDefaults.standardUserDefaults().objectForKey("fabricCompleted") as! [String]
//            
//        }
        
    }// view did load
    
    
//    func createDummyData() {
//    
////        fabricCompletedArray = NSUserDefaults.standardUserDefaults().objectForKey("fabricCompleted") as! [String]
//        
//        fabricCompletedArray = [String]()
//
//        fabricCompletedArray.append("09/10/2015")
//        fabricCompletedArray.append("09/09/2015")
//        fabricCompletedArray.append("09/08/2015")
//        fabricCompletedArray.append("09/07/2015")
//        fabricCompletedArray.append("09/06/2015")
//        fabricCompletedArray.append("09/05/2015")
//        fabricCompletedArray.append("09/04/2015")
//        fabricCompletedArray.append("09/03/2015")
//        fabricCompletedArray.append("09/01/2015")
//        
//        fabricCompletedArray.append("08/30/2015")
//        fabricCompletedArray.append("08/29/2015")
//        fabricCompletedArray.append("08/28/2015")
//        fabricCompletedArray.append("08/27/2015")
//        fabricCompletedArray.append("08/26/2015")
//        fabricCompletedArray.append("08/25/2015")
//        fabricCompletedArray.append("08/24/2015")
//        fabricCompletedArray.append("08/23/2015")
//        fabricCompletedArray.append("08/22/2015")
//        fabricCompletedArray.append("08/20/2015")
//        fabricCompletedArray.append("08/19/2015")
//        fabricCompletedArray.append("08/18/2015")
//        fabricCompletedArray.append("08/17/2015")
//        fabricCompletedArray.append("08/16/2015")
//        fabricCompletedArray.append("08/15/2015")
//        fabricCompletedArray.append("08/13/2015")
//        fabricCompletedArray.append("08/12/2015")
//        fabricCompletedArray.append("08/11/2015")
//        fabricCompletedArray.append("08/10/2015")
//        fabricCompletedArray.append("08/09/2015")
//        fabricCompletedArray.append("08/08/2015")
//        fabricCompletedArray.append("08/06/2015")
//        fabricCompletedArray.append("08/05/2015")
//        fabricCompletedArray.append("08/04/2015")
//        fabricCompletedArray.append("08/03/2015")
//        fabricCompletedArray.append("08/02/2015")
//        fabricCompletedArray.append("08/01/2015")
//
//        
//        NSUserDefaults.standardUserDefaults().setObject(fabricCompletedArray, forKey: "fabricCompleted")
//    
//    }
    
    
    @IBAction func cancelFabrics(_ sender: UIButton) {
    
        MSAnalytics.trackEvent("Cancel event")
        
        // we're not running and need to pause
  
        let myImage = UIImage(named: "playButton")
        startStopTimerButton.setImage(myImage, for: UIControlState())
        startLabel.text = "Start"
        
        helpAboutButton.isEnabled = true
        
        stopTimer()
        
        // refresh the UI
        resetUI()
    }
    
    
    @IBAction func nextFabric(_ sender: UIButton) {
        
        MSAnalytics.trackEvent("Next Fabric event")

        prevButton.isEnabled = true
        
        // verify just in case
        if (currentFabricIndex < fabrics.count - 1) {
            
            // if we're currently running, keep going
            if (fabricTimer.isValid) {
                
                stopTimer()
                
                currentFabricIndex += 1
                progressView.numOfCompletedLines = currentFabricIndex + 1
                
                resetFabricDetails()
                
                startTimer()
                
            } else {
                
                currentFabricIndex += 1
                progressView.numOfCompletedLines = currentFabricIndex + 1
                
                resetFabricDetails()
                
            }
            
            if (currentFabricIndex == fabrics.count - 1) {
                
                // can't go no farther
                nextButton.isEnabled = false
                
            }
        
        }
        
    }
    
    
    
    @IBAction func prevButton(_ sender: UIButton) {

        MSAnalytics.trackEvent("Previous Fabric event")
        
        nextButton.isEnabled = true
        
        // verify just in case
        if (currentFabricIndex > 0) {
            
            // if we're currently running, keep going
            if (fabricTimer.isValid) {
                
                stopTimer()
                
                currentFabricIndex -= 1
                progressView.numOfCompletedLines = currentFabricIndex + 1
                
                resetFabricDetails()
                
                startTimer()
                
            } else {
                
                currentFabricIndex -= 1
                progressView.numOfCompletedLines = currentFabricIndex + 1
                
                resetFabricDetails()
                
            }
          
            if (currentFabricIndex == 0) {
                
                // can't go no farther
                prevButton.isEnabled = false
                
            }
            
        }
        
    }
    
    

    var fabricCounter: Int = 0
    var countdownTime: Int!
    var isPaused:Bool = false
    var elapsedTimePaused: Int!
    @IBAction func startPauseTimerAction(_ sender: UIButton) {
        
        startPauseTimer()
        
    }
    
    func startPauseTimer() {
//        printFabrics()
        
        // we're not running and need to start
        if !(fabricTimer.isValid) {
            
            MSAnalytics.trackEvent("Play event", withProperties: ["FabricCount": String(fabrics.count)])
            
            let myImage = UIImage(named: "pauseButton")
            startStopTimerButton.setImage(myImage, for: UIControlState())
            startLabel.text = "Pause"
            
            // no editing while running - can only do it from ResetUI (startover or finish fabric cycle)
            self.navigationController!.navigationBar.isUserInteractionEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGray
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGray
            
            // no getting info b/c alerts will show below the info screen
            helpAboutButton.isEnabled = false
            
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

            MSAnalytics.trackEvent("Pause event")
            
            // there is no pause on a NSTimer, so we kill timer and recreate
            isPaused = true
            
            let myImage = UIImage(named: "playButton")
            startStopTimerButton.setImage(myImage, for: UIControlState())
            startLabel.text = "Start"
            
            helpAboutButton.isEnabled = true
            
            // stop Timer and cancel the notifications
            stopTimer()
        
        }

    }
    
    func printFabrics() {
        
        for fabric in fabrics {
            print(fabric.fabricName)
            print(fabric.fabricTime)
            print("")
        }
        
        print("-----------------")
    }

    func resetFabricDetails() {

        let currentFabric = fabrics[currentFabricIndex]
  
        timeRemaining = currentFabric.fabricTime
        displayTimeLabel.text = "\(timeRemaining!)"
        
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
        startTime = Date()
        //println("Start time at...")
       // printDate(startTime)
       
        myStopTime = Date(timeIntervalSinceNow: TimeInterval(timeRemaining))
       // println("Stop time at...")
       // printDate(myStopTime)
        
        // this minuteTimer is ONLY used to display the timer countdown in the UI
        // so each second it will go from 9:59, 9:58, blah blah blah
        // the notification below is what stops this timer
        fabricTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(ViewController.updateFabricTime), userInfo: nil, repeats: true)
        
        // reset the skip
        skipBecauseUserDidNotTapNotification = false
        
        // schedule local notification
        let notification = UILocalNotification()
        notification.alertBody = "Time to switch fabrics!"
        notification.alertAction = "Next Fabric"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.fireDate = Date(timeIntervalSinceNow: TimeInterval(timeRemaining))
        UIApplication.shared.scheduleLocalNotification(notification)
        
        cancelButton.isEnabled = true
        
        // no more edits allowed
        self.navigationController!.navigationBar.isUserInteractionEnabled = false
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 255, alpha: 255)
        
    }
    
    func stopTimer() {
        fabricTimer.invalidate()
        UIApplication.shared.cancelAllLocalNotifications()
    
    }
    
    func resetUI() {
        
        currentFabricIndex = 0
        progressView.numOfLines = fabrics.count
        progressView.numOfCompletedLines = currentFabricIndex + 1
        
        if (fabrics.count == 0) {
        
            prevButton.isEnabled = false
            nextButton.isEnabled = false
            cancelButton.isEnabled = false
            startStopTimerButton.isEnabled = false
            
        } else if (fabrics.count == 1) {
          
            prevButton.isEnabled = false
            nextButton.isEnabled = false
            cancelButton.isEnabled = false
            startStopTimerButton.isEnabled = true
            
            
        } else {
            
            prevButton.isEnabled = false
            nextButton.isEnabled = true
            cancelButton.isEnabled = false

        }
        
        
        resetFabricDetails()
        
        let myImage = UIImage(named: "playButton")
        startStopTimerButton.setImage(myImage, for: UIControlState())
        startLabel.text = "Start"
        
        helpAboutButton.isEnabled = true
        
        // and can edit by default
        self.navigationController!.navigationBar.isUserInteractionEnabled = true
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1.0)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1.0)
        
    }
    
    // the actual NSTimer loop - this is only used to update the 0:59 text and nothing else
    var timeElapsed:Int = 0
    func updateFabricTime() {
        
        //Find the difference between current time and the original start time
        // if coming back from pause, add elapsedTimePaused; otherwise this is 0
        timeElapsed = Int(floor(Date().timeIntervalSince(startTime))) + elapsedTimePaused
        
        // current display time
        timeRemaining = timeRemaining - 1

        // update circle timer
        circleCounter.counter = timeElapsed
        circleCounter.NumOfSeconds = fabrics[currentFabricIndex].fabricTime
        
//        println("timeElapsed: \(timeElapsed)")
//        println("NumOfSeconds: \(fabrics[currentFabricIndex].fabricTime)")
//        println()
        
        displayTimeLabel.text = "\(timeRemaining!)"
        
    }
    
    func displayTime(_ label: UILabel, time: Int) {
        
        // UI prettiness because Apple can't give me a NSDate.Now.ToString()
        // gods I miss C#
        if (time > 9) {
            label.text = "0:\(time)"
            
        } else {
            label.text = "0:0\(time)"
            
        }
        
    }

    // for updating the overall progress view and button enablement
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        progressView.numOfLines = fabrics.count
        progressView.numOfCompletedLines = currentFabricIndex + 1
        
        // if we have fabrics in the list
        if (fabrics.count > 0) {

            fabricDisplayView.isHidden = false
            createFabricsList.isHidden = true
            
            resetFabricDetails()
            
            startStopTimerButton.isEnabled = true
        
            if (fabrics.count == 1) {

                prevButton.isEnabled = false
                nextButton.isEnabled = false
                
            } else if (currentFabricIndex == 0) {
                
                prevButton.isEnabled = false
                nextButton.isEnabled = true
            
            } else if (currentFabricIndex == fabrics.count - 2) {
                
                prevButton.isEnabled = true
                nextButton.isEnabled = false
                
            } else {
                
                prevButton.isEnabled = true
                nextButton.isEnabled = true

            }
            
        } else {
            
            // we don't have fabrics in the list
            startStopTimerButton.isEnabled = false
            prevButton.isEnabled = false
            nextButton.isEnabled = false
            
            fabricDisplayView.isHidden = true
            createFabricsList.isHidden = false

        }
        
        if (fabricTimer.isValid) {
            
            cancelButton.isEnabled = true
            
        } else {
            
            cancelButton.isEnabled = false
        }
        
        
    }
    
    // this is fired after every scheduled FabricTime interval via the notification service
    // this is fired regardless user taps notification or it comes while app is running
    func doSomethingForNow() {
        
        if !(skipBecauseUserDidNotTapNotification) {
        
            NSLog("I'm stopping the timer")
            _ = Date()
            
            //   NSLog("Stop Time:")
            // printDate(trueStopTime)
            
            stopTimer()

            // in case there was any paused time
            elapsedTimePaused = 0
            
            // start blasting the alarm
            alarmAudio.play()
            
            // continue to next Fabric or end
            currentFabricIndex += 1
            progressView.numOfCompletedLines = currentFabricIndex + 1
        
            prevButton.isEnabled = true
        
            if (currentFabricIndex == fabrics.count - 1) {
                nextButton.isEnabled = false
            }
            
            if (currentFabricIndex < fabrics.count) {
                
                // rock on
                showAlertAndWaitForUser("\(fabrics[currentFabricIndex - 1].fabricName) Done!", message: "Press OK to continue")
                
            } else {
                
                MSAnalytics.trackEvent("Session completed event", withProperties: ["FabricCount": String(fabrics.count)])
                
                showAlertToEnd("We're all done!", message: "Have a good one!")
            }

            
            // clear the notification
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
    

    func showAlertForNextFabric() {
        
        let alertController = UIAlertController(title: "\(fabrics[currentFabricIndex].fabricName) is up next", message:
            "Press OK to start next Fabric", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            action in
            
            self.startTimer()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    func showAlertAndWaitForUser(_ title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        
        // after the user dismisses the alert we can start the next 1 minute run
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            action in
     
            // refreshing the UI here so it doesn't appear behind the alert. Feels odd
            self.resetFabricDetails()
            
            // stop the alarm
            if (self.alarmAudio.isPlaying) {
                self.alarmAudio.stop()
                self.alarmAudio.currentTime = 0.0
            }
            
            self.showAlertForNextFabric()
     
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }

    func showAlertToEnd(_ title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        
        // after the user dismisses the alert we can start the next 1 minute run
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            action in
            
            // println("yo we've stopped the timer")
            
            // stop the alarm
            if (self.alarmAudio.isPlaying) {
                self.alarmAudio.stop()
                self.alarmAudio.currentTime = 0.0
            }
            
            // TODO: STATS: Here's where we will save
            // record that user has completed the fabric end-to-end
//            let date = NSDate()
//            let formatter = NSDateFormatter()
//            formatter.dateFormat = "MM/dd/yyyy"
//            let saveDate = formatter.stringFromDate(date)
//            
            // right now only save once a day
//            if !fabricCompletedArray.contains(saveDate) {
//                
//                fabricCompletedArray.append(saveDate)
//                NSUserDefaults.standardUserDefaults().setObject(fabricCompletedArray, forKey: "fabricCompleted")
//            }
            
            // we're all done
            self.resetUI()
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }

    

    func printDate(_ date:Date) {
        let formatter = DateFormatter();
        formatter.dateFormat = "HH:mm:ss";
//        let defaultTimeZoneStr = formatter.stringFromDate(date);
        
       // NSLog(defaultTimeZoneStr);
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // cut and pasted from SO
    func setupAudioPlayerWithFile(_ file:NSString, type:NSString) -> AVAudioPlayer  {
        let path = Bundle.main.path(forResource: file as String, ofType: type as String)
        let url = URL(fileURLWithPath: path!)
        
        var audioPlayer:AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            audioPlayer = nil
        }
        
        return audioPlayer!
    }

}

