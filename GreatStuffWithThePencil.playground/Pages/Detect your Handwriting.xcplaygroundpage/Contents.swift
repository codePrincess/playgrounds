
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

