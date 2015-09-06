//
//  PieChartView.swift
//  On My Nerves
//
//  Created by Sara Ford on 9/4/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class PieChartView: UIView {
    
    var completedPercentage:CGFloat = 0.0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    var completedColor = UIColor.blueColor()
    
    override func drawRect(rect: CGRect) {
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        let radius: CGFloat = max(bounds.width, bounds.height) / 2
        
        let startAngle: CGFloat = 0
        let fullCircle: CGFloat = 2 * π
        let endAngle: CGFloat = fullCircle * CGFloat(completedPercentage)
        
        let context = UIGraphicsGetCurrentContext()
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        CGContextSetFillColorWithColor(context, completedColor.CGColor)
        CGContextMoveToPoint(context, center.x, center.y)
        CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0)
        CGContextFillPath(context)
        
    }
    
}
