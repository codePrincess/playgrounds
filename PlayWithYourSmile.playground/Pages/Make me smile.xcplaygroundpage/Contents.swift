/*:
 # Make me smile! :D
 
 After successfully managing the ComputerVision API, we will dive a little bit further into the **COGNITIVE SERVICES**.
 With the Emotion API we can detect - yes - emotions on human faces. What the API returns is not just the motion, but additionally the rectangle where this face is located at the picuture. Awesome, right?
 */
/*:
 ## A bit of initial setup work
 
 Let's do some initial work and create a place where we want to display our photo. 
 - First we create a frame, in which our photo will be displayed. Think about it as the dimension of your graphic context.
 - Then we create a component called UIImageView, which will be able to display our photo, as soon was we choose one
 - We need to define the way we want to fit the image into the defined space
 - And for the matter of beauty we set our favorite color as the background color for our photo
 */


// This makes all the iOS known controls available like buttons, labels, navigation views and so on
import UIKit

// This import gives us nice support for playground specific features like using the live view
import PlaygroundSupport

//create the rectangle in which the resulting photo shall be shown
let frame = CGRect(x: 0, y: 0, width: 450, height: 600)
//create an container for your photo and give it your defined size
let preview = UIImageView(frame: frame)
//set the way the photo will be fit into the defined rectangle
preview.contentMode = .scaleAspectFit
//set your favorite background color to the view
preview.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)



/*:
 ## Choose me! ME! 
 
 It's time now to finally get the emotion detection going right? So here we just choose a photo with the image picker and tadaaa, it is displayed in the previous defined preview image view.
 */

preview.image = #imageLiteral(resourceName: "Giugli.png")


/*:
 ## Do some networking ;)
 
 We have everything in place. So now we want to send our chosen photo the the Cognitive Services emotion detection endpoint and show this emotion as an emoji over our face on the image. Sounds like fun right? So let's get going!
 - We create an "instance" of a class called EmotionHelpers
 - This instance knows a handy method called "makeEmojisFromEmotionOnPhoto". This is exactly what we need. So we go ahead and call this method
 - The method needs two "parameters" and one "callback"
 - The first parameter is the photo, because otherwise the helper can't call the emotion endpoint for us
 - The second parameter tells the helper to draw a rectangle around the detected faces in the picture
 - And the code in curly braces handles what shall be done with the result we get back from the helper method. As we get back an image, we just want to see it within our preview image view. And so we just assign the newly craeted emojiimage to our preview view.
 */

let helpers = EmotionHelpers()

helpers.makeEmojiFromEmotionOnPhoto(photo: preview, withFaceRect: true) { emojiImage in
    preview.image = emojiImage
}

//set our preview image view
PlaygroundPage.current.liveView = preview
