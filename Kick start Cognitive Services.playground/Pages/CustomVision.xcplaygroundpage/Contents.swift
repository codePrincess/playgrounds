/*:
 # Custom Vision API
 ## or "How grumpy is my cat?"
 
 As soon as we want to ask questions, which might not fit into a globally trained model, we need to get active by ourselves.
 In this very case we want to know if a given cat is happy or grumpy. And let's prove, that the famouse GRUMPY CAT is really grumpy :D
 
 How can we do that? By training our own model! And no worries, this is not complicated at all - and the best thing is: it's already done for you.
 In this example we are using the remotely offered model from the Custom Vision API and ask via REST calls, if the cat on the image is a happy one, or a real grumpy one.
 */
//#-hidden-code
import Foundation
import UIKit
import PlaygroundSupport


let myView = UIView(frame: CGRect(x: 0, y: 0, width: 450, height: 600))

let preview = UIImageView(frame: myView.bounds)
//#-end-hidden-code

/*:
 * experiment:
 Choose your cat image right here or take a new one
 */
preview.image = /*#-editable-code*/#imageLiteral(resourceName: "cat_smiling_2.jpg")/*#-end-editable-code*/
//#-hidden-code
preview.contentMode = .scaleAspectFit

let textLabel = UILabel(frame: CGRect(x: 30, y: myView.bounds.height-100, width: 350, height: 100))
textLabel.lineBreakMode = .byWordWrapping
textLabel.numberOfLines = 5
//#-end-hidden-code
textLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
textLabel.text = "Wanna find out if your cat is happy or grumpy?"
//#-hidden-code
let backgroundView = UIView(frame: CGRect(x: 0, y: myView.bounds.height-170, width: myView.bounds.width, height: 200))
backgroundView.backgroundColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
backgroundView.alpha = 0.7

myView.addSubview(preview)
myView.addSubview(backgroundView)
myView.addSubview(textLabel)

func isMyCatHappyOrGrumpy(_ imageView : UIImageView) {
    let manager = CognitiveServices()
    manager.retrieveCatPredictionForImage(imageView.image!) { (result, error) -> (Void) in
        DispatchQueue.main.async(execute: {
            if let _ = error {
                print("omg something bad happened")
            } else {
                print("seems like all went well: \(String(describing: result))")
            }
            
            if let catEmotion = result {
                textLabel.text = "The cat on the image seems \n\(catEmotion)!"
            } else {
                textLabel.text = "Seems like no cat or it's emotion was detected :("
            }
            
        })
    }
}
//#-end-hidden-code

/*:
 * experiment:
 So let's get the cat analysis started. As you will see in a moment we get the prediction value for each available tag back. We then take the one with the higher value for granted and show the cat's mood in the UI. Groundbreaking right? :D
 */
isMyCatHappyOrGrumpy(preview)
//#-hidden-code
PlaygroundPage.current.liveView = myView
//#-end-hidden-code

/*:
 * callout(What did we learn?):
 Wonderful! So you just called a custom vision endooint from the Cognitive Services.

 If you want to have a detailed look at the documentation - where you can find further examples - visit the dedicated [CUSTOM VISION documentation](https://docs.microsoft.com/en-us/azure/cognitive-services/custom-vision-service/home) and the [CUSTOM VISION prediction definition](https://southcentralus.dev.cognitive.microsoft.com/docs/services/450e4ba4d72542e889d93fd7b8e960de/operations/5a6264bc40d86a0ef8b2c290).
 
 There you will learn how to train your model and then use it via REST API calls in your app also.*/


