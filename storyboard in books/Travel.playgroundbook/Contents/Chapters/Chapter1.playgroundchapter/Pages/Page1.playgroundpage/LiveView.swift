import PlaygroundSupport
import UIKit

let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
let ctrl = storyboard.instantiateViewController(withIdentifier: "view")

PlaygroundPage.current.liveView = ctrl
