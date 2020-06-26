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

class AddInfoController: UIViewController, UITextViewDelegate {
    
    var delegate : canReceive?
    

    @IBOutlet weak var addItemField: UITextField!
    //@IBOutlet weak var addInfoField: UITextField!
    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var buttonIdentifier: UIButton!
    @IBOutlet weak var addInfoTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addInfoTextView.delegate = self
        spaceView.layer.cornerRadius = 1
        spaceView.layer.borderWidth = 1
        buttonIdentifier.layer.masksToBounds = true;
        
        addInfoTextView.textColor = .lightGray
        addInfoTextView.text = "Description"
        addInfoTextView.textAlignment = .center
        self.hideKeyboardWhenTappedAround()
        //spaceView.layer.borderColor = CGColo
        // Do any additional setup after loading the view.
    }
    

    @IBAction func goback(_ sender: Any) {
        // What if no text?
        delegate?.dataReceived(data: addItemField.text!, info: addInfoTextView.text!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAdd(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if addInfoTextView.textColor == UIColor.lightGray {
            addInfoTextView.text = nil
            addInfoTextView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if addInfoTextView.text.isEmpty {
            addInfoTextView.text = "Description"
            addInfoTextView.textColor = UIColor.lightGray
        }
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
