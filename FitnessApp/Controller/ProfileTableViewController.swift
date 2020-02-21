import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class ProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profilePicture: UIImageView!
    let picker = UIImagePickerController()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            updateUI()
            setUsername()
            setProfileImage()
    }
    
    func setUsername() {
        db.collection(Constants.CollectionNames.users).document(user!).getDocument { (doc, error) in
            if let e = error {
                print(e)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.usernameLabel.text = doc?.data()!["username"] as? String
                }
            }
        }
    }
        

        
    @IBAction func changeProfilePicture(_ sender: UIButton) {
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            
            present(picker, animated: true, completion: nil)
            self.present(picker, animated: true)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.allowsEditing = true
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                profilePicture.image = image
            }
            dismiss(animated: true, completion: nil)
            uploadPhoto()
            
            
        }
        
        func uploadPhoto() {
            guard let image = profilePicture.image, let data = image.jpegData(compressionQuality: 1.0) else {
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
                        "profileImage" : [
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
                    self.setProfileImage()
                }
            }
        }
        
    func setProfileImage() {
            db.collection(Constants.CollectionNames.users).document(user!).getDocument { (document, err) in
                if let e = err {
                    print(e)
                } else {
                    
                    if let data = document?.data() {
                        if let dataObject = data["profileImage"] as? [String:Any] {
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
                self.profilePicture.image = UIImage(data: data)
            }
        }
    }
        
        
        func updateUI() {
            profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        }
        
        
        @IBAction func logOut(_ sender: UIButton) {
            try! Auth.auth().signOut()
            if let storyboard = self.storyboard {
                let vc = storyboard.instantiateViewController(identifier: Constants.ControllersIdentifiers.login) as! LoginViewController
                userDefaults.removeObject(forKey: Constants.UserDef.email)
                userDefaults.removeObject(forKey: Constants.UserDef.password)
                vc.hidesBottomBarWhenPushed = true
                navigationController?.setViewControllers([vc], animated: true)
                self.dismiss(animated: true)
                
            }
        }
    
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return 5
        }
    
    }
