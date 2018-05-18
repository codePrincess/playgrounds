//: [Previous](@previous)

import Foundation
import UIKit
import Vision
import PlaygroundSupport

let myView = UIView(frame: CGRect(x: 0, y: 0, width: 450, height: 600))

let preview = UIImageView(frame: myView.bounds)

preview.image = /*#-editable-code*/#imageLiteral(resourceName: "cat_smiling_2.jpg")/*#-end-editable-code*/

preview.contentMode = .scaleAspectFit

let textLabel = UILabel(frame: CGRect(x: 30, y: myView.bounds.height-100, width: 350, height: 100))
textLabel.lineBreakMode = .byWordWrapping
textLabel.numberOfLines = 5
textLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
textLabel.text = "Wanna find out if your cat is happy or grumpy?"

let backgroundView = UIView(frame: CGRect(x: 0, y: myView.bounds.height-170, width: myView.bounds.width, height: 200))
backgroundView.backgroundColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
backgroundView.alpha = 0.7

myView.addSubview(preview)
myView.addSubview(backgroundView)
myView.addSubview(textLabel)

let catMood = CatVisionLogic()
catMood.initRequest(label: textLabel)
catMood.doClassification(image: preview.image!)

PlaygroundPage.current.liveView = myView

//: [Next](@next)
