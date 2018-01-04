//
//  PieChartView.swift
//  On My Nerves
//
//  Created by Sara Ford on 9/4/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import Foundation
import UIKit

//@IBDesignable 
class PieChartView: UIView {
    
    let fullCircle: CGFloat = 2 * π
    
    
    
    var completedPercentage:CGFloat = 0.0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    var toBeCompletedColor = UIColor.cyan
    var completedColor = UIColor.blue
    
    override func draw(_ rect: CGRect) {

        // draw an entire circle to represent the porportion not completed
        drawCircle(fullCircle, color: toBeCompletedColor)
        
        // draw another circle to represent how much was completed
        let partialCircle: CGFloat = fullCircle * CGFloat(completedPercentage)
        drawCircle(partialCircle, color: completedColor)
        
    }
    
    func drawCircle(_ endAngle:CGFloat, color:UIColor) {
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height) / 2
        let startAngle: CGFloat = 0
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.move(to: CGPoint(x: center.x, y: center.y))
        //CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0)
        context?.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true);
        context?.fillPath()
        
        
    }
    
}
