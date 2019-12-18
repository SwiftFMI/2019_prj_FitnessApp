//
//  UserDetailsViewController.swift
//  FitnessApp
//
//  Created by Mitko on 12/13/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit
import Firebase

class UserDetailsViewController: UIViewController {
    let db = Firestore.firestore()

    @IBOutlet var jobField: UITextField!
    @IBOutlet var ageField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateUserDetails() {
        if let job = jobField.text,let user = Auth.auth().currentUser,  let age = ageField.text {
            db.collection("users").document(user.email!).collection("details").addDocument(data: [
                "job" : job,
                "age" : age
            ])
                {(error) in
                if let e = error {
                    print(e)
                } else {
                    print("success")
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
