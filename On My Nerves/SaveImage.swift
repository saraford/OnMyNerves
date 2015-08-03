//
//  SaveImage.swift
//  On My Nerves
//
//  Created by Sara Ford on 8/2/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import Foundation
import UIKit

class SaveImage {
    
    // storing images
    class func storeImage(image: UIImage, name : String) {
        var documentsDirectory:String? // initially empty
        
        // how to find the location of the documents directory and saving a file in it
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        // if valid path
        if paths.count > 0 {
            
            // save in the first (and probably only) directory
            documentsDirectory = paths[0] as? String
            
            // of course you need to add a '/'
            var savePath = documentsDirectory! + "/" + name + ".jpg"
            
            let imgRep = UIImageJPEGRepresentation(image, 100)
            let imageData = NSData(data: imgRep)
            
            let result = imageData.writeToFile(savePath, atomically: true)
            
            println(result)
        }
    }
    
    class func imageDirPath() -> String {
        var documentsDirectory:String? // initially empty
        
        // how to find the location of the documents directory and saving a file in it
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)

        // save in the first (and probably only) directory
        documentsDirectory = paths[0] as? String

        return documentsDirectory! + "/"
    }
    
    
    
//    // are there any image on disk
//    class func AreImagesOnDisk() -> Bool {
//        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
//        
//        var imagePath = paths.stringByAppendingPathComponent("/image0.jpg")
//        
//        return NSFileManager.defaultManager().fileExistsAtPath(imagePath)
//        
//    }
    
    
//    // retrieving images
//    class func retrieveImage(imageName : String) -> UIImage {
//        
//        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
//        
//        var imagePath = paths.stringByAppendingPathComponent("/\(imageName).jpg")
//
//        return UIImage(named: imagePath)!
//        
////        if (NSFileManager.defaultManager().fileExistsAtPath(imagePath))
////        {
////            
////        }
//    }
    
    
    // resorting images
    class func moveImages(imageList : [UIImage], fromIndex : Int, toIndex : Int) {
        
        
//        var nameToMove = imageList[fromIndex]
//        
//        imageList.removeAtIndex(fromIndex)
//        
//
//        imageList.insert(nameToMove, atIndex: toIndexPath.row)
    
    }
    
    

    
    
    
}