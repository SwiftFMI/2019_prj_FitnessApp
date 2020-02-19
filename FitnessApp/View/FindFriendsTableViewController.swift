//
//  FriendsTableViewController.swift
//  FitnessApp
//
//  Created by Nevena Kirova on 7.02.20.
//

import UIKit
import Firebase
import FirebaseFirestore

class FindFriendsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet var findUsersTableView: UITableView!
    
    let db = Firestore.firestore()
    let searchController=UISearchController(searchResultsController: nil)
    
    var usersArray : [String] = []
    var filteredUsers : [String] = []
    var friendsArray : [String] = []
    
    var databaseRef=Database.database().reference()
    let user = Auth.auth().currentUser?.email
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
        extractAllFriends()
        getAllUsers()
        tableView.reloadData()
    }
    
    func extractAllFriends() {
        let friendsCollectionReference = db.collection(Constants.CollectionNames.users).document(user!).collection(Constants.CollectionNames.friends)
        
        friendsCollectionReference.getDocuments(completion: { (snapshot, error) in
            if let e = error {
                print(e)
            } else {
                for doc in snapshot!.documents{
                    self.friendsArray.append(doc.documentID)
                }
            }
        })
    }
    
        
    func setupSearch() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    func getAllUsers() {
        db.collection(Constants.CollectionNames.users).addSnapshotListener { (snapshot, error) in
            if let e = error {
                print(e)
            } else {
                for doc in snapshot!.documents  {
                    if(!self.friendsArray.contains(doc.documentID)) {
                        self.usersArray.append(doc.documentID)
                    }
                }
            }
        }
    }

    // MARK: - Table view data source
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredUsers.count
        }
        return self.usersArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.user, for: indexPath) as! UserTableViewCell
            
            var user : String
            
            if searchController.isActive && searchController.searchBar.text != ""{
                
                user = filteredUsers[indexPath.row]
            }
            else{
                user = self.usersArray[indexPath.row]
            }
        cell.profileLabel.text = user

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }


    @IBAction func dismissFindFriendsTableView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    
    func filterContent(searchText:String)
    {
        
        
        self.filteredUsers = self.usersArray.filter{ user in
 
            let username = user

            return(username.lowercased().contains(searchText.lowercased()) && !friendsArray.contains(username) )

        }
        tableView.reloadData()
    }
    
    //MARK: - add Friend

    
}
