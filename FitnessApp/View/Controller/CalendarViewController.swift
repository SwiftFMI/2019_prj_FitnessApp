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
    }
    fileprivate var dateFormater : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    
    @IBAction func toggle(_ sender: Any) {
        if(calendar.scope == .month){
            calendar.setScope(.week, animated: true)
        } else {
            calendar.setScope(.month, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date: \(self.dateFormater.string(from: date))")
        self.currentDate = self.dateFormater.string(from: date)
        let selectedDates = calendar.selectedDates.map({self.dateFormater.string(from: $0)})
        print("selected dates is \(selectedDates)")
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let exercises:[Exercise] = getExercises(date: currentDate)
        return exercises.count
    }
    
    func getExercises(date: String) -> [Exercise] {
        var exercises: [Exercise] = []
        let user = Auth.auth().currentUser?.email
        let exerciseReference = db.collection("\(String(describing: user))")
            exerciseReference.addSnapshotListener { (snapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshotDocuments = snapshot?.documents {
                        for exercise in snapshotDocuments {
                            let data = exercise.data()
                            if let exerciseName = data["exercise"] as? String , let muscleGroup = data["muscle_group"] as? String, let repetitions = data["repetitions"] as? String {
                                let newExercise = Exercise(exercise: exerciseName, repetitions: repetitions, muscleGroup: muscleGroup)
                                exercises.append(newExercise)

                            }
                            
                        }
                    }
                }
        }
        return exercises
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var exercisesForToday = getExercises(date: currentDate)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercise") as! ExerciseTableViewCell
        cell.exerciseName.text = exercisesForToday[indexPath.row].exercise
        cell.repetitions.text = exercisesForToday[indexPath.row].repetitions
        
        return cell
    }
    
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






