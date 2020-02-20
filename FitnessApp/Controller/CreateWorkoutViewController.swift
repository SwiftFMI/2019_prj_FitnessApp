//
//  CreateWorkoutViewController.swift
//  FitnessApp
//
//  Created by Mitko on 1/9/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

protocol addWorkoutRoutineDelegate {
    func addWorkout(workout: String)
}

class CreateWorkoutViewController: UIViewController, UITextFieldDelegate {

    let db = Firestore.firestore()
    let muscleGroups : [String] = ["Shoulders", "Biceps",
    "Abs","Tighs", "Calves", "Back", "Chest"]
    
    var muscleGroupChosen: String = ""
    var exercises : [Exercise] = []
    

    
    @IBOutlet weak var muscleGroup: UIPickerView!
    
    @IBOutlet weak var workoutTitle: UITextField!
    @IBOutlet weak var exerciseNameField: UITextField!
    @IBOutlet weak var setsField: UITextField!
    @IBOutlet weak var repsField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var textFields : [UITextField] = []
    
    var addWorkoutRoutineDelegate : addWorkoutRoutineDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        muscleGroup.dataSource = self
        muscleGroup.delegate = self
        workoutTitle.delegate = self
        exerciseNameField.delegate = self
        setsField.delegate = self
        repsField.delegate = self 
        exercises.removeAll()
        self.textFields = [workoutTitle, exerciseNameField,setsField,repsField]
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        
        
        
        let date = Date.timeIntervalBetween1970AndReferenceDate
        muscleGroupChosen = muscleGroups[muscleGroup.selectedRow(inComponent: 0)]
        
        
        if let workoutTitle = workoutTitle.text, let exerciseName = exerciseNameField.text as? String, let sets = setsField.text as? String, let reps = repsField.text as? String, let user = Auth.auth().currentUser {
            let newExercise = Exercise(exerciseName: exerciseName, repetitions: reps, muscleGroup: muscleGroupChosen, timeOfCreation: Date().timeIntervalSince1970 , sets: sets, done: false)
            exercises.append(newExercise)
            let customWorkoutData : [String: Any] = [
                    exerciseName : [
                        Constants.DocumentFields.sets: sets,
                        Constants.DocumentFields.repetitions : reps,
                        Constants.DocumentFields.date: date,
                        Constants.DocumentFields.muscleGroup : muscleGroupChosen,
                        Constants.DocumentFields.done: false
                    ]
            ]
        db.collection(Constants.CollectionNames.users).document(user.email!).collection(Constants.CollectionNames.customWorkouts).document(workoutTitle).setData(customWorkoutData, merge: true)
            
            tableView.reloadData()
        }
    }
    
    @IBAction func generateWorkout(_ sender: Any) {
        let workoutCreated = workoutTitle.text!
        addWorkoutRoutineDelegate.addWorkout(workout: workoutCreated)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                textField.resignFirstResponder()
                return true
            }
          
    
}
extension CreateWorkoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exercise = exercises[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = exercise.exerciseName
        return cell
    }
    
}

extension CreateWorkoutViewController : UIPickerViewDataSource, UIPickerViewDelegate {
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
