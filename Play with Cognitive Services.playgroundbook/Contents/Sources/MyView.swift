import PlaygroundSupport
import UIKit
import Foundation




public class MyView : UIViewController {
    
    let preview = UIImageView()
    let textLabel = UILabel()
    let backgroundView = UIView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 0, y: 0, width: 520, height: 748)
        
        preview.frame = view.bounds
        preview.contentMode = .scaleAspectFit
        preview.image = UIImage(named: "man.jpg")
        
        textLabel.frame = CGRect(x: 30, y: view.bounds.height-200, width: 350, height: 200)
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 5
        textLabel.textColor = .red
        textLabel.text = "This is my text label"

        backgroundView.frame = CGRect(x: 0, y: view.bounds.height-170, width: view.bounds.width, height: 200)
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.7

        view.addSubview(preview)
        view.addSubview(backgroundView)
        view.addSubview(textLabel)
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
    
}

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
            } else {
                setTheDescription(text)
            }
        case let .integer(number):
            reply("You sent me the number \(number)!")
        case let .boolean(boolean):
            reply("You sent me the value \(boolean)!")
        case let .floatingPoint(number):
            reply("You sent me the number \(number)!")
        case let .date(date):
            reply("You sent me the date \(date)")
        case .data:
            reply("Hmm. I don't know what to do with data values.")
        case .array:
            reply("Hmm. I don't know what to do with an array.")
        case let .dictionary(dictionary):
            reply("Hmm. I don't know what to do with an array.")
        }
    }
}
