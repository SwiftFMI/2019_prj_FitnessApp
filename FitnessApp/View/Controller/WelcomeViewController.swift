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
    


    @IBOutlet weak var workoutCalendar: UIButton!
    
    let db = Firestore.firestore()
    @IBOutlet var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeUser()
        workoutCalendar.layer.cornerRadius = 15
        
    }
    
    func welcomeUser() {
        let currentUserEmail = Auth.auth().currentUser!.email
//        let username = db.collection("users").wheref
        db.collection("users").document(currentUserEmail!).getDocument { (snapshot, error) in
            if (error != nil) {
                print(error)
            } else {
                if snapshot!.exists {
                    let documentData = snapshot!.data()
                    self.welcomeLabel.text = "Welcome, \(documentData!["username"] as! String)"
                    
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
