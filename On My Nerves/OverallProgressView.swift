//
//  OverallProgressView.swift
//  On My Nerves
//
//  Created by Sara Ford on 8/23/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit
//@IBDesignable
class OverallProgressView: UIView {
    
    @IBInspectable var numOfLines:Int = 4 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var numOfCompletedLines:Int = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable var completedColor: UIColor = UIColor.grayColor()
    @IBInspectable var stillToGoColor: UIColor = UIColor.redColor()
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        drawOverallProgress()
        
    }
    
    
    func drawOverallProgress() {
        
        let context = UIGraphicsGetCurrentContext()
//        var width:CGFloat = bounds.width
        
        // line width
        CGContextSetLineWidth(context, 20.0)
        
        // setup color
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // the height of the container
        var height:Float = Float(bounds.height)
        
        if (numOfLines == 1) {
            
             CGContextSetStrokeColorWithColor(context, stillToGoColor.CGColor)
            
            drawLine(CGFloat(0.0), endPoint: CGFloat(height), context: context)
            
            
        } else if (numOfLines > 1) {
            
            var div: Float = height * 0.01
            var numOfDivs:Float = Float(numOfLines - 1)
            
            // get the length of each line
            var length:Float = (height - (div * Float(numOfDivs))) / Float(numOfLines)
            
            for (var i:Int = 0; i < numOfLines; i++) {
                
                // starting point
                var startPoint = CGFloat(Float(i) * (length + div))
                var endPoint = startPoint + CGFloat(length)
                
                if (i <= numOfCompletedLines - 1) {

                    CGContextSetStrokeColorWithColor(context, completedColor.CGColor)

                } else {
                    
                    CGContextSetStrokeColorWithColor(context, stillToGoColor.CGColor)
                    
                }
                
                
                
                drawLine(startPoint, endPoint: endPoint, context: context)
                
            }
            
        }
        
    }
    
    func drawLine(startPoint:CGFloat, endPoint:CGFloat, context:CGContext) {
        
        // the drawing
        CGContextMoveToPoint(context, 0, startPoint)
        CGContextAddLineToPoint(context, 0, endPoint)
        
        // draw the line
        CGContextStrokePath(context)
        
    }
    
}








