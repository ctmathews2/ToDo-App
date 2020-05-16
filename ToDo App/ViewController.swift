//
//  ViewController.swift
//  ToDo App
//
//  Created by Chandler Mathews on 5/15/20.
//  Copyright © 2020 Chandler Mathews. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var centerText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func changeColor(_ sender: UIButton) {
        centerText.text = "Good bye world!"
    }
    
}

