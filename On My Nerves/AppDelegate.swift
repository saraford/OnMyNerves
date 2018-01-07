//
//  AppDelegate.swift
//  On My Nerves
//
//  Created by Sara Ford on 7/31/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit
import AVFoundation
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        // grab AppCenter AppSecret
//        var keys: NSDictionary?
//        var appCenterSecret: String = ""
//        
//        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
//            keys = NSDictionary(contentsOfFile: path)
//            appCenterSecret = keys!["AppCenterSecret"] as! String
//        }
        
        MSAppCenter.start("d104aeec-06d6-468c-82fa-238aa9d8ae17", withServices:[
            MSAnalytics.self,
            MSCrashes.self
            ])
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [UIUserNotificationType.sound, UIUserNotificationType.alert] , categories: nil))
        
        do {
            // AVAudioSessionCategoryPlayback is needed to play if on silent
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }

        
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "FabricSwitch"), object: self)
        NotificationCenter.default.addObserver(self, selector: Selector("resetToDefaults"), name: NSNotification.Name(rawValue: "Terminating"), object: nil)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Terminating"), object: self)
    }
    
}

