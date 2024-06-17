import JTAppleCalendar
import UIKit

let logoBlueColor = UIColor(red: 44/255, green: 83/255, blue: 166/255, alpha: 1.0) // 로고의 파란색
let logoBlueColor2 = UIColor(red: 103/255, green: 141/255, blue: 171/255, alpha: 1.0)
let logoBlueColor3 = UIColor(red: 219/255, green: 236/255, blue: 244/255, alpha: 1.0)
let lightGrayColor = UIColor(white: 0.95, alpha: 1.0)
let mediumGrayColor = UIColor(white: 0.6, alpha: 1.0)

class TodoCalendar: JTACMonthView {
    var eventDates: Set<Date> = []

    override init() {
        super.init()
        self.setupCalendar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupCalendar()
    }

    private func setupCalendar() {
        self.calendarDelegate = self
        self.calendarDataSource = self
        self.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        self.register(CalendarHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarHeader")
        self.scrollDirection = .horizontal
        self.scrollingMode = .stopAtEachCalendarFrame
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }

    func updateEventDates(_ dates: Set<Date>) {
        self.eventDates = dates
        self.reloadData()
    }
}

extension TodoCalendar: JTACMonthViewDelegate, JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())! // 과거 1년
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())! // 미래 1년
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }

    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.configure(cellState: cellState, hasEvent: eventDates.contains(date))
        return cell
    }

    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("DateSelected"), object: date)
        (cell as? CalendarCell)?.handleCellSelection(cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        (cell as? CalendarCell)?.handleCellSelection(cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        (cell as? CalendarCell)?.configure(cellState: cellState, hasEvent: eventDates.contains(date))
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }

    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "CalendarHeader", for: indexPath) as! CalendarHeader
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        header.titleLabel.text = dateFormatter.string(from: range.start)
        return header
    }

    func calendar(_ calendar: JTACMonthView, sizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.width, height: 50)
    }

    func calendarDidScroll(_ calendar: JTACMonthView) {
        let visibleDates = calendar.visibleDates()
        if let currentMonthDate = visibleDates.monthDates.first?.date {
            NotificationCenter.default.post(name: NSNotification.Name("MonthChanged"), object: currentMonthDate)
        }
    }
}

class CalendarCell: JTACDayCell {
    var dateLabel: UILabel!
    var selectedView: UIView!
    var eventIndicator: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        dateLabel = UILabel()
        dateLabel.textAlignment = .center

        selectedView = UIView()
        selectedView.backgroundColor = logoBlueColor3 // 파란색
        selectedView.layer.cornerRadius = 20
        selectedView.isHidden = true

        eventIndicator = UIView()
        eventIndicator.backgroundColor = logoBlueColor // 연한 회색
        eventIndicator.layer.cornerRadius = 3
        eventIndicator.isHidden = true

        contentView.addSubview(selectedView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(eventIndicator)

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        eventIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            selectedView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectedView.widthAnchor.constraint(equalToConstant: 45),
            selectedView.heightAnchor.constraint(equalToConstant: 45),

            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            eventIndicator.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            eventIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            eventIndicator.widthAnchor.constraint(equalToConstant: 6),
            eventIndicator.heightAnchor.constraint(equalToConstant: 6)
        ])
    }

    func configure(cellState: CellState, hasEvent: Bool) {
        dateLabel.text = cellState.text
        handleCellSelection(cellState: cellState)
        eventIndicator.isHidden = !hasEvent
        if cellState.dateBelongsTo != .thisMonth {
            dateLabel.textColor = UIColor.lightGray
        } else {
            dateLabel.textColor = UIColor.black
        }
    }

    func handleCellSelection(cellState: CellState) {
        selectedView.isHidden = !cellState.isSelected
    }
}
