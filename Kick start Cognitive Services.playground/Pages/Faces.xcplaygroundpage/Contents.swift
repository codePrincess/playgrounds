/*:
 # Who's on that picture?
 
 As we already saw in the Emotions demo we are capable of getting some facial features from the API, like the face rectangle or the emotion. But is there more? Like getting *coordinates* of e.g. the eyes and the nose. The answer is **YES**! We can do this. 
 
 The Cognitive Services provide an API called **Face API**. With this API we can analyse the features of a human face. We can determine where the eyes are, where the pupil is currently located, how "big" or "small" a nose is and if the face is currently smiling because it's mouth and lip coordinates indicates it :)
 
 But let's dive in and see, what the **Face API** sees for us.
 */

//#-hidden-code
import PlaygroundSupport
import UIKit
import Foundation

guard #available(iOS 9, OSX 10.11, *) else {
    fatalError("Life? Don't talk to me about life. Here I am, brain the size of a planet, and they tell me to run a 'playground'. Call that job satisfaction? I don't.")
}

extension CGContext {
    func addRect(rect:CGRect, fillColor:UIColor, strokeColor:UIColor, width:CGFloat) {
        self.addRect(rect)
        self.fillAndStroke(fillColor: fillColor, strokeColor: strokeColor, width: width)
    }
    func fillAndStroke(fillColor:UIColor, strokeColor:UIColor, width:CGFloat) {
        self.setFillColor(fillColor.cgColor)
        self.setStrokeColor(strokeColor.cgColor)
        self.setLineWidth(width)
        self.drawPath(using: CGPathDrawingMode.fillStroke)
    }
}

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
                context.addRect(rect: CGRect(x: (landmark.x / scaledImageRatio) + xOffset, y: (landmark.y / scaledImageRatio) + yOffset , width: 2, height: 2), fillColor: .red, strokeColor: .red, width: 1)
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

let myView = UIView(frame: CGRect(x: 0, y: 0, width: 430, height: 620))

let preview = UIImageView(frame: myView.bounds)
let landmarkView = MyLandmarkView(frame: myView.bounds)
landmarkView.backgroundColor = .clear

//#-end-hidden-code
/*:
 * experiment:
 Choose your preferred image right here or take a new one. We tell the API that we'd like to know about different features of the face like age, gender, facialHair and glasses. Moreover we ask for a unique face identifier and facial landmarks. The face identifier can be used to later identify the person. The facial landmarks tell us things like where the eyes, the pupil, the nose and the mouth is and let us know about their dimensions.
 */
preview.image = /*#-editable-code*/#imageLiteral(resourceName: "Photo on 26.06.17 at 09.21.jpg")/*#-end-editable-code*/

//#-hidden-code
preview.contentMode = .scaleAspectFit

let textLabel = UILabel(frame: CGRect(x: 30, y: 0, width: 768, height: 120))
textLabel.lineBreakMode = .byWordWrapping
textLabel.numberOfLines = 5
textLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

let backgroundView = UIView(frame: CGRect(x: 0, y: myView.bounds.height-120, width: myView.bounds.width, height: 100))
backgroundView.backgroundColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
backgroundView.alpha = 0.7

myView.addSubview(preview)
myView.addSubview(backgroundView)
backgroundView.addSubview(textLabel)
myView.addSubview(landmarkView)
myView.bringSubview(toFront: landmarkView)


func detectFaces (_ photo : UIImageView) {
    let manager = CognitiveServices()
    textLabel.text = "... gimme a sec - wheeere are the faces!"
    
    manager.retrieveFacesForImage(photo.image!) { (result, error) -> (Void) in
        DispatchQueue.main.async(execute: {
            if let _ = error {
                print("omg something bad happened")
            } else {
                print("seems like all went well: \(String(describing: result))")
            }
            
            if (result?.count)! > 0 {
                let face = result?[0]
                textLabel.text = "Gender: \((face?.gender)!)\nAge: \((face?.age)!)\nGlasses: \((face?.glasses)!)\nFacial hair: \((face?.facialHair)!)"
                landmarkView.scaledImageRatio = scaledImageRatio()
                drawLandmarks(face!)
                
            } else {
                textLabel.text = "Seems like no emotions were detected :("
            }
            
            
        })
    }
}

func scaledImageRatio () -> CGFloat {
    let imageViewHeight = preview.bounds.height
    let imageViewWidth = preview.bounds.width
    let imageSize = preview.image!.size
    let scaledImageHeight = min(imageSize.height * (imageViewWidth / imageSize.width), imageViewHeight)
    let scaledImageWidth = min(imageSize.width * (imageViewHeight / imageSize.height), imageViewWidth)
    
    landmarkView.yOffset = (myView.frame.height - scaledImageHeight) / CGFloat(2.0)
    landmarkView.xOffset = (myView.frame.width - scaledImageWidth) / CGFloat(2.0)
    
    let ratio : CGFloat = imageSize.height / scaledImageHeight
    return ratio
}

func drawLandmarks (_ face: CognitiveServicesFacesResult) {
    landmarkView.face = face
    landmarkView.setNeedsDisplay()
}

//#-end-hidden-code
/*:
 * experiment:
 So let's get the face analysis started. As you will see in a moment we get the facial landmarks (dots in the image), the face rectangle and general infos like age, gender, glasses and facial hair for the selected picture. Cool huh?
 */
detectFaces(preview)
//#-hidden-code
PlaygroundPage.current.liveView = myView
//#-end-hidden-code

/*:
 * callout(What did we learn?):
 The wonderful thing about this **Face API** is especially the retrieval of the landmarks of the face. We can do fun things with it, like pinning things into the face :D But we can identify this face, as soon as we added it to a PersonGroup, on other images. So we don't have to analyse the image itself and compare it to other faces to "find" persons on images. We can let the Face API do the work for us. Just have a look at the [Faces documentation](https://www.microsoft.com/cognitive-services/en-us/face-api/documentation/overview) and the way how to use [Persons and PersonGroups](https://www.microsoft.com/cognitive-services/en-us/face-api/documentation/face-api-how-to-topics/howtoidentifyfacesinimage) */

