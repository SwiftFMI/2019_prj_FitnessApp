//
//  ProgressGalleryViewController.swift
//  FitnessApp
//
//  Created by Rosiana Ladzheva on 18.02.20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit

class ProgressGalleryViewController: UIViewController {
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return scroll
    }()
    
    //these should be the user images from the database
    var imageArray = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

         view.addSubview(scrollView)

        //user.images
         imageArray = ["Your Image","Your Image")]

         setupImages(imageArray)
    }
    

   func setupImages(_ images: [UIImage]){

       for i in 0..<images.count {

           let imageView = UIImageView()
           imageView.image = images[i]
           let xPosition = UIScreen.main.bounds.width * CGFloat(i)
           imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
           imageView.contentMode = .scaleAspectFit

           scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
           scrollView.addSubview(imageView)
           scrollView.delegate = self
       }
   }

}
