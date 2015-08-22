//
//  CircleCounterView.swift
//  On My Nerves
//
//  Created by Sara Ford on 8/22/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

// Yes, thank you http://www.raywenderlich.com/90690/modern-core-graphics-with-swift-part-1

import UIKit

let π:CGFloat = CGFloat(M_PI)

@IBDesignable class CircleCounterView: UIView {

    // some random default
   @IBInspectable var NumOfSeconds:Int = 5
    
    @IBInspectable var counter: Int = 1 {
        didSet {
            if counter <=  NumOfSeconds {
                //the view needs to be refreshed
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
    @IBInspectable var counterColor: UIColor = UIColor.orangeColor()
    
    override func drawRect(rect: CGRect) {
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        let arcWidth: CGFloat = 30
        
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * π
        
        var path = UIBezierPath(arcCenter: center,
            radius: radius/2 - arcWidth/2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        
        path.lineWidth = arcWidth
        counterColor.setStroke()
        path.stroke()
        
        //Draw the timer

        let startAngleTimer: CGFloat = 0
        let timerLengthPerSecond: CGFloat = (2.0 * π) / CGFloat(NumOfSeconds)
        let endAngleTimer: CGFloat = timerLengthPerSecond * CGFloat(counter)

        var pathTimer = UIBezierPath(arcCenter: center,
            radius: radius/2 - arcWidth/2,
            startAngle: startAngle,
            endAngle: endAngleTimer,
            clockwise: true)
        
         pathTimer.lineWidth = arcWidth
         outlineColor.setStroke()
         pathTimer.stroke()
        
    }
}
