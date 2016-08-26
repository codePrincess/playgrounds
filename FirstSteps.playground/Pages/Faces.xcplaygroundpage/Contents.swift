/*:
 # Hey mom, who is on that picture?
 
 ... Intro
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

let myView = UIView(frame: CGRect(x: 0, y: 0, width: 450, height: 600))

let preview = UIImageView(frame: myView.bounds)
//#-end-hidden-code
/*:
 * experiment:
 Choose your preferred image right here or take a new one
 */
preview.image = /*#-editable-code*/#imageLiteral(resourceName: "Rose_Geil_39_2.png")/*#-end-editable-code*/
//#-hidden-code
preview.contentMode = .scaleAspectFit



let textLabel = UILabel(frame: CGRect(x: 30, y: 10, width: 350, height: 200))
textLabel.lineBreakMode = .byWordWrapping
textLabel.numberOfLines = 5
textLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

let backgroundView = UIView(frame: CGRect(x: 0, y: myView.bounds.height-170, width: myView.bounds.width, height: 200))
backgroundView.backgroundColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
backgroundView.alpha = 0.7

myView.addSubview(preview)
myView.addSubview(backgroundView)
backgroundView.addSubview(textLabel)




func detectFaces (_ photo : UIImageView) {
    let manager = CognitiveServices()
    textLabel.text = "... gimme a sec - getting your tags!"
    manager.retrieveFacesForImage(photo.image!) { (result, error) -> (Void) in
        DispatchQueue.main.async(execute: {
            if let _ = error {
                print("omg something bad happened")
            } else {
                print("seems like all went well: \(result)")
            }
            
            if (result?.count)! > 0 {
                let face = result?[0]
                textLabel.text = "Gender: \((face?.gender)!)\nAge: \((face?.age)!)\nGlasses: \((face?.glasses)!)\nFacial hair: \((face?.facialHair)!)"
                
                
            } else {
                textLabel.text = "Seems like no emotions were detected :("
            }
            
            
        })
    }
}

//#-end-hidden-code
/*:
 * experiment:
 ... description goes here ...
 */
detectFaces(preview)
//#-hidden-code
PlaygroundPage.current.liveView = myView
//#-end-hidden-code

/*:
 * callout(What did we learn?):
 ... [Faces documentation](https://www.microsoft.com/cognitive-services/en-us/face-api/documentation/overview) */

//: [next](@next)!

