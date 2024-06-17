//// CalendarCell.swift
//import JTAppleCalendar
//import UIKit
//
//class CalendarCell: JTACDayCell {
//    var dateLabel: UILabel!
//    var selectedView: UIView!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupViews()
//    }
//
//    private func setupViews() {
//        dateLabel = UILabel()
//        dateLabel.textAlignment = .center
//
//        selectedView = UIView()
//        selectedView.backgroundColor = .blue
//        selectedView.layer.cornerRadius = 15
//        selectedView.isHidden = true
//
//        contentView.addSubview(selectedView)
//        contentView.addSubview(dateLabel)
//
//        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        selectedView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            selectedView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            selectedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            selectedView.widthAnchor.constraint(equalToConstant: 30),
//            selectedView.heightAnchor.constraint(equalToConstant: 30),
//
//            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ])
//    }
//
//    func configure(cellState: CellState) {
//        dateLabel.text = cellState.text
//        handleCellSelection(cellState: cellState)
//    }
//
//    private func handleCellSelection(cellState: CellState) {
//        selectedView.isHidden = !cellState.isSelected
//    }
//}
