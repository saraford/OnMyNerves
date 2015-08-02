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
    class func storeImage(image: UIImage, index: Int) {
        var documentsDirectory:String? // initially empty
        
        // how to find the location of the documents directory and saving a file in it
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        if paths.count > 0 {
            
            // save in the first (and probably only) directory
            documentsDirectory = paths[0] as? String
            
            var savePath = documentsDirectory! + "/image\(index).jpg" // of course you need to add a '/'
            
            let imgRep = UIImageJPEGRepresentation(image, 100)
            let imageData = NSData(data: imgRep)
            
            let result = imageData.writeToFile(savePath, atomically: true)
            
            println(result)
        }
    }
    
    // are there any image on disk
    class func AreImagesOnDisk() -> Bool {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        var imagePath = paths.stringByAppendingPathComponent("/image0.jpg")
        
        return NSFileManager.defaultManager().fileExistsAtPath(imagePath)
        
    }
    
    
    // retrieving images
    class func retrieveImage(imageList : [UIImage], count : Int) {
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        var i: Int
        for i = 0; i < count; i++ {
            
            var imagePath = paths.stringByAppendingPathComponent("/image\(i).jpg")
            
            if (NSFileManager.defaultManager().fileExistsAtPath(imagePath))
            {
                fabricImageList.append(UIImage(named: imagePath)!)
            }
            else
            {
                NSLog("couldn't find file")
            }

        }
        
    }
    
    
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