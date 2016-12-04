//
//  ViewController.swift
//  Bookki
//
//  Created by Jose Garcia on 12/3/16.
//  Copyright © 2016 Jose. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var forgotButton: UIButton!

    @IBOutlet var signInButton: UIButton!

//    let ref = FIRDatabase.database().reference()
//    let user = FIRAuth.auth()?.currentUser


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        signInButton.layer.cornerRadius = 25
        signInButton.layer.borderWidth = 5
        signInButton.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: signin() signs in the user.

    func signin() {
        let email = usernameField.text?.trimmingCharacters(in: .whitespaces)
        let password = passwordField.text!
        if (email?.isEmpty == true || password.isEmpty == true) {
            self.showAlert(title: "Fields Empty", message: "Fields are empty. Please enter email and password.")
        } else {
            FIRAuth.auth()?.signIn(withEmail: email!, password: password, completion: { (user, error) in
                if error != nil {
                    self.showAlert(title: "Error", message: (error?.localizedDescription)!)
                } else {
                    print("Signed in!")
                }
            })
        }
    }

    @IBAction func didPressForgotPassword(_ sender: AnyObject) {

    }

    @IBAction func didPressSignin(_ sender: AnyObject) {
        signin()
        
    }

    func showAlert(title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }

}

