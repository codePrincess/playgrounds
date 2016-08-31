/*:
 # First steps with Playgrounds
 
 The first thing we want to try is to get hands on with what we know already - dealing with out beloved UIKit. You can use all elements of UIKit as you are used to. In this example we want to build our environment for our further examples. Let's warm up, put your hands on the playground and get started!

 * callout(What to do):
 Just choose a picture you like, then enter a text you think fits to the image. To make it nice looking, choose a color for your text and it's background.
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
preview.image = /*#-editable-code*/#imageLiteral(resourceName: "beach.png")/*#-end-editable-code*/
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
backgroundView.alpha = /*#-editable-code*/ 0.7 /*#-end-editable-code*/
//#-hidden-code
myView.addSubview(preview)
myView.addSubview(backgroundView)
myView.addSubview(textLabel)


PlaygroundPage.current.liveView = myView
//#-end-hidden-code


/*: 
 * callout(What did we learn?):
 So we are done with the basics. We created a `UIImageView` with an embedded `UIImage`. Our description area consists of an `UIView`, which background color and alpha is adjustable. And above this background view we added a `UILabel`, which shows our nice descriptive text for the picture. 
 */

//: Horray! Let's get to our [next adventure](@next)!

