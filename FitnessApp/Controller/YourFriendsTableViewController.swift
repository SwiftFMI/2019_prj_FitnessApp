//
//  YourFriendsTableViewController.swift
//  FitnessApp
//
//  Created by Mitko on 2/19/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit
import Firebase
import NotificationBannerSwift
import FirebaseFirestore

class YourFriendsTableViewController: UITableViewController {
    
    let user = Auth.auth().currentUser?.email
    var friends : [String] = []
    let db = Firestore.firestore()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl?.addTarget(self, action: #selector(refreshFriends(_:)), for: .valueChanged)
        

    }
    
    @objc func refreshFriends(_ sender: Any) {
        getAllFriends()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getAllFriends()
        
    }
    
    func getAllFriends() {
        friends.removeAll()
        let friendsReference = db.collection(Constants.CollectionNames.users).document(user!).collection(Constants.CollectionNames.friends)
        friendsReference.getDocuments { (snapshot, error) in
            if let e = error {
                print(e)
            } else {
                for doc in snapshot!.documents {
                    self.friends.append(doc.documentID)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5    ) {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel!.text = friends[indexPath.row]
        return cell
    }
    
    func showBannerForRemovedFriend(name: String) {
        let banner = NotificationBanner(title: "\(name) was removed from your friend list", subtitle: "nice", leftView: UIView(), rightView: UIView(), style: .success)
        banner.show()
        
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let friendToDelete = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        let delete = UIContextualAction(style: .destructive, title: "Remove") { (action, view, nil) in
            if let user = self.user {
                let friendsReference = self.db.collection(Constants.CollectionNames.users).document(user).collection(Constants.CollectionNames.friends).document(friendToDelete!).delete()
                self.friends.removeAll { (user) -> Bool in
                    user == friendToDelete!
                }
                self.showBannerForRemovedFriend(name: friendToDelete!)
                
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        dismiss(animated: true, completion: nil)
        delete.backgroundColor = #colorLiteral(red: 0.9569, green: 0.3647, blue: 0.3647, alpha: 1)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
