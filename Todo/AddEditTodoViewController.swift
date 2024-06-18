import UIKit

protocol AddEditTodoDelegate: AnyObject {
    func didAddTodoItem(_ todoItem: TodoItem)
    func didEditTodoItem(_ todoItem: TodoItem, at indexPath: IndexPath)
}

class AddEditTodoViewController: UIViewController {

    weak var delegate: AddEditTodoDelegate?
    var todoItem: TodoItem?
    var indexPath: IndexPath?
    var selectedDate: Date?

    let titleTextField = UITextField()
    let detailsTextField = UITextField()
    let dateButton = UIButton(type: .system)
    let timeButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()

    init(todoItem: TodoItem? = nil, indexPath: IndexPath? = nil, selectedDate: Date? = nil) {
        self.todoItem = todoItem
        self.indexPath = indexPath
        self.selectedDate = selectedDate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupData()
    }

    func setupViews() {
        view.backgroundColor = .white

        // 제목 텍스트 필드 설정
        titleTextField.placeholder = "Title"
        titleTextField.borderStyle = .roundedRect
        titleTextField.backgroundColor = UIColor(white: 0.95, alpha: 1.0) // 밝은 회색 배경
        titleTextField.textColor = logoBlueColor
        titleTextField.setLeftPaddingPoints(10)
        view.addSubview(titleTextField)

        // 세부사항 텍스트 필드 설정
        detailsTextField.placeholder = "Details"
        detailsTextField.borderStyle = .roundedRect
        detailsTextField.backgroundColor = UIColor(white: 0.95, alpha: 1.0) // 밝은 회색 배경
        detailsTextField.textColor = logoBlueColor
        detailsTextField.setLeftPaddingPoints(10)
        view.addSubview(detailsTextField)

        // 날짜 버튼 설정 (원래대로 되돌림)
        dateButton.setTitle("Select Date", for: .normal)
        dateButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        dateButton.tintColor = logoBlueColor
        dateButton.setTitleColor(logoBlueColor, for: .normal)
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        dateButton.semanticContentAttribute = .forceRightToLeft
        view.addSubview(dateButton)

        // 시간 버튼 설정 (원래대로 되돌림)
        timeButton.setTitle("Select Time", for: .normal)
        timeButton.setImage(UIImage(systemName: "clock"), for: .normal)
        timeButton.tintColor = logoBlueColor
        timeButton.setTitleColor(logoBlueColor, for: .normal)
        timeButton.addTarget(self, action: #selector(timeButtonTapped), for: .touchUpInside)
        timeButton.semanticContentAttribute = .forceRightToLeft
        view.addSubview(timeButton)

        // 저장 버튼 설정
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = logoBlueColor
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)

        // 취소 버튼 설정
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor(white: 0.6, alpha: 1.0), for: .normal) // 조금 더 진한 회색
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        // "New Task" 레이블 설정
        let newTaskLabel = UILabel()
        newTaskLabel.text = "New Task"
        newTaskLabel.font = UIFont.boldSystemFont(ofSize: 20)
        newTaskLabel.textColor = logoBlueColor
        view.addSubview(newTaskLabel)

        // 제약 조건 설정
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        newTaskLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            newTaskLabel.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            newTaskLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func setupConstraints() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        detailsTextField.translatesAutoresizingMaskIntoConstraints = false
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        timeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60), // 약간 아래로 이동
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 50), // 세로 크기 조정

            detailsTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            detailsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            detailsTextField.heightAnchor.constraint(equalToConstant: 50), // 세로 크기 조정

            dateButton.topAnchor.constraint(equalTo: detailsTextField.bottomAnchor, constant: 20),
            dateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateButton.heightAnchor.constraint(equalToConstant: 40),

            timeButton.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 20),
            timeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timeButton.heightAnchor.constraint(equalToConstant: 40),

            saveButton.topAnchor.constraint(equalTo: timeButton.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }



    func setupData() {
        if let todoItem = todoItem {
            titleTextField.text = todoItem.title
            detailsTextField.text = todoItem.details
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateButton.setTitle(dateFormatter.string(from: todoItem.date), for: .normal)
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            timeButton.setTitle(timeFormatter.string(from: timeFormatter.date(from: todoItem.time) ?? Date()), for: .normal)
            datePicker.date = todoItem.date
            if let time = timeFormatter.date(from: todoItem.time) {
                timePicker.date = time
            }
        } else if let selectedDate = selectedDate {
            datePicker.date = selectedDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateButton.setTitle(dateFormatter.string(from: selectedDate), for: .normal)
        }
    }

    @objc func dateButtonTapped() {
        let alert = UIAlertController(title: "Select Date", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)

        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        datePicker.frame = CGRect(x: 0, y: 0, width: alert.view.bounds.size.width, height: 200)
        alert.view.addSubview(datePicker)

        let heightConstraint = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
        alert.view.addConstraint(heightConstraint)

        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            let selectedDate = self.datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.dateButton.setTitle(dateFormatter.string(from: selectedDate), for: .normal)
            self.selectedDate = selectedDate
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    @objc func timeButtonTapped() {
        let alert = UIAlertController(title: "Select Time", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)

        timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }

        timePicker.frame = CGRect(x: 0, y: 0, width: alert.view.bounds.size.width, height: 200)
        alert.view.addSubview(timePicker)

        let heightConstraint = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
        alert.view.addConstraint(heightConstraint)

        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            let selectedTime = self.timePicker.date
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            self.timeButton.setTitle(timeFormatter.string(from: selectedTime), for: .normal)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
                return
            }
        
        let details = detailsTextField.text ?? ""

        let date: Date
        if dateButton.title(for: .normal) == "Select Date", let existingDate = todoItem?.date {
            date = existingDate
        } else {
            date = selectedDate ?? datePicker.date
        }

        let time: String
        if timeButton.title(for: .normal) == "Select Time", let existingTime = todoItem?.time {
            time = existingTime
        } else {
            time = DateFormatter.timeFormatter.string(from: timePicker.date)
        }

        let completed = todoItem?.completed ?? false
        let newTodoItem = TodoItem(id: todoItem?.id, title: title, details: details, completed: completed, date: date, time: time)

        if let indexPath = indexPath {
            delegate?.didEditTodoItem(newTodoItem, at: indexPath)
        } else {
            delegate?.didAddTodoItem(newTodoItem)
        }

        dismiss(animated: true, completion: nil)
    }
}

extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
