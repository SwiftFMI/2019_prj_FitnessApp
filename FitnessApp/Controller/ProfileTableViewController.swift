import UIKit
import Firebase
import FirebaseStorage
class ProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profilePicture: UIImageView!
    let picker = UIImagePickerController()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            updateUI()
            
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
            setProfileImage()
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
                    
                    let dataReference = self.db.collection(Constants.CollectionNames.users).document(self.user!)
                    let documentID = dataReference.documentID as? String
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
                    
                }
            }
        }
        
    func setProfileImage() {
        guard let imageURLString = UserDefaults.standard.value(forKey: "imageURL") as? String else {
            return
        }
        print(imageURLString)
            
        let url = URL(string: imageURLString)
        
        downloadImage(url: url!)
    }
    
    func getData(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(url: URL){
        getData(from: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async {
                self.profilePicture.image = UIImage(data: data)
            }
        }
    }
        
        
        func updateUI() {
            profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        }
        
        
        @IBAction func logOut(_ sender: UIButton) {
            
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
