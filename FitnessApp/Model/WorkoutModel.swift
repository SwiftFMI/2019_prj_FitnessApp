//
//  WorkoutModel.swift
//  FitnessApp
//
//  Created by Mitko on 12/21/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit

struct Exercise {
    var exercise : String
    var repetitions : String
    var muscleGroup : String
}

class WorkoutManager {
    static let shared = WorkoutManager()
    var exercises : [Exercise] = []
    var currentCount : Int = 0
    var date : String = ""
    private init() { }
    
}


