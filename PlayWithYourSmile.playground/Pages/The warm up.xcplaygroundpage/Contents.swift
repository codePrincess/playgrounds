
/*: 
 # OMG it's Swift!
 
 It's time to get started. So we will create a little program which generates an output on the screen everytime we press a button. Not hard right? So let's go!
 - - -
 */
//: As always, we need a couple of imports to get nice API support for what we will be doing
import UIKit
import PlaygroundSupport
import Foundation
import GameplayKit

//: Then we define an **array** of emoji strings, which we will display in our output
let emojis = ["😘", "😽", "👊", "🤘", "👩‍💻"]
//: As we need to display our output somewhere, we create a UIView to satisfy this need. You can freely play around with the size if you wish.
let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 500))
//: To get a nice and friendly UI, we set the background color to white. The default value is just black.
view.backgroundColor = UIColor.white
//: As we want to trigger our output with a button click, we need a button. So we create a button!
let button = UIButton(type: .roundedRect)
//: Then the button gets a nice and describing title
button.setTitle("Press me", for: .normal)
//: And a place to be displayed
button.frame = CGRect(x: 85, y: 400, width: 150, height: 30)
//: The button setup is done, so we just add it to the view as a subview
view.addSubview(button)

/*: 
### Something very playground specific
 - - -
Now we have to do something very playground specific. In iOS it's super easy to add logic to touch events of controls. As the playground is not a full blown iOS app, we have to do a little workaround to get to our goal. So just notice that this class with it's only function helps the button to know what to do when it gets tapped.
 */
class ButtonLogic {
    var yPos = 20
    
/*:
Great! Now we have to define what the button should do everythime it getts tapped, or clicked :D
- We craete a label to show our output and give it a place to the displayed
- Then we create a random number between 0 and the length of our emoji-array
- We set the text into the label right next to an emoji from our array from a random position within the array
- And then add the label to the view for being able to see it on the
*/
    @objc func clicked() {
        let label = UILabel(frame: CGRect(x: 40, y: yPos, width: 320, height: 30))
        
        let random = GKRandomDistribution(lowestValue: 0, highestValue: emojis.count-1)
        let index = random.nextInt()
        let emoji = emojis[index]
        
        label.text = "Coding \(emoji)!"
        view.addSubview(label)
        
        yPos += 30
    }
}

//: As described above we have to create a new class instance for triggering the button behaviour. Then we add a target to the button which is triggered as soon as it gets touched.
let receiver = ButtonLogic()
button.addTarget(receiver, action: #selector(ButtonLogic.clicked), for: .touchUpInside)

//We assign our own created view to the playground so that it will be nicely rendered and displayed for us!
PlaygroundPage.current.liveView = view




