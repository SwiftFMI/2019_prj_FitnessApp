//
//  LoginViewController.swift
//  FitnessApp
//
//  Created by Mitko on 12/13/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit
import Firebase
import TextFieldFloatingPlaceholder

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: TextFieldFloatingPlaceholder!
    @IBOutlet var passwordTextField: TextFieldFloatingPlaceholder!
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextFields()
        emailTextField.text = "mitko99penkov@gmail.com"
        passwordTextField.text = "miti99"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        errorLabel.text = ""
    }
    
    
    @IBAction func signIn(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let e = error {
                    self.errorLabel.text = e.localizedDescription
                } else {
                    let destinationVC = self.storyboard?.instantiateViewController(identifier: "welcome") as! WelcomeViewController
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
}

