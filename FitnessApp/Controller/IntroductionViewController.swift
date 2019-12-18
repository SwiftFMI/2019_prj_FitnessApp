//
//  IntroductionViewController.swift
//  FitnessApp
//
//  Created by Mitko on 12/13/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAnalytics



class IntroductionViewController: UIViewController{
    @IBOutlet var usernameTextField: UITextField!
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func goToNextPage(_ sender: UIButton) {
        setUsername();
    }
    func setUsername() {
        if let user = Auth.auth().currentUser, let username = usernameTextField.text {
            db.collection("users").document(user.email!).collection("details").addDocument(data: ["username": username])
            
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
}
