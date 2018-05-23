/*:
 # Ask CoreML!
 ## or "How to offline detect grumpy cats"
 
 In the last page we had a look at how we can use a self trained model via a REST API for predictions.
 
 Now we imported the trained model and want to use the Vision Framework if iOS to do this offline. This is way faster and we don't have to rely on an online connection to do predictions.
 
 In this example we choose an image from the album (or take a new one with the camera). Then we transform it to fit the needs of the model and show the result in a text label below the picture. But no worries - the part of where the model prediction is requested is hidden in this example. We just want to concentrate on the way the model gives it's predictions for images.
 */
//#-hidden-code
import Foundation
import UIKit
import Vision
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
//#-end-hidden-code

/*:
 * experiment:
 So let's get the cat analysis started. As you will see in a moment we get the prediction value for each available tag back. We then take the one with the higher value for granted and show the cat's mood in the UI. Groundbreaking right? :D
 */
let catMood = CatVisionLogic()
catMood.initRequest(label: textLabel)
catMood.doClassification(image: preview.image!)

//#-hidden-code
PlaygroundPage.current.liveView = myView
//#-end-hidden-code
/*:
 * callout(What did we learn?):
 Yes, we just accomplished to use CoreML and the Vision framework to get prediction from a self trained model!
 
 If you want to have a detailed look at the documentation - where you can find further examples - visit the dedicated [CUSTOM VISION documentation](https://docs.microsoft.com/en-us/azure/cognitive-services/custom-vision-service/home) and the [CUSTOM VISION prediction definition](https://southcentralus.dev.cognitive.microsoft.com/docs/services/450e4ba4d72542e889d93fd7b8e960de/operations/5a6264bc40d86a0ef8b2c290).
 
 In case you want to dive deeper into [CoreML](https://developer.apple.com/documentation/coreml) and the [Vision framework](https://developer.apple.com/documentation/vision), just follow the white rabb... ehm links :)
 */
