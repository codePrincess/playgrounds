//#-hidden-code
import PlaygroundSupport
import UIKit
import Foundation

guard #available(iOS 9, OSX 10.11, *) else {
    fatalError("Life? Don't talk to me about life. Here I am, brain the size of a planet, and they tell me to run a 'playground'. Call that job satisfaction? I don't.")
}

func placeEmojiForEmotion() {
    let page = PlaygroundPage.current
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        proxy.send(.string("placeEmotions"))
    }
}

func chooseImage (_ imageData: Data) {
    let page = PlaygroundPage.current
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        proxy.send(.data(imageData))
    }
}

//#-end-hidden-code
/*:
 # Am I smiling - YES I AM!
 
 After successfully managing the ComputerVision API, we will dive a little bit further into the **COGNITIVE SERVICES**.
 With the Emotion API we can detect - yes - emotions on human faces. What the API returns is not just the motion, but additionally the rectangle where this face is located at the picuture. Awesome, right?
 */
/*:
 * experiment:
 What the API get from us is really just the image. In return we will get an array of emotion results, which contain a rectangle of the face position and size in the picture and certainties of the different emotions - there are 9 of them (neutral, happy, sad, angry, ...). The emotion with the highest certainty wins and will be mapped to an emoji by our app.
 */
let image = /*#-editable-code*/#imageLiteral(resourceName: "beach.png")/*#-end-editable-code*/
let dataImage = UIImagePNGRepresentation(image)
chooseImage(dataImage!)
placeEmojiForEmotion()

/*:
 * callout(What did we learn?):
 Wonderful! So you just called your second API from the Cognitive Services Suite. The Emotion API. If you want to have a detailed look at the documentation - where you can find further examples - visit the dedicated [Emotion documentation](https://www.microsoft.com/cognitive-services/en-us/emotion-api/documentation) and the [Emotion API definition](https://dev.projectoxford.ai/docs/services/5639d931ca73072154c1ce89/operations/563b31ea778daf121cc3a5fa) */

//: Enough of just dealing with smiles now! Let's see what faces we are able to detect - and what we can say about age and gender :) Let's get going with [using the Face API](@next)!

