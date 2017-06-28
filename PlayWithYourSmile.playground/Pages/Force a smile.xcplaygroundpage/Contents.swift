import Foundation
import UIKit
import PlaygroundSupport



let helpers = EmotionHelpers()



func makeEmojiFromEmotionOnPhoto (photo : UIImageView!, withFaceRect: Bool, completion: @escaping (UIImage) -> (Void)) {
    
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
            
            var isHappy = true
            for res in result! {
                if res.emotion != CognitiveServicesEmotion.Happiness {
                    isHappy = false
                    print("OMG detected unhappy face - NO!")
                    break
                }
            }
            
            if isHappy {
                let photoWithEmojis = helpers.drawEmojisFor(emotions: result, withFaceRect: withFaceRect, image: photo.image!)
                completion(photoWithEmojis)
            }
            else {
                completion(#imageLiteral(resourceName: "grumpycat.jpg"))
            }
        })
    }
}



let frame = CGRect(x: 0, y: 0, width: 450, height: 600)
let preview = UIImageView(frame: frame)
preview.contentMode = .scaleAspectFit
preview.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
preview.image = #imageLiteral(resourceName: "Giugli.png")
makeEmojiFromEmotionOnPhoto(photo: preview, withFaceRect: true) { emojiImage in
    preview.image = emojiImage
}



PlaygroundPage.current.liveView = preview







