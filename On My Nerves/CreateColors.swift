//
//  CreateColors.swift
//  On My Nerves
//
//  Created by Sara Ford on 8/16/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import Foundation
import UIKit

class CreateColors {
    
    static func createImageFromColor(desiredColor:String) -> UIImage {

        var color:UIColor = createColor(desiredColor)
        
        return createImage(color)
    }
    
    static func createColor(desiredColor:String) -> UIColor {
        
        var color:UIColor!
        
        if (desiredColor == "Red") {
            
            color = UIColor(red: 1, green: 0, blue: 0, alpha: 255)
            
        } else if (desiredColor == "Sandpaper") {
            
            color = UIColor(red: 245/255, green: 128/255, blue: 2/255, alpha: 255)
            
        } else if (desiredColor == "Green") {
            
            color = UIColor(red: 0, green: 1, blue: 0, alpha: 255)
            
        } else if (desiredColor == "Blue") {
            
            color = UIColor(red: 0, green: 0, blue: 1, alpha: 255)

        }

        else if (desiredColor == "Black") {
            
            color = UIColor(red: 0, green: 0, blue: 0, alpha: 255)
            
        }
        
        else if (desiredColor == "White") {
            
            color = UIColor(red: 1, green: 1, blue: 0, alpha: 255)
            
        }
        

        return color

    }
    
        
    static private func createImage(color: UIColor) -> UIImage {
        
        var size = CGSize(width: 100, height: 100)
        
        let rect = CGRectMake(0, 0, 100, 100)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        color.setFill()
        
        UIRectFill(rect)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    
}