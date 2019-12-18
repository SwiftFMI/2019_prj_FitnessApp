//
//  WelcomeViewController.swift
//  FitnessApp
//
//  Created by Mitko on 12/13/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit
import Firebase
class WelcomeViewController: UIViewController {

    let db = Firestore.firestore()
    @IBOutlet var welcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeUser()
        
    }
    func welcomeUser() {
        let currentUser = Auth.auth().currentUser!
        let username = db.collection("users").document(currentUser.email!).collection("details").
        welcomeLabel.text = "Welcome \(String(describing: username))"
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
