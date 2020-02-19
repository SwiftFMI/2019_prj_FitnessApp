//
//  CreateExerciseTableViewController.swift
//  FitnessApp
//
//  Created by Mitko on 1/17/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import FirebaseFirestore
import UIKit
import Firebase

protocol AddNewExerciseDelegate {
    func addExercice(date: String)
}

class CreateExerciseTableViewController: UITableViewController {
        let db = Firestore.firestore()
        let muscleGroups = ["Shoulders", "Biceps",
        "Abs","Tighs", "Calves", "Back", "Chest"]
        var date : String = ""
    //    var workoutManager = WorkoutManager()
        var muscleGroupChosen: String = ""
    var allFilled : Bool = false
    
    @IBOutlet weak var muscleGroup: UIPickerView!
    
    @IBOutlet weak var exerciseField: UITextField!
    @IBOutlet weak var setsField: UITextField!
    @IBOutlet weak var repetitionsField: UITextField!
    var addExerciseDelegate : AddNewExerciseDelegate?
    
    var textFields : [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        muscleGroup.dataSource = self as UIPickerViewDataSource
        muscleGroup.delegate = self as UIPickerViewDelegate
        date = WorkoutManager.shared.date
        self.textFields = [exerciseField, setsField, repetitionsField]
        for tf in textFields {
            tf.borderStyle = .none
        }
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
       @IBAction func addExercise(_ sender: UIButton) {
        let allHaveText = textFields.allSatisfy { $0.text?.isEmpty == false }
        if allHaveText {
            let muscleGroupChosen = muscleGroups[muscleGroup.selectedRow(inComponent: 0)]
                if let exercise = exerciseField.text, let repetitions = repetitionsField.text, let sets =  setsField.text, let user = Auth.auth().currentUser {
                    let workoutData : [String: Any] = [
                                exercise: [
                                    Constants.DocumentFields.exerciseName: exercise,
                                    Constants.DocumentFields.repetitions: repetitions,
                                    Constants.DocumentFields.muscleGroup: muscleGroupChosen,
                                    Constants.DocumentFields.timeOfCreation: Date().timeIntervalSince1970,
                                    Constants.DocumentFields.sets: sets,
                                    "done": false
                                ]
                    ]
                    WorkoutManager.shared.date = date
                    db.collection(Constants.CollectionNames.users).document(user.email!).collection(Constants.CollectionNames.schedueledWorkouts).document(date).setData(workoutData, merge: true)
                    addExerciseDelegate!.addExercice(date: date)
                    self.dismiss(animated: true, completion: nil)
            }
        }
        else {
            print("not everything has text")
        }
        
    }
            
        
//            let destinationVC = storyboard?.instantiateViewController(identifier: "calendar") as! CalendarViewController
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
}
extension CreateExerciseTableViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return muscleGroups[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return muscleGroups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        muscleGroupChosen = muscleGroups[row]
    }
}

