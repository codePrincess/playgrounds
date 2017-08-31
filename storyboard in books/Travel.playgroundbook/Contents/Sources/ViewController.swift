//
//  ViewController.swift
//  TravelLog
//
//  Created by Manu Rink on 30.08.17.
//  Copyright © 2017 microsoft. All rights reserved.
//

import UIKit

@objc(ViewController)
public class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let logCtrl = segue.destination as! LogController
        logCtrl.greeting = usernameTextField.text
    }

}
