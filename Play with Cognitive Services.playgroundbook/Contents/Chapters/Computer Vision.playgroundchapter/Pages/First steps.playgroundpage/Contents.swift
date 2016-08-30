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

func setConfidenceForComputerVision(_ value: Double) {
    let page = PlaygroundPage.current
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        proxy.send(.floatingPoint(value))
    }
}

func retrieveTags() {
    let page = PlaygroundPage.current
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        proxy.send(.string("retrieveTags"))
    }
}

//#-end-hidden-code
/*:
 * experiment:
 Every part of the description of the picture will be returned with a certain confidence. A good value is 0.85 for nice fitting results. But go a head and play around with this value and see, with what funky descriptions the "computer" may come along
 */

setConfidenceForComputerVision(/*#-editable-code*/0.2/*#-end-editable-code*/)
retrieveTags()

/*:
 * callout(What did we learn?):
 Wonderful! So you just called your first API from the Cognitive Services Suite. The Computer Vision API. If you want to have a detailed look at the documentation - where you can find further examples - visit the dedicated [Computer Vision documentation](https://www.microsoft.com/cognitive-services/en-us/computer-vision-api).
 */

//: Enough of just describing photos. Let's catch a smile and let the API know! Let's rock on and continue by [using the Emotion API](@next)!
