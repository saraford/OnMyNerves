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
    
    
    @IBInspectable var completedColor: UIColor = UIColor.gray
    @IBInspectable var stillToGoColor: UIColor = UIColor.red
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        drawOverallProgress()
        
    }
    
    func drawOverallProgress() {
        
        let context = UIGraphicsGetCurrentContext()
        
        // line width
        context?.setLineWidth(20.0)
        
        // the height of the container
        let height:Float = Float(bounds.height)
        
        if (numOfLines == 1) {
            
             context?.setStrokeColor(stillToGoColor.cgColor)
            
            drawLine(CGFloat(0.0), endPoint: CGFloat(height), context: context!)
            
            
        } else if (numOfLines > 1) {
            
            let div: Float = height * 0.01
            let numOfDivs:Float = Float(numOfLines - 1)
            
            // get the length of each line
            let length:Float = (height - (div * Float(numOfDivs))) / Float(numOfLines)
            
            for var i in (0 ..< numOfLines) {
                
                // starting point
                let startPoint = CGFloat(Float(i) * (length + div))
                let endPoint = startPoint + CGFloat(length)
                
                if (i <= numOfCompletedLines - 1) {

                    context?.setStrokeColor(completedColor.cgColor)

                } else {
                    
                    context?.setStrokeColor(stillToGoColor.cgColor)
                    
                }
            
                drawLine(startPoint, endPoint: endPoint, context: context!)
                
            }
            
        }
        
    }
    
    func drawLine(_ startPoint:CGFloat, endPoint:CGFloat, context:CGContext) {
        
        // the drawing
        context.move(to: CGPoint(x: 0, y: startPoint))
        context.addLine(to: CGPoint(x: 0, y: endPoint))
        
        // draw the line
        context.strokePath()
        
    }
    
}








