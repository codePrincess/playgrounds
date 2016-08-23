
import PlaygroundSupport
import UIKit
import Foundation

guard #available(iOS 9, OSX 10.11, *) else {
    fatalError("Life? Don't talk to me about life. Here I am, brain the size of a planet, and they tell me to run a 'playground'. Call that job satisfaction? I don't.")
}


let myView = UIView(frame: CGRect(x: 0, y: 0, width: 450, height: 600))


let preview = UIImageView(frame: myView.bounds)
preview.image = #imageLiteral(resourceName: "keepcalm.png")
preview.contentMode = .scaleAspectFit

let textFileRef = #fileLiteral(resourceName: "justtext.txt")
let stringFromFile = try String(contentsOf: textFileRef)

let textLabel = UILabel(frame: CGRect(x: 30, y: myView.bounds.height-200, width: 350, height: 200))
textLabel.text = stringFromFile
textLabel.lineBreakMode = .byWordWrapping
textLabel.numberOfLines = 5
textLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

let backgroundView = UIView(frame: CGRect(x: 0, y: myView.bounds.height-170, width: myView.bounds.width, height: 200))
backgroundView.backgroundColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
backgroundView.alpha = 0.7

myView.addSubview(preview)
myView.addSubview(backgroundView)
myView.addSubview(textLabel)

PlaygroundPage.current.liveView = myView

