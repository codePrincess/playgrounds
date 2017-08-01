
import Foundation
import UIKit
import PlaygroundSupport

public class BasicCanvas : UIImageView {
    let pi = CGFloat(Double.pi)
    let forceSensitivity: CGFloat = 4.0
    var pencilTexture = UIColor(patternImage: UIImage(named: "PencilTexture")!)
    let defaultLineWidth : CGFloat = 6
    
    var eraserColor: UIColor {
        return backgroundColor ?? UIColor.white
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
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
        UIGraphicsEndImageContext()
    }
    
    func drawStroke(context: CGContext?, touch: UITouch) {
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)
        
        // Calculate line width for drawing stroke
        var lineWidth : CGFloat = 1.0
        
        if touch.type == .stylus {
            lineWidth = lineWidthForDrawing(context: context, touch: touch)
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
            })
        } else {
            image = nil
        }
    }
}


var myCanvas = BasicCanvas()
myCanvas.backgroundColor = .white
myCanvas.isUserInteractionEnabled = true

var canvasView = UIView(frame: CGRect(x: 0, y: 0, width: 450, height: 630))
myCanvas.frame = canvasView.frame
canvasView.addSubview((myCanvas))

PlaygroundPage.current.liveView = canvasView




