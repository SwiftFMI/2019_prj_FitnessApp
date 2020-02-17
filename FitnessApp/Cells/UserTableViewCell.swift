//
//  UserTableViewCell.swift
//  FitnessApp
//
//  Created by Nevena Kirova on 17.02.20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

}
