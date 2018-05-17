/*:
 # Describe your picture!
 
It's time to get life into our app! Want to get your picture described by a remote service? Yes? YES? So get ready - and get to know the * *drumroooooll* * **COGNITIVE SERVICES**!

 We will start with the Computer Vision API. So let's see, what the "computer" can "see" on our image.
 */

//#-hidden-code
import PlaygroundSupport
import UIKit
import Foundation

guard #available(iOS 9, OSX 10.11, *) else {
    fatalError("Life? Don't talk to me about life. Here I am, brain the size of a planet, and they tell me to run a 'playground'. Call that job satisfaction? I don't.")
}

let myView = UIView(frame: CGRect(x: 0, y: 0, width: 450, height: 600))

let preview = UIImageView(frame: myView.bounds)
//#-end-hidden-code
/*:
 * experiment:
 Choose your preferred image right here or take a new one
 */
preview.image = /*#-editable-code*/#imageLiteral(resourceName: "containers.png")/*#-end-editable-code*/
//#-hidden-code
preview.contentMode = .scaleAspectFit

let textLabel = UILabel(frame: CGRect(x: 30, y: myView.bounds.height-200, width: 350, height: 200))
textLabel.lineBreakMode = .byWordWrapping
textLabel.numberOfLines = 5
textLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

let backgroundView = UIView(frame: CGRect(x: 0, y: myView.bounds.height-170, width: myView.bounds.width, height: 200))
backgroundView.backgroundColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
backgroundView.alpha = 0.7

myView.addSubview(preview)
myView.addSubview(backgroundView)
myView.addSubview(textLabel)

func showTagsForImage (_ photo : UIImageView, _ confidence : Double) {
    let manager = CognitiveServices()
    textLabel.text = "... gimme a sec - getting your tags!"
    manager.retrievePlausibleTagsForImage(photo.image!, confidence) { (result, error) -> (Void) in
        DispatchQueue.main.async(execute: {
            if let _ = error {
                print("omg something bad happened: \(String(describing: error))")
            } else {
                print("seems like all went well: \(String(describing: result))")
            }
            setTagsAsDescription(result)
        })
    }
}

func setTagsAsDescription (_ tags : [String]?) {
    if (tags?.count)! > 0 {
        textLabel.text = "Look what I detected:\n"
        for tag in tags! {
            textLabel.text = textLabel.text! + "#" + tag + " "
        }
    } else {
        textLabel.text = "Uh noez! No tags could be found for this image :("
    }
}

//#-end-hidden-code
/*:
 * experiment:
 Every part of the description of the picture will be returned with a certain confidence. A good value is 0.85 for nice fitting results. But go a head and play around with this value and see, with what funky descriptions the "computer" may come along
 */
showTagsForImage(preview, /*#-editable-code*/0.1/*#-end-editable-code*/)
//#-hidden-code
PlaygroundPage.current.liveView = myView
//#-end-hidden-code

/*: 
 * callout(What did we learn?):
 Wonderful! So you just called your first API from the Cognitive Services Suite. The Computer Vision API. If you want to have a detailed look at the documentation - where you can find further examples - visit the dedicated [Computer Vision documentation](https://www.microsoft.com/cognitive-services/en-us/computer-vision-api).
*/

//: Enough of just describing photos. Let's catch a face and let the API know! Let's rock on and continue by [using the FACE API](@next)!

