//
//  Constants.swift
//  FitnessApp
//
//  Created by Mitko on 1/15/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit

struct Constants {
    struct Profile {
        static let email = "m_penkov@gmail.com"
        static let password = "123456"
       
    }
    
    struct ControllersIdentifiers {
        static let tabController = "tabController"
        static let setupController = "setup"
        static let createWorkout = "createWorkout"
        static let createExercise = "createExercise"
        static let createRoutine = "CreateRoutine"
        static let workoutPreview = "workoutPreview"
        static let chooseWorkout = "chooseWorkout"
        static let login = "login"
        static let yourFriends = "yourFriends"
    }
    
    
    struct CollectionNames {
        static let users = "users"
        static let schedueledWorkouts = "Scheduled workouts"
        static let customWorkouts = "Custom Workouts"
        static let friends = "friends"
        
    }
    
    struct DocumentNames {
        
    }
    
    struct DocumentFields {
        static let username = "username"
        static let repetitions = "repetitions"
        static let muscleGroup = "muscle_group"
        static let sets = "sets"
        static let job = "job"
        static let age = "age"
        static let timeOfCreation = "timeOfCreation"
        static let exerciseName = "exerciseName"
        static let date = "date"
        static let done = "done"
    }
    
    struct ImageCollections {
        static let profileImages = "profileImages"
        static let progressImages = "progressImages"
    }
    
    struct CellIdentifiers {
        static let exercise = "exercise"
        static let routine = "workoutRoutine"
         static let user = "user"
    }
    
    struct DateFormatter {
        static let format = "yyyy-MM-dd"
    }
    
    struct SwipeActionTitles {
        static let done = "Done"
        static let delete = "Delete"
    }
    
    struct UserDef {
        static let email = "email"
        static let password = "password"
        static let username = "username"
        static let profileImage = "profileImage"
    }
    
    struct SwipeAction {
        static let done = "Done"
        static let delete = "Delete"
    }
}
