
/*:
 # OMG the handwriting recognition :O
 As we learned in the previous two playgrounds how to draw with the apple pencil in a smooth way,
 we are now taking things a bit further. This example is rather short, but the main brain power
 is packed into the __MyDoodleCanvas.swift__ file.
 
 In there you'll find the magic which happens as soon as you stop writing. The piece you've
 just written will be packed into an image and sent to the __Cognitive Service Computer Vision__ API for
 __Handwriting OCR Recognition__ (yes, double the R :D).
 
 It needs two REST API calls to achieve this, because the OCR on handwriting may take a bit longer than
 standard OCR from printed text. So the first call asks the service to start with the recognition and the
 second call retrieves the result - if any text was detected from your wonderful handwriting.
 
 Just try it! And don't forget to add your **Computer Vision Key** into the __CognitiveService.swift__
 file __in line 69__ :)
 
 Everything else should then work right out of the box - it's magic, right?
 - - -
 */
import Foundation
import UIKit
import PlaygroundSupport


var myCanvas = MyDoodleCanvas()
myCanvas.backgroundColor = .white
myCanvas.isUserInteractionEnabled = true

var canvasView = UIView(frame: CGRect(x: 0, y: 0, width: 450, height: 630))
myCanvas.frame = canvasView.frame
myCanvas.setup()
canvasView.addSubview((myCanvas))

PlaygroundPage.current.liveView = canvasView

