//
//  ImageDegailViewController.swift
//  FitnessApp
//
//  Created by Rosiana Ladzheva on 21.02.20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var progressImage: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressImage.image = self.image
        // Do any additional setup after loading the view.
    }
}
