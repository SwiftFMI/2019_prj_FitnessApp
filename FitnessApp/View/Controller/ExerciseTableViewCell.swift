//
//  ExerciseTableViewCell.swift
//  FitnessApp
//
//  Created by Mitko on 12/22/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
//    var exersise: String = ""
//    var repetitions: 

    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var repetitions: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
