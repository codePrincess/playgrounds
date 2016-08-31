import PlaygroundSupport
import UIKit
import Foundation




public class MyView : UIViewController {
    
    let preview = UIImageView()
    let textLabel = UILabel()
    let backgroundView = UIView()
    let landmarkView = MyLandmarkView()
    
    var confidence = 0.85
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 0, y: 0, width: 520, height: 748)
        
        preview.frame = view.bounds
        preview.contentMode = .scaleAspectFit
        
        textLabel.frame = CGRect(x: 30, y: view.bounds.height-200, width: 350, height: 200)
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 5
        textLabel.textColor = .white
        textLabel.text = "This label makes place for your description :)"

        backgroundView.frame = CGRect(x: 0, y: view.bounds.height-170, width: view.bounds.width, height: 200)
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.7
        
        landmarkView.frame = view.bounds
        landmarkView.backgroundColor = .clear
        
        view.addSubview(preview)
        view.addSubview(backgroundView)
        view.addSubview(textLabel)
        view.addSubview(landmarkView)
        view.bringSubview(toFront: landmarkView)
        
        makeLandmarkViewVisible(false)
    }
    
    public func setTheDescription(_ message: String) {
        textLabel.text = message
    }
    
    public func setTheTextColor(_ color: UIColor) {
        textLabel.textColor = color
    }
    
    public func setTheImage(_ image: UIImage) {
        preview.image = image
    }
    
    public func reply(_ message: String) {
        textLabel.text = message
    }
    
    public func makeLandmarkViewVisible(_ visible: Bool) {
        landmarkView.alpha = visible ? 1.0 : 0.0
    }
    
    public func updateImage ( _ image: UIImage) {
        preview.image = image
        view.setNeedsDisplay()
        textLabel.text = "upated image ... wohooo \(image)"
    }
    
    /** 
     cognitive services functions
     called from the LiveViewMessageHandler
     */
    
    //MARK: - Computer Vision -
    func showTagsForImage () {
        let manager = CognitiveServices()
        textLabel.text = "... gimme a sec - getting your tags!"

        
        manager.retrievePlausibleTagsForImage(preview.image!, confidence) { (result, error) -> (Void) in
            DispatchQueue.main.async(execute: {
                if let _ = error {
                    print("omg something bad happened")
                } else {
                    print("seems like all went well: \(result)")
                }
                self.setTagsAsDescription(result)
            })
        }
    }
    
    private func setTagsAsDescription (_ tags : [String]?) {
        if (tags?.count)! > 0 {
            textLabel.text = ""
            for tag in tags! {
                textLabel.text = textLabel.text! + "#" + tag + " "
            }
        } else {
            textLabel.text = "Uh noez! No tags could be found for this image :("
        }
    }
    
    func adjustConfidence (_ value : Double) {
        confidence = value
    }
    
    //MARK: - Emotion API -
    
    private var emojis: [CognitiveServicesEmotionResult]? = nil {
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
    
    
    
    func makeEmojiFromEmotionOnImage () {
        let manager = CognitiveServices()
        
        textLabel.text = "... gimme a sec - getting your tags!"
        manager.retrievePlausibleEmotionsForImage(preview.image!) { (result, error) -> (Void) in
            DispatchQueue.main.async(execute: {
                if let _ = error {
                    print("omg something bad happened")
                } else {
                    print("seems like all went well: \(result)")
                }
                
                if (result?.count)! > 0 {
                    self.textLabel.text = "1..2.. Emoji!\n\((result?.count)!) emotions detected"
                } else {
                    self.textLabel.text = "Seems like no emotions were detected :("
                }
                
                self.emojis = result
            })
        }
    }
    
    //MARK: - Faces API - 
    
    func detectFaces () {
        let manager = CognitiveServices()
        
        textLabel.text = "... gimme a sec - getting your tags!"
        
        manager.retrieveFacesForImage(preview.image!) { (result, error) -> (Void) in
            DispatchQueue.main.async(execute: {
                if let _ = error {
                    print("omg something bad happened")
                } else {
                    print("seems like all went well: \(result)")
                }
                
                if (result?.count)! > 0 {
                    let face = result?[0]
                    self.textLabel.text = "Gender: \((face?.gender)!)\nAge: \((face?.age)!)\nGlasses: \((face?.glasses)!)\nFacial hair: \((face?.facialHair)!)"
                    self.landmarkView.scaledImageRatio = self.scaledImageRatio()
                    self.drawLandmarks(face!)
                    
                } else {
                    self.textLabel.text = "Seems like no emotions were detected :("
                }
            })
        }
    }
    
    private func scaledImageRatio () -> CGFloat {
        let imageViewHeight = preview.bounds.height
        let imageViewWidth = preview.bounds.width
        let imageSize = preview.image!.size
        let scaledImageHeight = min(imageSize.height * (imageViewWidth / imageSize.width), imageViewHeight)
        let scaledImageWidth = min(imageSize.width * (imageViewHeight / imageSize.height), imageViewWidth)
        
        landmarkView.yOffset = (view.frame.height - scaledImageHeight) / CGFloat(2.0)
        landmarkView.xOffset = (view.frame.width - scaledImageWidth) / CGFloat(2.0)
        
        let ratio : CGFloat = imageSize.height / scaledImageHeight
        return ratio
    }
    
    private func drawLandmarks (_ face: CognitiveServicesFacesResult) {
        landmarkView.face = face
        landmarkView.setNeedsDisplay()
    }

    
}

//MARK: - LiveView communication extension -

extension MyView : PlaygroundLiveViewMessageHandler {
    public func liveViewMessageConnectionOpened() {
        // We don't need to do anything in particular when the connection opens.
    }
    
    public func liveViewMessageConnectionClosed() {
        // We don't need to do anything in particular when the connection closes.
    }
    
    public func receive(_ message: PlaygroundValue) {
        switch message {
        case let .string(text):
            if text.contains(".") {
                setTheImage(UIImage(named:text)!)
            } else if text.contains("#") {
                setTheTextColor(UIColor(hexString: text))
            } else if text == "retrieveTags" {
                showTagsForImage()
            } else if text == "placeEmotions" {
                makeEmojiFromEmotionOnImage()
            } else if text == "detectFace" {
                detectFaces()
            } else if text == "showFaceLandmarks" {
                makeLandmarkViewVisible(true)
            } else if text == "hideFaceLandmarks" {
                makeLandmarkViewVisible(false)
            } else {
                setTheDescription(text)
            }
        case let .integer(number):
            reply("You sent me the number \(number)!")
        case let .boolean(boolean):
            reply("You sent me the value \(boolean)!")
        case let .floatingPoint(number):
            adjustConfidence(number)
            reply("You sent me the number \(number)!")
        case let .date(date):
            reply("You sent me the date \(date)")
        case let .data(mydata):
            let theImage = UIImage(data: mydata)
            updateImage(theImage!)
        case .array:
            reply("Hmm. I don't know what to do with an array.")
        case let .dictionary(dictionary):
            reply("Hmm. I don't know what to do with an array.")
        }
    }
}
