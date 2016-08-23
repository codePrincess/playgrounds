/*:
 # First steps with Playgrounds
 
 The first thing we want to try is to get hands on with what we know already - dealing with out beloved UIKit. You can use all elements of UIKit as you are used to. Try it out and get started!
 
 **What to do**
 1. Just choose a picture you like
 2. Then enter a text you think fits to the image
 3. To make it nice looking, choose a color for your text
 4. And it's background :)
 */

//#-hidden-code
import PlaygroundSupport
import UIKit
import Foundation

guard #available(iOS 9, OSX 10.11, *) else {
    fatalError("Life? Don't talk to me about life. Here I am, brain the size of a planet, and they tell me to run a 'playground'. Call that job satisfaction? I don't.")
}
//#-end-hidden-code

//#-hidden-code
let myView = UIView(frame: CGRect(x: 0, y: 0, width: 450, height: 600))

let preview = UIImageView(frame: myView.bounds)
//#-end-hidden-code
preview.image = /*#-editable-code*/#imageLiteral(resourceName: "keepcalm.png")/*#-end-editable-code*/
//#-hidden-code
preview.contentMode = .scaleAspectFit

let textFileRef = #fileLiteral(resourceName: "justtext.txt")
let stringFromFile = try String(contentsOf: textFileRef)

let textLabel = UILabel(frame: CGRect(x: 30, y: myView.bounds.height-200, width: 350, height: 200))
//#-end-hidden-code
textLabel.text = /*#-editable-code*/"My picture is looking good!"/*#-end-editable-code*/
//#-hidden-code
textLabel.lineBreakMode = .byWordWrapping
textLabel.numberOfLines = 5
//#-end-hidden-code
textLabel.textColor = /*#-editable-code*/ #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) /*#-end-editable-code*/
//#-hidden-code
let backgroundView = UIView(frame: CGRect(x: 0, y: myView.bounds.height-170, width: myView.bounds.width, height: 200))
//#-end-hidden-code
backgroundView.backgroundColor = /*#-editable-code*/ #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) /*#-end-editable-code*/
//#-end-editable-code
//#-hidden-code
backgroundView.alpha = 0.7

myView.addSubview(preview)
myView.addSubview(backgroundView)
myView.addSubview(textLabel)

PlaygroundPage.current.liveView = myView
//#-end-hidden-code


//: So we are done with the basics - let's get to our [next adventure](@next)!