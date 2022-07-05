//
//  CircularSlider+Draw.swift
//  Pods
//
//  Created by Hamza Ghazouani on 21/10/2016.
//
//

import UIKit

extension CircularSlider {
    
    /**
     Draw arc with stroke mode (Stroke) or Disk (Fill) or both (FillStroke) mode
     FillStroke used by default
     
     - parameter arc:           the arc coordinates (origin, radius, start angle, end angle)
     - parameter lineWidth:     the with of the circle line (optional) by default 2px
     - parameter mode:          the mode of the path drawing (optional) by default FillStroke
     - parameter context:       the context
     
     */
    internal static func drawArc(withArc arc: Arc, lineWidth: CGFloat = 2, mode: CGPathDrawingMode = .fillStroke, inContext context: CGContext) {
        
        let circle = arc.circle
        let origin = circle.origin
        
        UIGraphicsPushContext(context)
        context.beginPath()
        
        context.setLineWidth(lineWidth)
        context.setLineCap(CGLineCap.round)
        context.addArc(center: origin, radius: circle.radius, startAngle: arc.startAngle, endAngle: arc.endAngle, clockwise: false)
        context.move(to: CGPoint(x: origin.x, y: origin.y))
        context.drawPath(using: mode)
        
        UIGraphicsPopContext()
    }
    
    /**
     Draw disk using arc coordinates
     
     - parameter arc:     the arc coordinates (origin, radius, start angle, end angle)
     - parameter context: the context
     */
    internal static func drawDisk(withArc arc: Arc, inContext context: CGContext) {

        let circle = arc.circle
        let origin = circle.origin

        UIGraphicsPushContext(context)
        context.beginPath()

        context.setLineWidth(0)
        context.addArc(center: origin, radius: circle.radius, startAngle: arc.startAngle, endAngle: arc.endAngle, clockwise: false)
        context.addLine(to: CGPoint(x: origin.x, y: origin.y))
        context.drawPath(using: .fill)

        UIGraphicsPopContext()
    }

    // MARK: drawing instance methods

    /// Draw the circular slider
    internal func drawCircularSlider(inContext context: CGContext) {
        diskColor.setFill()
        trackColor.setStroke()

        let circle = Circle(origin: bounds.center, radius: self.radius)
        let sliderArc = Arc(circle: circle, startAngle: CircularSliderHelper.circleMinValue, endAngle: CircularSliderHelper.circleMaxValue)
        CircularSlider.drawArc(withArc: sliderArc, lineWidth: backtrackLineWidth, inContext: context)
    }

    /// draw Filled arc between start an end angles
    internal func drawFilledArc(fromAngle startAngle: CGFloat, toAngle endAngle: CGFloat, inContext context: CGContext) {
        diskFillColor.setFill()
        trackFillColor.setStroke()

        let circle = Circle(origin: bounds.center, radius: self.radius)
        let arc = Arc(circle: circle, startAngle: startAngle, endAngle: endAngle)
        
        // fill Arc
        CircularSlider.drawDisk(withArc: arc, inContext: context)
        // stroke Arc
        CircularSlider.drawArc(withArc: arc, lineWidth: lineWidth, mode: .stroke, inContext: context)
    }

    internal func drawShadowArc(fromAngle startAngle: CGFloat, toAngle endAngle: CGFloat, inContext context: CGContext) {
        trackShadowColor.setStroke()

        let origin = CGPoint(x: bounds.center.x + trackShadowOffset.x, y: bounds.center.y + trackShadowOffset.y)
        let circle = Circle(origin: origin, radius: self.radius)
        let arc = Arc(circle: circle, startAngle: startAngle, endAngle: endAngle)

        // stroke Arc
        CircularSlider.drawArc(withArc: arc, lineWidth: lineWidth, mode: .stroke, inContext: context)
    }

    /**
     Draw the thumb and return the coordinates of its center
     
     - parameter angle:   the angle of the point in the main circle
     - parameter image:   the image of the thumb, if it's nil we use a disk (circle), the default value is nil
     - parameter context: the context
     
     - returns: return the origin point of the thumb
     */
    @discardableResult
    internal func drawThumbAt(_ angle: CGFloat, with image: UIImage? = nil, inContext context: CGContext) -> CGPoint {
        let circle = Circle(origin: bounds.center, radius: self.radius + self.thumbOffset)
        let thumbOrigin = CircularSliderHelper.endPoint(fromCircle: circle, angle: angle)
        
        if let image = image {
            return drawThumb(withImage: image,
                             thumbOrigin: thumbOrigin,
                             center: bounds.center,
                             angle: angle,
                             inContext: context)
        }
        
        // Draw a disk as thumb
        let thumbCircle = Circle(origin: thumbOrigin, radius: thumbRadius)
        let thumbArc = Arc(circle: thumbCircle, startAngle: CircularSliderHelper.circleMinValue, endAngle: CircularSliderHelper.circleMaxValue)

        CircularSlider.drawArc(withArc: thumbArc, lineWidth: thumbLineWidth, inContext: context)
        return thumbOrigin
    }

    /**
     Draw thumb using image and return the coordinates of its center

     - parameter image:   the image of the thumb
     - parameter angle:   the angle of the point in the main circle
     - parameter context: the context
     
     - returns: return the origin point of the thumb
     */
    @discardableResult
    private func drawThumb(withImage image: UIImage, thumbOrigin: CGPoint, center: CGPoint, angle: CGFloat, inContext context: CGContext) -> CGPoint {
        UIGraphicsPushContext(context)
        context.beginPath()
        let imageSize = image.size
        let imageFrame = CGRect(x: thumbOrigin.x - (imageSize.width / 2),
                                y: thumbOrigin.y - (imageSize.height / 2),
                                width: imageSize.width,
                                height: imageSize.height)
        
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        

        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            
//            ctx.fill(CGRect(x: 1, y: 1, width: 30, height: 30))
            
            image.draw(in: imageFrame)
//            ctx.cgContext.rotate(by: angle + .pi / 2)
            // awesome drawing code
        }

//        let newImage = renderer.image { (context) in
//            context.stroke(renderer.format.bounds)
//            context.fill(CGRect(x: 1, y: 1, width: 140, height: 140))
//        }

//        context.translateBy(x: center.x / 2, y: center.y)
////
//        context.rotate(by: angle + .pi / 2)
////
//        context.translateBy(x: imageFrame.size.width * -0.5, y: imageFrame.size.height * -0.5)

//        image.draw(at: thumbOrigin)
        img.draw(in: imageFrame)
        
        UIGraphicsPopContext()

        return thumbOrigin
    }
    
//    -(UIImage*)rotateImage:(UIImage*)img forAngle:(CGFloat)radian   {
//
//        UIView *rotatedViewBox = [[UIView alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
//        CGAffineTransform t = CGAffineTransformMakeRotation(radian);
//        rotatedViewBox.transform = t;
//        CGSize rotatedSize = rotatedViewBox.frame.size;
//
//        UIGraphicsBeginImageContext(rotatedSize);
//
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextTranslateCTM(context, rotatedSize.width, rotatedSize.height);
//        CGContextRotateCTM(context, radian);
//        CGContextScaleCTM(context, 1.0, -1.0);
//
//        CGContextDrawImage(context, CGRectMake(-img.size.width, -img.size.height, img.size.width, img.size.height), img.CGImage);
//        UIImage *returnImg = UIGraphicsGetImageFromCurrentImageContext();
//
//        UIGraphicsEndImageContext();
//        return returnImg;
//    }

}

extension UIImage {
    func putImage(image: UIImage, on rect: CGRect, angle: CGFloat = 0.0) -> UIImage{

        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(drawRect.size, false, 1.0)

        // Start drawing self
        self.draw(in: drawRect)

        // Drawing new image on top
        let context = UIGraphicsGetCurrentContext()!

        // Get the center of new image
        let center = CGPoint(x: rect.midX, y: rect.midY)

        // Set center of image as context action point, so rotation works right
        context.translateBy(x: center.x, y: center.y)
        context.saveGState()

        // Rotate the context
        context.rotate(by: angle)

        // Context origin is image's center. So should draw image on point on origin
        image.draw(in: CGRect(origin: CGPoint(x: -rect.size.width/2, y: -rect.size.height/2), size: rect.size), blendMode: .normal, alpha:
1.0)

        // Go back to context original state.
        context.restoreGState()

        // Get new image
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }

}
