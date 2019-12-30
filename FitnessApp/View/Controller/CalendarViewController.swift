import UIKit
import Firebase
import FSCalendar

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    
    var currentDate = ""

    
    let db = Firestore.firestore()
    @IBOutlet weak var tableView: UITableView!
    fileprivate weak var calendar : FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        generateCalendar()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    fileprivate var dateFormater : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    
    @IBAction func toggle(_ sender: Any) {
        if(calendar.scope == .month){
            calendar.scope = .week
        } else {
            calendar.scope = .month
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        WorkoutManager.shared.exercises.removeAll()
        print("did select date: \(self.dateFormater.string(from: date))")
        self.currentDate = self.dateFormater.string(from: date)
        getExercises(date: currentDate)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
            WorkoutManager.shared.currentCount = WorkoutManager.shared.exercises.count
            print(WorkoutManager.shared.currentCount)
            self.tableView.reloadData()
        }

        

        
//        let selectedDates = calendar.selectedDates.map({self.dateFormater.string(from: $0)})
//        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        
    }
    
    
    @IBAction func addExercise(_ sender: Any) {
        let destinationVC = storyboard?.instantiateViewController(identifier: "createWorkout") as! CreateWorkoutViewController
        destinationVC.date = currentDate
        WorkoutManager.shared.date = currentDate
        print(currentDate)
        print(destinationVC.date)
    }
    
    
    
   
    
    func getExercises(date: String) {
        
        let user = Auth.auth().currentUser?.email
        let exerciseReference = db.collection("users").document(user!).collection("workouts")
        
        exerciseReference.addSnapshotListener { (snapshot, error) in
            if let e = error{
                print(e.localizedDescription)
            } else {
                if snapshot == nil || snapshot?.documents.isEmpty == true{
                    return
                }
                    else {
                    for doc in snapshot!.documents {
                            if doc.documentID == date && doc.exists{
                                var newExercise : Exercise
                                for data in doc.data() as! [String: [String:Any]]{
                                    if let repetitions = data.value["repetitions"] as? String, let muscleGroup = data.value["muscle_group"] as? String, let sets = data.value["sets"] as? String {
                                        newExercise = Exercise(exercise: data.key, repetitions: repetitions, muscleGroup: muscleGroup, sets: sets)
                                            print("new Exercise: \(newExercise.exercise), repetitions: \(newExercise.repetitions), muscle group: \(newExercise.muscleGroup)")
                                            WorkoutManager.shared.exercises.append(newExercise)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                }
        
    }
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        let exercises:[Exercise] = getExercises(date: currentDate)
    //        return exercises.count
        
        return WorkoutManager.shared.currentCount
    }
    
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let exercise = WorkoutManager.shared.exercises[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "exercise") as! ExerciseTableViewCell
            
            cell.exerciseName.text = exercise.exercise
            cell.repetitions.text = "\(exercise.repetitions) reps"
            cell.sets.text = "\(exercise.sets) sets"
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }
    
    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var exercisesForToday = getExercises(date: currentDate)
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "exercise") as! ExerciseTableViewCell
//        cell.exerciseName.text = exercisesForToday[indexPath.row].exercise
//        cell.repetitions.text = exercisesForToday[indexPath.row].repetitions
//
//        return cell
//    }
    
    func generateCalendar() {
        let calendar = FSCalendar(frame: CGRect(x: 50, y: 100, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.accessibilityIdentifier = "calendar"
        view.addSubview(calendar)
        
        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 275).isActive = true
        calendar.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        self.calendar = calendar
    }
}






