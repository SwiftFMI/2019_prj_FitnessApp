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

class ProgressGalleryViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        progressImages.imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ProgressGalleryCollectionViewCell else { return UICollectionViewCell() }
        cell.progressImageView.image = progressImages.imagesArray[indexPath.row]
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = progressCollectionView.cellForItem(at: indexPath) as! ProgressGalleryCollectionViewCell
        progressImage = cell.progressImageView.image!
        performSegue(withIdentifier: "ShowImage", sender: self)
    }
    
    @IBOutlet weak var progressCollectionView: UICollectionView!
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    var progressImage = UIImage()

    var progressImages = ProgressImages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressCollectionView.dataSource = self
        progressCollectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
                    "progressImages" : [
                        "imageUid": documentID,
                        "imageURL": urlString
                        ]
                    
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
                    if let dataObject = data["progressImages"] as? [String:Any] {
                            guard let url = URL(string: dataObject["imageURL"] as! String) else { return }
                        self.downloadImage(url: url)
                            print(url)
                        }
                    }
                }
            }
    }
    
    func downloadImage(url: URL) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let data = try? Data(contentsOf: url)
            self.progressImages.imagesArray.append(UIImage(data: data!)!)
            self.progressCollectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ("ShowImage") {
            let vc = segue.destination as? ImageDetailViewController
            vc?.image = self.progressImage
        }
    }
}
