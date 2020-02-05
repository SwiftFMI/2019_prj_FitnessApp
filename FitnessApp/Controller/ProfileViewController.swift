//
//  ProfileViewController.swift
//  FitnessApp
//
//  Created by Mitko on 1/9/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
class ProfileViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var changePictureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    

    
    @IBAction func changeProfilePicture(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage  else { return }
        dismiss(animated: true, completion: nil)
        profilePicture.image = image
        uploadPhoto()
    }
    
    func uploadPhoto() {
        guard let image = profilePicture.image, let data = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child("images").child(imageName)
        
        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                return
            }
            imageReference.downloadURL { (url, err) in
                if let err = err {
                    return
                }
                guard let url = url else {
                    return
                }
                
            }
        }
    }
    
    
    
    func updateUI() {
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
    }
    
    
    @IBAction func logOut(_ sender: UIButton) {
        
    }
}



