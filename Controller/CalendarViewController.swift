//
//  CalendarViewController.swift
//  BoxOffice
//
//  Created by Andrew on 2023/04/05.
//

import UIKit

class CalendarViewController: UIViewController {
    
    var delegate: CalendarDelegate?
    var selectedDate = Date()
    
    private let calendarView = {
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.locale = Locale(identifier: "ko_KR")
        
        return calendarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        restrictDateRange()
        configureCalendarSelection()
    }
    
    private func restrictDateRange() {
        let yesterday = Date.yesterday ?? Date()
        let calendar = Calendar.current
        let yesterdayComponents = calendar.dateComponents([.year, .month, .day], from: yesterday)
        let year = yesterdayComponents.year
        let month = yesterdayComponents.month
        let day = yesterdayComponents.day
        
        let fromDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2012, month: 1, day: 1)
        let toDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), year: year, month: month, day: day)
        
        guard let fromDate = fromDateComponents.date, let toDate = toDateComponents.date else {
            return
        }
        
        let calendarViewDateRange = DateInterval(start: fromDate, end: toDate)
        calendarView.availableDateRange = calendarViewDateRange
    }
    
    private func configureCalendarSelection() {
        let selection = UICalendarSelectionSingleDate(delegate: self)
        let calendar = Calendar.current
        let selectedComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let selectedYear = selectedComponents.year
        let selectedMonth = selectedComponents.month
        let selectedDay = selectedComponents.day
        
        calendarView.selectionBehavior = selection
        selection.selectedDate = DateComponents(calendar: calendar, year: selectedYear, month: selectedMonth, day: selectedDay)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - UICalendarSelectionSingleDateDelegate
extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let selectedDate = dateComponents?.date else {
            return
        }
        
        delegate?.changeDate(selectedDate)
        
        dismiss(animated: true)
    }
}