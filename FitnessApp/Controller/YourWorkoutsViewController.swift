//
//  YourWorkoutsViewController.swift
//  FitnessApp
//
//  Created by Mitko on 1/11/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class YourWorkoutsViewController: UIViewController {
    var workouts : [String] = []
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        displayWorkouts()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
    @IBAction func createRoutine(_ sender: Any) {
        let destinationVC = storyboard?.instantiateViewController(identifier: Constants.ControllersIdentifiers.createRoutine) as! CreateWorkoutViewController
        destinationVC.addWorkoutRoutineDelegate = self
        present(destinationVC, animated: true, completion: nil)
    }
    
    func displayWorkouts() {
        WorkoutManager.shared.workouts.removeAll()
        getWorkouts()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            WorkoutManager.shared.numberOfWorkouts = WorkoutManager.shared.workouts.count
            self.tableView.reloadData()
        }
    }
    
    func getWorkouts() {
        WorkoutManager.shared.workouts.removeAll()
        if let user = Auth.auth().currentUser?.email
        {
            let workoutRef = db.collection(Constants.CollectionNames.users).document(user).collection(Constants.CollectionNames.customWorkouts)
        workoutRef.addSnapshotListener { (snapshot, error) in
            if let e = error {
                print(e)
            } else {
                for doc in snapshot!.documents {
                    WorkoutManager.shared.workouts.append(doc.documentID)
                    WorkoutManager.shared.numberOfWorkouts += 1
                    print(doc.documentID)
                }
            }
        }
     }
    }
    
}


extension YourWorkoutsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutManager.shared.numberOfWorkouts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.routine) as! WorkoutRoutineTableViewCell
        cell.routineTitle.text = WorkoutManager.shared.workouts[indexPath.row]
        cell.background.layer.cornerRadius = 6
        cell.background.layer.shadowColor = UIColor.black.cgColor
        cell.background.layer.shadowOpacity = 0.4
        cell.background.layer.shadowRadius = 6
        cell.background.layer.shadowOffset = CGSize(width: 2, height: 3)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workoutChosen = workouts[indexPath.row]
        let destinationVC = storyboard?.instantiateViewController(identifier: Constants.ControllersIdentifiers.workoutPreview) as! CustomWorkoutPreviewViewController
        destinationVC.workout = workoutChosen
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: Constants.SwipeAction.delete) { (action, view, nil) in
            let workoutToBeDeleted = WorkoutManager.shared.workouts[indexPath.row]
            if let user = Auth.auth().currentUser?.email {
            self.db.collection(Constants.CollectionNames.users).document(user).collection(Constants.CollectionNames.customWorkouts).document(workoutToBeDeleted).delete()
                
                WorkoutManager.shared.numberOfWorkouts -= 1
                WorkoutManager.shared.workouts.removeAll { (workout) -> Bool in
                    return workout == workoutToBeDeleted
                }
                tableView.deleteRows(at: [indexPath], with: .bottom)
            }
        }
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
   
    
}

extension YourWorkoutsViewController: addWorkoutRoutineDelegate {
    func addWorkout(workout: String) {
        
        tableView.reloadData()
        //        WorkoutManager.shared.exercises.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.displayWorkouts()
        }
    }
}
