//
//  CreateWorkoutViewController.swift
//  FitnessApp
//
//  Created by Mitko on 12/22/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit
import Firebase

class CreateWorkoutViewController: UIViewController{
    let db = Firestore.firestore()
    let muscleGroups = ["Shoulders", "Arms", "Legs",
    "Abs", "Triceps", "Traps", "Back", "Chest"]
    var date : String = ""
//    var workoutManager = WorkoutManager()
    var muscleGroupChosen: String = ""
    @IBOutlet weak var exerciseField: UITextField!
    @IBOutlet weak var repetitionsField: UITextField!
    @IBOutlet weak var muscleGroup: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        muscleGroup.dataSource = self as UIPickerViewDataSource
        muscleGroup.delegate = self as UIPickerViewDelegate
        date = WorkoutManager.shared.date
        
    }
    
    
    
    @IBAction func addExercise(_ sender: UIButton) {
         let muscleGroupChosen = muscleGroups[muscleGroup.selectedRow(inComponent: 0)]
        if let exercise = exerciseField.text, let repetitions = repetitionsField.text, let user = Auth.auth().currentUser {
            let workoutData : [String: Any] = [
                    date : [
                        exercise: [
                            "name": exercise,
                            "repetitions": repetitions,
                            "muscle_group": muscleGroupChosen
                            
                        ]
                    ]
            ]
//                   var newWorkout = Workout(date: date, exercise: exercise, repetitions: Int(repetitions) ?? 0)
            db.collection("users").document(user.email!).setData(workoutData, merge: true)
            
    }
    self.dismiss(animated: true, completion: nil)
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



