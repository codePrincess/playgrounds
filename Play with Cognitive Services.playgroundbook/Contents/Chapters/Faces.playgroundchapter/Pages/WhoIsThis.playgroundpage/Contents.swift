//#-hidden-code
import PlaygroundSupport
import UIKit
import Foundation

guard #available(iOS 9, OSX 10.11, *) else {
    fatalError("Life? Don't talk to me about life. Here I am, brain the size of a planet, and they tell me to run a 'playground'. Call that job satisfaction? I don't.")
}

func detectFaces () {
    let page = PlaygroundPage.current
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        proxy.send(.string("showFaceLandmarks"))
        proxy.send(.string("detectFace"))
    }
}
//#-end-hidden-code
/*:
 # Who's on that picture?
 
 As we already saw in the Emotions demo we are capable of getting some facial features from the API, like the face rectangle or the emotion. But is there more? Like getting *coordinates* of e.g. the eyes and the nose. The answer is **YES**! We can do this.
 
 The Cognitive Services provide an API called **Face API**. With this API we can analyse the features of a human face. We can determine where the eyes are, where the pupil is currently located, how "big" or "small" a nose is and if the face is currently smiling because it's mouth and lip coordinates indicates it :)
 
 But let's dive in and see, what the **Face API** sees for us.
 */
/*:
 * experiment:
 So let's get the face analysis started. As you will see in a moment we get the facial landmarks (dots in the image), the face rectangle and general infos like age, gender, glasses and facial hair for the selected picture. Cool huh?
 */

detectFaces()

/*:
 * callout(What did we learn?):
 The wonderful thing about this **Face API** is especially the retrieval of the landmarks of the face. We can do fun things with it, like pinning things into the face :D But we can identify this face, as soon as we added it to a PersonGroup, on other images. So we don't have to analyse the image itself and compare it to other faces to "find" persons on images. We can let the Face API do the work for us. Just have a look at the [Faces documentation](https://www.microsoft.com/cognitive-services/en-us/face-api/documentation/overview) and the way how to use [Persons and PersonGroups](https://www.microsoft.com/cognitive-services/en-us/face-api/documentation/face-api-how-to-topics/howtoidentifyfacesinimage) */

