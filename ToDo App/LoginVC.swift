//
//  LoginVC.swift
//  ToDo App
//
//  Created by Chandler Mathews on 6/9/20.
//  Copyright © 2020 Chandler Mathews. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        //print("I AM GETTING HERE")
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {(user, error) in
            if error != nil {
                print(error!)
                //print("ERROR HERE")
            }else{
               // print("I DID NOT GET AN ERROR")
                if(user != nil){
                  //  print("Logged In")
                    self.performSegue(withIdentifier: "goToList", sender: self)
                }else{
                   // print("Didnt log in")
                }
            }
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
