//
//  RegisterViewController.swift
//  FitnessApp
//
//  Created by Mitko on 12/13/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit
import Firebase
import TextFieldFloatingPlaceholder
import FirebaseFirestore

class RegisterViewController: UIViewController, UITextFieldDelegate {
    let db = Firestore.firestore()

    @IBOutlet var emailTextField: TextFieldFloatingPlaceholder!
    
    @IBOutlet var passwordTextField: TextFieldFloatingPlaceholder!
    

    
    @IBOutlet var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        errorLabel.text = ""
        updateTextFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        errorLabel.text = ""
        updateTextFields()
    }
    

    @IBAction func registerButton(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, email.isEmpty == false, password.isEmpty == false {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let e = error {
                        self.errorLabel.text = e.localizedDescription
                    } else {
                    self.db.collection(Constants.CollectionNames.users).document(email)
                    let destinationVC = self.storyboard?.instantiateViewController(identifier: Constants.ControllersIdentifiers.setupController) as! FirstSetupPageViewController
                        self.navigationController?.setViewControllers([destinationVC], animated: true)
                    }
                }
            }
                
        }
    
    func updateTextFields() {
        
        emailTextField.validationTrueLineColor = UIColor.black.withAlphaComponent(1)
        emailTextField.validationTrueLineEditingColor = UIColor.init(red: 203/255, green: 209/255, blue: 255, alpha: 1)
        passwordTextField.validationTrueLineColor = UIColor.black.withAlphaComponent(1)
        passwordTextField.validationTrueLineEditingColor = UIColor.init(red: 203/255, green: 209/255, blue: 255/255, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
