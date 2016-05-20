//
//  CIndicatorView.swift
//  CIndicator
//
//  Created by AUK on 17/05/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import UIKit
import QuartzCore

extension Int {
    var degreesToRadians: Double { return Double(self) * M_PI / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / M_PI }
}

extension Double {
    var degreesToRadians: Double { return self * M_PI / 180 }
    var radiansToDegrees: Double { return self * 180 / M_PI }
}

extension CGFloat {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * M_PI / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / M_PI) }
}

extension Float  {
    var doubleValue:      Double { return Double(self) }
    var degreesToRadians: Float  { return Float(doubleValue * M_PI / 180) }
    var radiansToDegrees: Float  { return Float(doubleValue * 180 / M_PI) }
}

class CIndicatorView: UIView {
    let superLayer: CALayer = CALayer()
    var ringsArray : [CALayer] = [];
    var layerIndex: Int = 0;

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.ringsArray = [CALayer(),CALayer(),CALayer(),CALayer(),CALayer()];
//        self.ringsArray = [CALayer()];

        self.superLayer.backgroundColor = UIColor.whiteColor().CGColor
        self.superLayer.masksToBounds = false;

        self.layer.addSublayer(self.superLayer);
        for (index,layer) in self.ringsArray.enumerate() {
            self.superLayer.addSublayer(layer)
            layer.delegate = self;
            layer.backgroundColor = UIColor.clearColor().CGColor
            layer.masksToBounds = false;
            layer.rasterizationScale = 2.0 * UIScreen.mainScreen().scale;
            layer.shouldRasterize = true;
            layer.setNeedsDisplay();
            layer.timeOffset = Double(150*index)
            layer.addAnimation(defineAnimation(index), forKey: "group")
            
        }


    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.superLayer.frame = self.bounds;
        
        for (index, layer) in self.ringsArray.enumerate() {
            let offset: CGFloat = CGFloat(index) * 30
            layer.frame = CGRectMake(offset/2, offset/2, self.superLayer.bounds.size.width-offset, self.superLayer.bounds.size.height-offset);
//            layer.frame = CGRectMake(16, 16, 68, 68);
            print(offset,  layer.frame);

        }

    }

    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.orangeColor().CGColor)
        CGContextSetLineWidth(context, 0)
        
        var max_ringRadius: CGFloat  = 0.0;
        let circleRadius: CGFloat = layer.bounds.size.width/2;
        let divisions = 20/(5-self.layerIndex);
        max_ringRadius = CGFloat(M_PI)*circleRadius/CGFloat(divisions)
        max_ringRadius = max_ringRadius>5.0 ? 5.0 : max_ringRadius;
        var angle = 0.0;
        
        for i in 1...divisions {
            angle = (2*M_PI/Double(divisions))*Double(i)
            let x = circleRadius*CGFloat(sin(angle)) + circleRadius
            let y = circleRadius*CGFloat(cos(angle)) + circleRadius
            print("X: ",x , "Y: ",y , "Angle: ",angle, "max_ringRadius: ", fabs(max_ringRadius*CGFloat(sin(angle))));
            CGContextAddArc(context, x, y, max(fabs(max_ringRadius*CGFloat(sin(angle))), 2.0), 0, CGFloat(2*M_PI), 1);
            CGContextDrawPath(context, .FillStroke)
        }
        UIGraphicsPopContext()
        self.layerIndex = self.layerIndex+1;
    }
    
    func defineAnimation(index: Int) -> CAAnimationGroup  {
    // Define rotation on z axis
        let degreesVariance: CGFloat  = 180;
    // object will always take shortest path, so that
    // a rotation of less than 180 deg will move clockwise, and more than will move counterclockwise
        let radiansToRotate: CGFloat  = degreesVariance.degreesToRadians;
        //var zRotation: CATransform3D ;
    //zRotation = CATransform3DMakeRotation(radiansToRotate, 0, 0, 1.0);
    // create an animation to hold "zRotation" transform
        var animateZRotation: CABasicAnimation;
    animateZRotation = CABasicAnimation(keyPath: "transform");
    // Assign "zRotation" to animation
    animateZRotation.toValue = NSValue(CATransform3D: CATransform3DMakeRotation(radiansToRotate, 0, 0, 1.0));
    // Duration, repeat count, etc
    animateZRotation.duration = 1.0;//change this depending on your animation needs
    // Here set cumulative, repeatCount, kCAFillMode, and others found in
    // the CABasicAnimation Class Reference.
        animateZRotation.repeatCount = .infinity;
        animateZRotation.autoreverses = true;
        
        var animateScale: CABasicAnimation;
        animateScale = CABasicAnimation(keyPath: "transform.scale");
        // Assign "zRotation" to animation
        animateScale.toValue = NSValue(CATransform3D: CATransform3DMakeScale(0.5, 0.5, 1));
        // Duration, repeat count, etc
        animateScale.duration = 1.0;//change this depending on your animation needs
        // Here set cumulative, repeatCount, kCAFillMode, and others found in
        // the CABasicAnimation Class Reference.
        animateScale.repeatCount = .infinity;
        animateScale.autoreverses = true;
        
        var animateAlpha: CABasicAnimation;
        animateAlpha = CABasicAnimation(keyPath: "opacity");
        // Assign "zRotation" to animation
//        animateAlpha.toValue = 0.8;
        animateAlpha.fromValue = NSNumber(double: 1.0);
        animateAlpha.toValue = NSNumber(double: 0.2);
        // Duration, repeat count, etc
        animateAlpha.duration = 1.0;//change this depending on your animation needs
        // Here set cumulative, repeatCount, kCAFillMode, and others found in
        // the CABasicAnimation Class Reference.
        animateAlpha.repeatCount = .infinity;
        animateAlpha.autoreverses = true;
        
        let groupAnimation = CAAnimationGroup();
        groupAnimation.animations = [animateZRotation, animateScale, animateAlpha];
        groupAnimation.removedOnCompletion = false;
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        groupAnimation.fillMode = kCAFillModeBackwards;
        groupAnimation.repeatDuration = CFTimeInterval.infinity
        groupAnimation.duration = 2.0
        groupAnimation.autoreverses = true;
        groupAnimation.beginTime = CACurrentMediaTime() + 0.1*Double(index)

    return groupAnimation;
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
