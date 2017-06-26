

import Foundation
import PlaygroundSupport
import UIKit


//cgrect - create the rectangle in which the resulting photo shall be shown


//uiimageview - create an container for your photo and give it your defined size
let preview = UIImageView()

//contentMode - set the way the photo will be fit into the defined rectangle


//background color - set your favorite background color to the view


//image literal - use image picker and assign to image of uiimageview


//EmotionHelpers - create an "instance" of a class called EmotionHelpers


//makeEmojisFromEmotionOnPhoto - use the method makeEmojisFromEmotionOnPhoto to recognize the emotion of the face in the image. Use the image of the preview as the photo for the first parameter. With the second parameter you can choose, if you want to see a rectangle around the detected face. The completion block is there for you to assign the new image with emojis to the preview


PlaygroundPage.current.liveView = preview