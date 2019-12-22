import UIKit
import FSCalendar

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate weak var calendar : FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        generateCalendar()
    }
    fileprivate var dateFormater : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
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
        let selectedDates = calendar.selectedDates.map({self.dateFormater.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    @IBAction func addExercise(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
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






