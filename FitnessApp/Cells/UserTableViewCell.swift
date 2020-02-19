//
//  UserTableViewCell.swift
//  FitnessApp
//
//  Created by Nevena Kirova on 17.02.20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class UserTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var profileImage: UIImageView!
    let db = Firestore.firestore()
    @IBOutlet weak var profileLabel: UILabel!
    
    let currentUser = Auth.auth().currentUser?.email!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func addFriend(_ sender: UIButton) {
        let user = profileLabel.text!
    db.collection(Constants.CollectionNames.users).document(currentUser!).collection(Constants.CollectionNames.friends).document(user).setData(["name": user])
    }
    
    
    
}
