//
//  ProgressGalleryViewController.swift
//  FitnessApp
//
//  Created by Rosiana Ladzheva on 18.02.20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class ProgressGalleryViewController: UIViewController {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    
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
        setProgressImage()
        setupImages(imageArray)
    }
    
    func setProgressImage() {
        db.collection(Constants.CollectionNames.users).document(user!).getDocument { (document, err) in
            if let e = err {
                print(e)
            } else {
                
                if let data = document?.data() {
                    if let dataObject = data["progressImages"] as? [String:Any] {
                        guard let url = URL(string: dataObject["imageURL"] as! String) else { return }
                        self.downloadImage(url: url)
                        print(url)
                    }
                }
            }
        }
        
    }
    
    func getData(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(url: URL){
        getData(from: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.imageArray.append(UIImage(data: data)!)
            }
        }
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
            scrollView.delegate = self as! UIScrollViewDelegate
        }
    }
    
}
