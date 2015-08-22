//
//  Fabric.swift
//  On My Nerves
//
//  Created by Sara Ford on 8/2/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import Foundation
import UIKit

class Fabric {
    
    var fabricName: String = ""
    var fabricTime: Int = 0
    var fabricColor: String = ""

//    func saveImage(image: UIImage) {
//        
//        var filename = createUniqueImageFilename()
//        fabricImageName = filename
//
//        var documentsDirectory:String? // initially empty
//        var savePath: String = ""
//        
//        // how to find the location of the documents directory and saving a file in it
//        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//        
//        // save in the first (and probably only) directory
//        documentsDirectory = paths[0] as? String
//        
//        // of course you need to add a '/'
//        savePath = documentsDirectory! + "/" + filename
//        
//        let imgRep = UIImageJPEGRepresentation(image, 100)
//        let imageData = NSData(data: imgRep)
//        
//        let result = imageData.writeToFile(savePath, atomically: true)
//
//        if (!result) {
//            println("Error writing image to disk \(result)")
//        }
//        
////        var data = NSData(contentsOfFile: savePath)
////        var image = UIImage(data: data!)
//       
//    }
//    
//    func deleteImage() {
//        var documentsDirectory:String? // initially empty
//        
//        // how to find the location of the documents directory and saving a file in it
//        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//        
//        documentsDirectory = paths[0] as? String
//        
//        // of course you need to add a '/'
//        var deletePath = documentsDirectory! + "/" + self.fabricImageName
//        
//        let fileMgr = NSFileManager.defaultManager()
//        
//        var error: NSError?
//        if !fileMgr.removeItemAtPath(deletePath, error: &error) {
//            println("Error deleting file. \(error)")
//        }
//        
//    }
//    
//    func imageDirPath() -> String {
//        var documentsDirectory:String? // initially empty
//        
//        // how to find the location of the documents directory and saving a file in it
//        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//        
//        // save in the first (and probably only) directory
//        documentsDirectory = paths[0] as? String
//        
//        return documentsDirectory! + "/"
//    }
//    
//    // retrieving images
//    func retrieveImage() -> UIImage {
//        
//        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
//        var imagePath = paths.stringByAppendingPathComponent(fabricImageName)
//        
//        var data = NSData(contentsOfFile: imagePath)
//        var image = UIImage(data: data!)
//        
//        return UIImage(named: imagePath)!
//    }
//    
//    
//    // resorting images
//    class func moveImages(imageList : [UIImage], fromIndex : Int, toIndex : Int) {
//        
//        
//        //        var nameToMove = imageList[fromIndex]
//        //        
//        //        imageList.removeAtIndex(fromIndex)
//        //        
//        //
//        //        imageList.insert(nameToMove, atIndex: toIndexPath.row)
//        
//    }
//
//    
//    private func createUniqueImageFilename() -> String {
//        
//        let len = 10
//        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        
//        var randomString : NSMutableString = NSMutableString(capacity: len)
//        
//        for (var i=0; i < len; i++){
//            var length = UInt32 (letters.length)
//            var rand = arc4random_uniform(length)
//            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
//        }
//        
//        return (randomString as String) + ".jpg"
//        
//    }

    
}
