import UIKit
import FirebaseFirestore

class TodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TodoItemTableViewCellDelegate {
    
    var tableView: UITableView!
    var addTaskButton: UIButton!
    
    var incompleteTasks: [TodoItem] = []
    var completedTasks: [TodoItem] = []
    var dateLabel: UILabel!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchTasks()
    }
        
    
    func setupViews() {
        title = "Today"
        view.backgroundColor = .white
        
        dateLabel = UILabel()
        dateLabel.font = UIFont.boldSystemFont(ofSize: 24)
        dateLabel.textAlignment = .left
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: "TodoItemCell")
        view.addSubview(dateLabel)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
        ])
    }
    
    @objc func fetchTasks() {
        let today = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: today)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy" // 날짜 형식 설정
        dateLabel.text = dateFormatter.string(from: today)
        
        db.collection("events")
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.incompleteTasks = []
                    self.completedTasks = []
                    
                    for document in snapshot!.documents {
                        let data = document.data()
                        let id = document.documentID
                        let date = today
                        if let title = data["title"] as? String,
                           let details = data["details"] as? String,
                           let time = data["time"] as? String,
                           let completed = data["completed"] as? Bool {
                            let todoItem = TodoItem(id: id, title: title, details: details, completed: completed, date: date, time: time)
                            if completed {
                                self.completedTasks.append(todoItem)
                            } else {
                                self.incompleteTasks.append(todoItem)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? incompleteTasks.count : completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) as! TodoItemTableViewCell
        cell.delegate = self
        let todoItem = indexPath.section == 0 ? incompleteTasks[indexPath.row] : completedTasks[indexPath.row]
        cell.configure(with: todoItem)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Incomplete" : "Completed"
    }
    
    // MARK: - TodoItemTableViewCellDelegate
    
    func didToggleCheckbox(for item: TodoItem, isCompleted: Bool) {
        guard let documentID = item.id else {
            print("Document ID가 없습니다.")
            return
        }
        db.collection("events").document(documentID).updateData(["completed": isCompleted]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                self.fetchTasks()
            }
        }
    }
}
