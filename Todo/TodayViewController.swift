import UIKit
import FirebaseFirestore

class TodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TodoItemTableViewCellDelegate {
    
    var tableView: UITableView!
    var addTaskButton: UIButton!
    
    var incompleteTasks: [TodoItem] = []
    var completedTasks: [TodoItem] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchTasks()
    }
        
    
    func setupViews() {
        title = "Today"
        view.backgroundColor = .white
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: "TodoItemCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        addTaskButton = UIButton(type: .system)
        addTaskButton.setTitle("+ Add Task", for: .normal)
        addTaskButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        
        view.addSubview(addTaskButton)
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func addTaskButtonTapped() {
        let addEditVC = AddEditTodoViewController(selectedDate: Date())
        addEditVC.modalPresentationStyle = .overFullScreen
        present(addEditVC, animated: true, completion: nil)
    }
    
    @objc func fetchTasks() {
        let today = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: today)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
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

extension Notification.Name {
    static let didAddTodayTask = Notification.Name("didAddTodayTask")
}
