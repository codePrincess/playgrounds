/*:
 # Am I smiling - YES I AM!
 
 After successfully managing the FACE API, we will dive a little bit further into it.
 Once upon a time there was a dedicated EMOTION API in place, which could detect... emotions in images and videos. As human emotions are very much related to faces, the two APIs got merged together. And that's why we are having a look into the emotion data for detected faces now! Awesome, right?
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



let textLabel = UILabel(frame: CGRect(x: 30, y: myView.bounds.height-150, width: 350, height: 150))
textLabel.lineBreakMode = .byWordWrapping
textLabel.numberOfLines = 5
textLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
textLabel.text = "Wow, is there somthing here?"


let backgroundView = UIView(frame: CGRect(x: 0, y: myView.bounds.height-170, width: myView.bounds.width, height: 200))
backgroundView.backgroundColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
backgroundView.alpha = 0.7

myView.addSubview(preview)
myView.addSubview(backgroundView)
myView.addSubview(textLabel)
myView.bringSubviewToFront(textLabel)

var emojis: [CognitiveServicesFacesResult]? = nil {
    didSet {
        if preview.image == nil {
            return
        }
        
        if let results = emojis {
            UIGraphicsBeginImageContext(preview.image!.size)
            preview.image?.draw(in: CGRect(origin: CGPoint.zero, size: preview.image!.size))
            
            for result in results {
                var availableEmojis = [String]()
                
                if let emotion = result.emotion {
                    switch emotion {
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
                let calculatedSize = string.size(withAttributes: [NSAttributedString.Key.font: font])
                
                if calculatedSize.width > maximumSize.width {
                    actualFontSize -= stepping
                } else {
                    actualFontSize += stepping
                }
            } while true
            
            let font = UIFont.systemFont(ofSize: CGFloat(actualFontSize))
            string.draw(in: result.frame, withAttributes: [NSAttributedString.Key.font: font])
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
                print("seems like all went well: \(String(describing: result!))")
            }
            
            emojis = result
            
            if (result?.count)! > 0 {
                textLabel.text = "1..2.. Emoji!\n\((result?.count)!) emotion(s) detected"
            } else {
                textLabel.text = "Seems like no emotions were detected :("
            }
            
        })
    }
}

//#-end-hidden-code
/*:
 * experiment:
 What the API gets from us is really just the image. In return we will retrieve an array of emotion results, which contains the certainties of the eight possible emotions (neutral, happiness, sadness, anger, ...). What we will do right now is to get the emotion with the highest score and map it to a suitable emoji... to pin it on the person's face :)
 */
makeEmojiFromEmotionOnPhoto(preview)
//#-hidden-code
PlaygroundPage.current.liveView = myView
//#-end-hidden-code

/*:
 * callout(What did we learn?):
 Wonderful! So you just called the emotion endooint from the Cognitive Services FACE API. If you want to have a detailed look at the documentation - where you can find further examples - visit the dedicated [FACE API documentation](https://docs.microsoft.com/en-us/azure/cognitive-services/face/overview) and the [FACE API definition](https://westus.dev.cognitive.microsoft.com/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236) */

//: Enough of just dealing with smiles! Let's see if we can find out smiles of cats. Is it possible, to distinguish a smiling cat from a grumpy one? Let's get going by [using the Custom Vision API](@next)!

