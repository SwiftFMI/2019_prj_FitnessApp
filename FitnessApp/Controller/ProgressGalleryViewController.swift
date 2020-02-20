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

class ProgressGalleryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var noImagesLabel: UILabel!
    
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
    var imageArray = [UIImage()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        // setProgressImage()
        setupImages(imageArray)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupImages(imageArray)
        
    }
    
    @IBAction func openCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let newImage = info[.originalImage] as? UIImage
        addImageToProgressArray()
        uploadPhoto(image: newImage!)
    }
    
    func uploadPhoto(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child("images").child(imageName)
        
        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if err != nil {
                return
            }
            imageReference.downloadURL { (url, err) in
                if err != nil {
                    return
                }
                guard let url = url else {
                    return
                }
                
                let dataReference = self.db.collection(Constants.CollectionNames.users).document(self.user!)
                let documentID = dataReference.documentID
                let urlString = url.absoluteString
                
                let data = [
                    "progressImages" : [[
                        "imageUid": documentID,
                        "imageURL": urlString
                        ]]
                    
                ]
                dataReference.setData(data, merge: true) { (err) in
                    if let err = err {
                        print(err)
                    } else {
                        UserDefaults.standard.set(documentID, forKey: "imageURL")
                    }
                    
                }
            }
        }
    }
    
    
    func addImageToProgressArray() {
        db.collection(Constants.CollectionNames.users).document(user!).getDocument { (document, err) in
            if let e = err {
                print(e)
            } else {
                
                if let data = document?.data() {
                    if let dataObject = data["progressImages"] as? [[String:Any]] {
                        for image in dataObject {
                            guard let url = URL(string: image["imageURL"] as! String) else { return }
                            self.downloadImage(url: url)
                            print(url)
                        }
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
        if images.isEmpty {
            noImagesLabel.text =  "Your progress gallery is empty. \n Start tracking your progress now!"
        }
        for i in 0..<images.count {
            
            let imageView = UIImageView()
            imageView.image = images[i]
            let xPosition = UIScreen.main.bounds.width * CGFloat(i + 1)
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFit
            
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
            scrollView.delegate = self as? UIScrollViewDelegate
        }
    }
}
