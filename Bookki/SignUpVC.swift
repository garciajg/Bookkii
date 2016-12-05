//
//  SignUpVC.swift
//  Pods
//
//  Created by Jose Garcia on 12/3/16.
//
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var reenterEmailField: UITextField!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var reenterPasswordField: UITextField!
    @IBOutlet var birthdayField: UITextField!
    @IBOutlet var uploadedImage: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var galeryButton: UIButton!

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var continueButton: UIButton!

    let ref = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        design()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressCancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func didPressContinue(_ sender: AnyObject) {
        signUpUser()
    }

    //MARK: Textfiel Delegate Methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        reenterEmailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        reenterPasswordField.resignFirstResponder()
        birthdayField.resignFirstResponder()

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
    }

    //MARK: UIImagePicker Delegate Methods

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let choosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        uploadedImage.contentMode = .scaleAspectFit
        uploadedImage.image = choosenImage

        self.dismiss(animated: true) { 
            print("Image picked")
        }
    }


    //MARK: signupUser() signs up the user and the attributes are saved in database
    func signUpUser() {
        //TODO: Check for the username
        //TODO: Check how to add date from string
        let email = self.emailField.text!.trimmingCharacters(in: .whitespaces).lowercased()
        var password = self.passwordField.text!
        let username = self.usernameField.text!.trimmingCharacters(in: .whitespaces)
        let firstName = self.firstNameField.text!.trimmingCharacters(in: .whitespaces).capitalized
        let lastName = self.lastNameField.text!.trimmingCharacters(in: .whitespaces).capitalized


        if (email != reenterEmailField.text || password != reenterPasswordField.text) {
            self.showAlert(title: "Fields do not match", text: "Make sure your email and password fields match.")
        } else if ((password.characters.count) < 6 || (reenterPasswordField.text?.characters.count)! < 6) {
            self.showAlert(title: "Password too short", text: "Your password must be at least 6 characters long.")
            self.passwordField.clearsOnBeginEditing = true

        } else if (username.isEmpty == true) {
            self.showAlert(title: "Username Field Empty", text: "Enter a username.")
        } else if (password.isEmpty == true) {
            self.showAlert(title: "Password Field Empty", text: "Enter a password.")
        } else if (firstName.isEmpty == true) {
            self.showAlert(title: "First Name Field Empty", text: "Enter your first name.")
        }else {
            self.ref.child("users").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                if snapshot.hasChild(self.usernameField.text!) {
                    let alert = UIAlertController(title: "Username Exists", message: "Sorry, that username is taken", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Error", message: "\(error?.localizedDescription)", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alert.addAction(alertAction)
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            print("User: \(username)\nEmail: \(user?.displayName)")
                            //Code commented formats birthday date to date object
//                            let dateFormater = DateFormatter()
//                            dateFormater.dateFormat = "MM/dd/yyyy"
//                            let dateObj = dateFormater.date(from: self.birthdayField.text!)
                            self.ref.child("users").child(self.usernameField.text!).child("firstName").setValue(firstName)
                            self.ref.child("users").child(self.usernameField.text!).child("lastName").setValue(lastName)
                            self.ref.child("users").child(self.usernameField.text!).child("birthday").setValue(self.birthdayField.text!)
                            self.ref.child("users").child(self.usernameField.text!).child("email").setValue(email)
                                
                            }
                        })
                    }
            })
        }

    }

    //MARK: Show Alert

    func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: disgn() method just sets delegates to texfields and design of buttons
    func design() {
        emailField.delegate = self
        passwordField.delegate = self
        reenterPasswordField.delegate = self
        reenterEmailField.delegate = self
        usernameField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        birthdayField.delegate = self

        cancelButton.layer.cornerRadius = 25
        continueButton.layer.cornerRadius = 25
    }

    @IBAction func didPressCameraButton(_ sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera

            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Oops!", text: "Sorry, seems like your camera is not available")
        }

    }

    @IBAction func didPressGaleryButton(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary

                present(imagePicker, animated: true, completion:nil)
        } else {
            showAlert(title: "Oops", text: "Seems like your galery is not available")
        }
    }

    @IBAction func didPressClearButton(_ sender: AnyObject) {
        uploadedImage.image = nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
