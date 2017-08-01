import Foundation
import UIKit


public class MyDoodleCanvas : UIImageView {
    
    let pi = CGFloat(Double.pi)
    
    let forceSensitivity: CGFloat = 4.0
    var pencilTexture = UIColor(patternImage: UIImage(named: "PencilTexture")!)
    let minLineWidth: CGFloat = 5
    
    // current drawing rect
    var minX = 0
    var minY = 0
    var maxX = 0
    var maxY = 0
    
    var trackTimer : Timer?
    var lastTouchTimestamp : TimeInterval?
    var ocrImageRect : CGRect?
    var currentTextRect : CGRect?
    
    let defaultLineWidth:CGFloat = 6
    var markerColor: UIColor = UIColor.green
    
    var eraserColor: UIColor {
        return backgroundColor ?? UIColor.white
    }
    
    var context : CGContext?
    
    public func setup () {
        
        resetDoodleRect()
        
        lastTouchTimestamp = 0
        
        if #available(iOS 10.0, *) {
            trackTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {
                timer in
                
                let now = Date().timeIntervalSince1970
                
                if Int(self.lastTouchTimestamp!) > 0 && now - self.lastTouchTimestamp! > 1 {
                    self.drawDoodlingRect(context: self.context)
                }
            })
        } else {}
        
    }
    
    func resetDoodleRect() {
        minX = Int(self.frame.width)
        minY = Int(self.frame.height)
        
        maxX = 0
        maxY = 0
        
        lastTouchTimestamp = 0
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        context = UIGraphicsGetCurrentContext()
    }
    
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        
        minX = min(minX, Int(location.x))
        minY = min(minY, Int(location.y))
        maxX = max(maxX, Int(location.x))
        maxY = max(maxY, Int(location.y))
        
        lastTouchTimestamp = Date().timeIntervalSince1970
        
        // Draw previous image into context
        image?.draw(in: bounds)
        
        
        var touches = [UITouch]()
        if let coalescedTouches = event?.coalescedTouches(for: touch) {
            touches = coalescedTouches
        } else {
            touches.append(touch)
        }
        
        for touch in touches {
            drawStroke(context: context, touch: touch)
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func drawStroke(context: CGContext?, touch: UITouch) {
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)
        
        // Calculate line width for drawing stroke
        var lineWidth : CGFloat = 1.0
        let tiltThreshold : CGFloat = pi/6
        
        if touch.type == .stylus {
            if touch.altitudeAngle < tiltThreshold {
                lineWidth = lineWidthForShading(context: context, touch: touch)
            } else {
                lineWidth = lineWidthForDrawing(context: context, touch: touch)
            }
            
            pencilTexture.setStroke()
        } else {
            lineWidth = touch.majorRadius / 2
            eraserColor.setStroke()
        }
        
        UIColor.darkGray.setStroke()
        
        context!.setLineWidth(lineWidth)
        context!.setLineCap(.round)
        
        context?.move(to: previousLocation)
        context?.addLine(to: location)
        
        // Draw the stroke
        context!.strokePath()
        
    }
    
    func drawDoodlingRect(context: CGContext?) {
        let inset = 5
        
        markerColor.setStroke()
        context!.setLineWidth(1.0)
        context!.setLineCap(.round)
        UIColor.clear.setFill()
        
        ocrImageRect = CGRect(x: minX - inset, y: minY - inset, width: (maxX-minX) + inset*2, height: (maxY-minY) + 2*inset)
        context!.addRect(ocrImageRect!)
        // Draw the stroke
        context!.strokePath()
        
        drawTextRect(context: context, rect: ocrImageRect!)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        fetchOCRText()
        
        resetDoodleRect()
    }
    
    func drawTextRect(context: CGContext?, rect: CGRect) {
        UIColor.lightGray.setStroke()
        currentTextRect = CGRect(x: rect.origin.x, y: rect.origin.y + rect.height, width: rect.width, height: 15)
        context!.addRect(currentTextRect!)
        context!.strokePath()
    }
    
    func addLabelForOCR(text: String) {
        DispatchQueue.main.async {
            let label = UILabel(frame: self.currentTextRect!)
            label.text = text.characters.count > 0 ? text : "Text not recognized"
            label.font = UIFont(name: "Helvetica Neue", size: 9)
            self.addSubview(label)
        }
    }
    
    func lineWidthForShading(context: CGContext?, touch: UITouch) -> CGFloat {
        
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)
        
        let vector1 = touch.azimuthUnitVector(in: self)
        
        let vector2 = CGPoint(x: location.x - previousLocation.x, y: location.y - previousLocation.y)
        
        var angle = abs(atan2(vector2.y, vector2.x) - atan2(vector1.dy, vector1.dx))
        
        if angle > pi {
            angle = 2 * pi - angle
        }
        if angle > pi / 2 {
            angle = pi - angle
        }
        
        let minAngle: CGFloat = 0
        let maxAngle = pi / 2
        let normalizedAngle = (angle - minAngle) / (maxAngle - minAngle)
        
        let maxLineWidth: CGFloat = 60
        var lineWidth = maxLineWidth * normalizedAngle
        
        let tiltThreshold : CGFloat = pi/6
        let minAltitudeAngle: CGFloat = 0.25
        let maxAltitudeAngle = tiltThreshold
        
        let altitudeAngle = touch.altitudeAngle < minAltitudeAngle ? minAltitudeAngle : touch.altitudeAngle
        
        let normalizedAltitude = 1 - ((altitudeAngle - minAltitudeAngle) / (maxAltitudeAngle - minAltitudeAngle))
        
        lineWidth = lineWidth * normalizedAltitude + minLineWidth
        
        let minForce: CGFloat = 0.0
        let maxForce: CGFloat = 5
        
        let normalizedAlpha = (touch.force - minForce) / (maxForce - minForce)
        
        context!.setAlpha(normalizedAlpha)
        
        return lineWidth
    }
    
    func lineWidthForDrawing(context: CGContext?, touch: UITouch) -> CGFloat {
        var lineWidth = defaultLineWidth
        
        if touch.force > 0 {
            lineWidth = touch.force * forceSensitivity
        }
        
        return lineWidth
    }
    
    func clearCanvas(_ animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 0
            }, completion: { finished in
                self.alpha = 1
                self.image = nil
                for subview in self.subviews {
                    subview.removeFromSuperview()
                }
            })
        } else {
            image = nil
        }
    }
    
    func fetchOCRText () {
        let manager = CognitiveServices()
        
        let ocrImage = image!.crop(rect: ocrImageRect!)
        
        manager.retrieveTextOnImage(ocrImage) {
            operationURL, error in
            
            if #available(iOS 10.0, *) {
                
                let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    
                    manager.retrieveResultForOcrOperation(operationURL!, completion: {
                        results, error -> (Void) in
                        
                        if let theResult = results {
                            var ocrText = ""
                            for result in theResult {
                                ocrText = "\(ocrText) \(result)"
                            }
                            self.addLabelForOCR(text: ocrText)
                        } else {
                            self.addLabelForOCR(text: "No text for writing")
                        }
                        
                    })
                    
                }
            } else {
                // Fallback on earlier versions
            }
            
        }
    }
}

extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}
