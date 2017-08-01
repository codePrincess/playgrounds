
/*:
 # Make your doodling smooth!
In the previous playground we got a first feeling for how easy it is to draw with the Apple Pencil.
So now we want to see our doodling a bit more smoother and not that edged, especially when drawing arcs and cicles.
In this playground we will add some minor adjustment to our code to achieve this exact goal: smoooothen it!
 - - -
 */
import Foundation
import UIKit
import PlaygroundSupport

public class SmoothCanvas : UIImageView {
    let pi = CGFloat(Double.pi)
    let forceSensitivity: CGFloat = 4.0
    var pencilTexture = UIColor(patternImage: UIImage(named: "PencilTexture")!)
    let defaultLineWidth : CGFloat = 6
    
    var eraserColor: UIColor {
        return backgroundColor ?? UIColor.white
    }
    
/*:
### Again: Touches!
Guess what - here the smoothening action will happen!
The pencil generates not only touches - it generates coalescedTouches and predictedTouches as well along
it's drawing way over our canvas. For smoothening the drawing line we will need the coalescedTouches. Those
are - simply put - the intermediate touches which are generated on a higher scanning rate from the iPad's
display. Because when the pencil touches the display the framerate will be doubled. Not for the drawing, but
for detecting touches by the pencil. Crazy huh! But good for us because we use them to get more touches and
therefore smoothen our drawing lines.
*/
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        // Draw previous image into context
        image?.draw(in: bounds)
        
        var touches = [UITouch]()
        
//: The coalesced touches come withthe current event. So we find out which belong to our current touch and collect them in an array.
        if let coalescedTouches = event?.coalescedTouches(for: touch) {
            touches = coalescedTouches
        } else {
            touches.append(touch)
        }

//: After we found all coalesced touches for our touch we draw them all. So not just the one touch, but with all it's intermediate "buddies".
        for touch in touches {
            drawStroke(context: context, touch: touch)
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
//: The rest of the code stays exactly the same as in the first playground. We draw more strokes and therefore smoothen the drawing. That's it!
    
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

/*:
 - - -
 ### Using the Doodle Canvas
 Now we build ourselves a nice smoooothe doodling canvas. So we want to use it, right? Just create a new SmoothCanvas,
 set a background color and give it a frame (for the Playgrounds app on the iPad just use the width: 1024).
 Attach the new view to the Playground's liveView and you are good to go. Let's doodle!
 */

var myCanvas = SmoothCanvas()
myCanvas.backgroundColor = .white
myCanvas.isUserInteractionEnabled = true

var canvasView = UIView(frame: CGRect(x: 0, y: 0, width: 450, height: 630))

//: Use the wider view on the iPad with the Playgrounds app fullscreen mode. More space to draw!
//var canvasView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 630))

myCanvas.frame = canvasView.frame
canvasView.addSubview((myCanvas))

PlaygroundPage.current.liveView = canvasView




