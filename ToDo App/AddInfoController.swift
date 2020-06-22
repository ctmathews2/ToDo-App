//
//  AddInfoController.swift
//  ToDo App
//
//  Created by Chandler Mathews on 6/5/20.
//  Copyright © 2020 Chandler Mathews. All rights reserved.
//

import UIKit

protocol canReceive {
    func dataReceived(data: String, info: String)
}

class AddInfoController: UIViewController {
    
    var delegate : canReceive?

    @IBOutlet weak var addItemField: UITextField!
    @IBOutlet weak var addInfoField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func goback(_ sender: Any) {
        delegate?.dataReceived(data: addItemField.text!, info: addInfoField.text!)
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
