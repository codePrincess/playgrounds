
/*:
 # Get a grip on your Apple Pencil!
 Ever wanted to code for your Pencil instead of just using it in apps of others? Now this is your time!
 In this playground we will get a first grip of how to support basic doodling in your app with the Pencil.
 And guess what - it's not complicated at all. You basically use things you already know of: touches!
 But see yourself, and let's get things going!
 
 And thanks to __Caroline Begbie__ for getting me started with the whole topic :)
 Her full tutorial can be 
 [found here on raywenderlich.com](https://www.raywenderlich.com/121834/apple-pencil-tutorial)
 - - -
 */
//: As always, we need a couple of imports to get nice API support for what we will be doing
import Foundation
import UIKit
import PlaygroundSupport

/*:
   We define a class for our doodling canvas. Nope, there is no out-of-the-box drawing canvas there for you.
   But don't be afraid, it's pretty simple to build one on your own.
 */
public class BasicCanvas : UIImageView {
    
//: First we need some constants for later caluclation and a texture for our pencil. Should look like a real pencil, right?
    let pi = CGFloat(Double.pi)
    let forceSensitivity: CGFloat = 4.0
    var pencilTexture = UIColor(patternImage: UIImage(named: "PencilTexture")!)
    let defaultLineWidth : CGFloat = 6
//: We will support the finger touches as an eraser. Cool eh!
    var eraserColor: UIColor {
        return backgroundColor ?? UIColor.white
    }
    
/*:   
### Touches
As said before this is our most important info for supporting the pencil. The pencil itself
generates touches like you are used from finger based touches. But the pencil generated ones have additional
information for us to differentiate and use this info for drawing.
*/
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        // Draw previous image into context
        image?.draw(in: bounds)
//: In here we just get the generated touches and draw them as strokes
        drawStroke(context: context, touch: touch)
//: Right afterwards we generate an image from our drawing and display it to our imageview's image
        image = UIGraphicsGetImageFromCurrentImageContext()
//: And don't forget to end/close the current context
        UIGraphicsEndImageContext()
    }
    
/*:
### Core drawing
This method does the real drawing work. It get's the touches and detects if touches are coming
from the pencil or from the finger. Depending on the touch's source the stroke will be styled
differently as we want to draw with the pencil and erase with the finger.
No matter from where the touch is coming - the drawing work is the same. Just adding a line to
the context from the start location of the touch to it's end.
*/
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

/*: 
### Forceful drawing
This little helper method is used for a nice feature - reflecting the current force used while drawing.
And draw the line forcefully thicker then. It gives the user a more natural feeling while drawing.
*/
    func lineWidthForDrawing(context: CGContext?, touch: UITouch) -> CGFloat {
        var lineWidth = defaultLineWidth
        
        if touch.force > 0 {
            lineWidth = touch.force * forceSensitivity
        }
        
        return lineWidth
    }
    
/*:
   We want to delete the current context - and this little method helps us doing exactly this. 
   With a nice face effect in place.
*/
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
Now we build ourselves a nice basic doodling canvas. So we want to use it, right? Just create a new BasicCanvas,
set a background color and give it a frame (for the Playgrounds app on the iPad just use the width: 1024).
Attach the new view to the Playground's liveView and you are good to go. Let's doodle!
 */
var myCanvas = BasicCanvas()
myCanvas.backgroundColor = .white
myCanvas.isUserInteractionEnabled = true

var canvasView = UIView(frame: CGRect(x: 0, y: 0, width: 450, height: 630))

//: Use the wider view on the iPad with the Playgrounds app fullscreen mode. More space to draw!
//var canvasView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 630))

myCanvas.frame = canvasView.frame
canvasView.addSubview((myCanvas))

PlaygroundPage.current.liveView = canvasView




