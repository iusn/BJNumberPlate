//
//  ViewController.swift
//  Swift-Demo
//
//  Created by Sun on 25/10/2016.
//  Copyright © 2016 Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var textField = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboard = BJNumberPlate()
        textField.placeholder = "Type something......"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.green.cgColor
        textField.inputView = keyboard;
        self.view.addSubview(textField);
    }
    
    override func viewWillLayoutSubviews(){
            super.viewWillLayoutSubviews()
            textField.frame = CGRect(x:20,y:40,width:300,height:30);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

