import Foundation
import UIKit

public class EmotionHelpers : NSObject {
    
    var preview : UIImageView!
    
    /**
     Method for putting an emoji with a matching emotion over each detected face in a photo.
     
     - parameters:
       - photo: The photo on which faces and it's emotion shall be detected
       - withFaceRect: If TRUE then the face rectangle is drawn into the photo
       - completion: UIImage as new photo with added emojis for the detected emotion over each face in fitting size and with face framing rectangles if declared. Image is the same size as the original.
     */
    public func makeEmojiFromEmotionOnPhoto (photo : UIImageView!, withFaceRect: Bool, completion: @escaping (UIImage) -> (Void)) {
        
        let manager = CognitiveServices()
        
        manager.retrievePlausibleEmotionsForImage(photo.image!) { (result, error) -> (Void) in
            DispatchQueue.main.async(execute: {
                if let _ = error {
                    print("omg something bad happened")
                } else {
                    print("seems like all went well: \(String(describing: result))")
                }
                
                if (result?.count)! > 0 {
                    print("1..2.. Emoji!\n\((result?.count)!) emotions detected")
                } else {
                    print("Seems like no emotions were detected :(")
                }
                
                let photoWithEmojis = self.drawEmojisFor(emotions: result, withFaceRect: withFaceRect, image: photo.image!)
                completion(photoWithEmojis)
            })
        }
        
    }
    
    func emojisFor (emotion: CognitiveServicesEmotionResult) -> [String] {
        var availableEmojis = [String]()
        
        switch emotion.emotion {
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
        
        return availableEmojis

    }

    func drawEmojisFor (emotions: [CognitiveServicesEmotionResult]?, withFaceRect: Bool, image: UIImage) -> UIImage {
        
        var returnImage : UIImage!
        
        if let results = emotions {
            UIGraphicsBeginImageContext(image.size)
            image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
            
            for result in results {
                let availableEmojis = emojisFor(emotion: result)
                
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
                    let calculatedSize = string.size(attributes: [NSFontAttributeName: font])
                    
                    if calculatedSize.width > maximumSize.width {
                        actualFontSize -= stepping
                    } else {
                        actualFontSize += stepping
                    }
                    
                } while true
                
                let font = UIFont.systemFont(ofSize: CGFloat(actualFontSize))
                string.draw(in: result.frame, withAttributes: [NSFontAttributeName: font])
                
                if withFaceRect {
                    let context = UIGraphicsGetCurrentContext()
                    let frame = result.frame
                    context!.setLineWidth(5)
                    context!.addRect(frame)
                    context!.drawPath(using: .stroke)
                }
                
            }
            
            returnImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return returnImage
    }

}

