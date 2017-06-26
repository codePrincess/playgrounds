/*:
 # Am I smiling - YES I AM!
 
 After successfully managing the ComputerVision API, we will dive a little bit further into the **COGNITIVE SERVICES**.
 With the Emotion API we can detect - yes - emotions on human faces. What the API returns is not just the motion, but additionally the rectangle where this face is located at the picuture. Awesome, right?
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
preview.image = /*#-editable-code*/#imageLiteral(resourceName: "Tiffany.jpg")/*#-end-editable-code*/
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

var emojis: [CognitiveServicesEmotionResult]? = nil {
didSet {
    if preview.image == nil {
        return
    }
    
    if let results = emojis {
        UIGraphicsBeginImageContext(preview.image!.size)
        preview.image?.draw(in: CGRect(origin: CGPoint.zero, size: preview.image!.size))
        
        for result in results {
            var availableEmojis = [String]()
            switch result.emotion {
            case .Anger:
                availableEmojis.append("😡")
                availableEmojis.append("😠")
            case .Contempt:
                availableEmojis.append("😤")
            case .Disgust:
                availableEmojis.append("😷")
                availableEmojis.append("🤐")
            case .Fear:
                availableEmojis.append("😱")
            case .Happiness:
                availableEmojis.append("😝")
                availableEmojis.append("😀")
                availableEmojis.append("😃")
                availableEmojis.append("😄")
                availableEmojis.append("😆")
                availableEmojis.append("😊")
                availableEmojis.append("🙂")
                availableEmojis.append("☺️")
            case .Neutral:
                availableEmojis.append("😶")
                availableEmojis.append("😐")
                availableEmojis.append("😑")
            case .Sadness:
                availableEmojis.append("🙁")
                availableEmojis.append("😞")
                availableEmojis.append("😟")
                availableEmojis.append("😔")
                availableEmojis.append("😢")
                availableEmojis.append("😭")
            case .Surprise:
                availableEmojis.append("😳")
                availableEmojis.append("😮")
                availableEmojis.append("😲")
            }
            
            let emoji = availableEmojis.randomElement()
            
            let maximumSize = result.frame.size
            let string = emoji as NSString
            let startingFontSize = 8192.0
            
            var actualFontSize = startingFontSize
            var stepping = actualFontSize
            repeat {
                stepping /= 2.0
                if stepping < 1.0 {
                    break
                }
                
                let font = UIFont.systemFont(ofSize: CGFloat(actualFontSize))
                let calculatedSize = string.size(attributes: 	[NSFontAttributeName: font])
                
                if calculatedSize.width > maximumSize.width {
                    actualFontSize -= stepping
                } else {
                    actualFontSize += stepping
                }
            } while true
            
            let font = UIFont.systemFont(ofSize: CGFloat(actualFontSize))
            string.draw(in: result.frame, withAttributes: [NSFontAttributeName: font])
        }
        
        preview.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
}



func makeEmojiFromEmotionOnPhoto (_ photo : UIImageView) {
    let manager = CognitiveServices()
    textLabel.text = "... gimme a sec - watching out for smiles!"
    manager.retrievePlausibleEmotionsForImage(photo.image!) { (result, error) -> (Void) in
        DispatchQueue.main.async(execute: {
            if let _ = error {
                print("omg something bad happened")
            } else {
                print("seems like all went well: \(String(describing: result))")
            }
            
            if (result?.count)! > 0 {
                textLabel.text = "1..2.. Emoji!\n\((result?.count)!) emotions detected"
            } else {
                textLabel.text = "Seems like no emotions were detected :("
            }
            
            emojis = result
        })
    }
}

//#-end-hidden-code
/*:
 * experiment:
 What the API get from us is really just the image. In return we will get an array of emotion results, which contain a rectangle of the face position and size in the picture and certainties of the different emotions - there are 9 of them (neutral, happy, sad, angry, ...). The emotion with the highest certainty wins and will be mapped to an emoji by our app.
 */
makeEmojiFromEmotionOnPhoto(preview)
//#-hidden-code
PlaygroundPage.current.liveView = preview
//#-end-hidden-code

/*:
 * callout(What did we learn?):
 Wonderful! So you just called your second API from the Cognitive Services Suite. The Emotion API. If you want to have a detailed look at the documentation - where you can find further examples - visit the dedicated [Emotion documentation](https://www.microsoft.com/cognitive-services/en-us/emotion-api/documentation) and the [Emotion API definition](https://dev.projectoxford.ai/docs/services/5639d931ca73072154c1ce89/operations/563b31ea778daf121cc3a5fa) */

//: Enough of just dealing with smiles now! Let's see what faces we are able to detect - and what we can say about age and gender :) Let's get going with [using the Face API](@next)!

