import UIKit

final class CalendarViewController: UIViewController {

    private let calendarView = UICalendarView()
    
    // TEMP: dates to show blue dots on
    private var markedDates: Set<DateComponents> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Calendar"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )

        setupCalendar()
        markToday() // for now, mark today as blue dot
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    private func setupCalendar() {
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = .current
        calendarView.locale = .current

        // 👇 This enables dots & decorations
        calendarView.delegate = self

        view.addSubview(calendarView)

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: nil)

    }
    private func markToday() {
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        markedDates.insert(today)
    }
    

}
extension CalendarViewController: UICalendarViewDelegate {

    func calendarView(
        _ calendarView: UICalendarView,
        decorationFor dateComponents: DateComponents
    ) -> UICalendarView.Decoration? {

        let isCompleted = markedDates.contains(dateComponents)

        return .customView {
            CalendarDateBoxView(isCompleted: isCompleted)
        }
    }
}



