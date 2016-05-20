//
//  CRingView.swift
//  CIndicator
//
//  Created by AUK on 18/05/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import UIKit

class CRingView: CALayer {
    
    override func drawInContext(ctx: CGContext) {
        super.drawInContext(ctx);
        
        UIGraphicsPushContext(ctx)
        let context = UIGraphicsGetCurrentContext()
        let rectangle = self.bounds
        
        CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextSetLineWidth(context, 10)
        
        CGContextAddEllipseInRect(context, rectangle)
        CGContextDrawPath(context, .FillStroke)
        
        UIGraphicsPopContext()
    }
    
    
}
