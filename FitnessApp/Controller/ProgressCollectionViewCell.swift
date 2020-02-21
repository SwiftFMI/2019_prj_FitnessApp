//
//  ProgressCollectionViewCell.swift
//  FitnessApp
//
//  Created by Rosiana Ladzheva on 21.02.20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var progressImageView: UIImageView!
   
    func configureCell(with image: UIImage?) {
        self.progressImageView.image = image
    }
}
