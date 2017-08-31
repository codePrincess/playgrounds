//
//  LogController.swift
//  TravelLog
//
//  Created by Manu Rink on 30.08.17.
//  Copyright © 2017 microsoft. All rights reserved.
//

import Foundation
import UIKit

@objc(LogController)
class LogController : UIViewController {
    
    @IBOutlet weak var greetingsLabel: UILabel!
    var greeting : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let greetText = greeting {
            greetingsLabel.text = "Hola \(greetText) :)"
        } else {
            greetingsLabel.text = "Hola you :)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
