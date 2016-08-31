/*:
 # First steps with Playgrounds
 
 The first thing we want to try is to get hands on with what we know already - dealing with out beloved UIKit. You can use all elements of UIKit as you are used to. In this example we want to build our environment for our further examples. Let's warm up, put your hands on the playground and get started!
 
 * callout(What to do):
 Just choose a picture you like, then enter a text you think fits to the image. To make it nice looking, choose a color for your text.
 */
//#-hidden-code
import PlaygroundSupport
import UIKit
import Foundation

guard #available(iOS 9, OSX 10.11, *) else {
    fatalError("Life? Don't talk to me about life. Here I am, brain the size of a planet, and they tell me to run a 'playground'. Call that job satisfaction? I don't.")
}

func setDescription(_ message: String) {
    let page = PlaygroundPage.current
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        proxy.send(.string(message))
    }
}

func setMyTextColor(_ color: UIColor) {
    let page = PlaygroundPage.current
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        let message : String = color.toHexString()
        proxy.send(.string(message))
    }
}

func chooseImage (_ imageData: Data) {
    let page = PlaygroundPage.current
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        proxy.send(.data(imageData))
    }
}
//#-end-hidden-code
let image = /*#-editable-code*/#imageLiteral(resourceName: "beach.png")/*#-end-editable-code*/
let dataImage = UIImagePNGRepresentation(image)
chooseImage(dataImage!)
setDescription(/*#-editable-code */"Description goes here!"/*#-end-editable-code*/)
setMyTextColor(/*#-editable-code */#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)/*#-end-editable-code*/)
/*:
 * callout(What did we learn?):
 So we are done with the basics. We created a `UIImageView` with an embedded `UIImage`. Our description area consists of an `UIView`, which background color and alpha is adjustable. And above this background view we added a `UILabel`, which shows our nice descriptive text for the picture.
 */

//: Horray! Let's get to our [next adventure](@next)!

