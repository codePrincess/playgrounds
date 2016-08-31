import PlaygroundSupport
import UIKit
import Foundation


class MyLandmarkView : UIView {
    
    var face : CognitiveServicesFacesResult? = nil
    var scaledImageRatio : CGFloat = 1
    var xOffset : CGFloat = 0.0
    var yOffset : CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(),
            let myFace = face {
            
            //draw all found landmarks for the face
            for landmark in myFace.landmarks! {
                context.addRect(rect: CGRect(x: (landmark.x / scaledImageRatio) + xOffset, y: (landmark.y / scaledImageRatio) + yOffset, width: 2, height: 2), fillColor: .red, strokeColor: .red, width: 1)
            }
            
            //draw the facerect
            var faceFrame = myFace.frame
            faceFrame.origin.x = (faceFrame.origin.x / scaledImageRatio) + xOffset
            faceFrame.origin.y = (faceFrame.origin.y / scaledImageRatio) + yOffset
            faceFrame.size.width /= scaledImageRatio
            faceFrame.size.height /= scaledImageRatio
            
            context.addRect(rect: faceFrame, fillColor: .clear, strokeColor: .red, width: 2)
        }
        
    }
}
