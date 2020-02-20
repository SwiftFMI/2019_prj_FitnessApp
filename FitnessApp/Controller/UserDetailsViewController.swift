//
//  UserDetailsViewController.swift
//  FitnessApp
//
//  Created by Mitko on 12/13/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit
import Firebase
import TextFieldFloatingPlaceholder
import FirebaseFirestore

class UserDetailsViewController: UIViewController, UITextFieldDelegate {
    let db = Firestore.firestore()
    
    @IBOutlet var jobField: TextFieldFloatingPlaceholder!
    @IBOutlet var ageField: TextFieldFloatingPlaceholder!
    override func viewDidLoad() {
        super.viewDidLoad()
        jobField.delegate = self
        ageField.delegate = self
        jobField.validationTrueLineColor = UIColor.black.withAlphaComponent(1)
        jobField.validationTrueLineEditingColor = UIColor.init(red: 203/255, green: 209/255, blue: 255, alpha: 1)
        ageField.validationTrueLineColor = UIColor.black.withAlphaComponent(1)
        ageField.validationTrueLineEditingColor = UIColor.init(red: 203/255, green: 209/255, blue: 255, alpha: 1)

    }
    
    @IBAction func start(_ sender: UIButton) {
        updateUserDetails()
    }
    func updateUserDetails() {
        if let job = jobField.text,let user = Auth.auth().currentUser,  let age = ageField.text {
            db.collection(Constants.CollectionNames.users).document(user.email!).updateData([Constants.DocumentFields.job:job, Constants.DocumentFields.age:age])
            let destinationVC = storyboard?.instantiateViewController(identifier: Constants.ControllersIdentifiers.tabController) as! UITabBarController
            navigationController?.setViewControllers([destinationVC], animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


