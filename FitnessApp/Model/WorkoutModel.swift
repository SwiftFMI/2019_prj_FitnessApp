//
//  WorkoutModel.swift
//  FitnessApp
//
//  Created by Mitko on 12/21/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit

class WorkoutManager {
    static let shared = WorkoutManager()
    var date: String = ""
    var exercises : [String] = []
    var reps : [Int] = []
    private init() { }
    
}
