//
//  CalendarCalc.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 07.03.2023.
//

import Foundation

struct Month {
    
    struct Day {
        let id: String
        let date: Date
        let value: String
        let isCurrentMonth: Bool
        
        init(date: Date, isCurrentMonth: Bool) {
            let formatter = ISO8601DateFormatter()

            id = formatter.string(from: date)
            self.date = date
            self.value = "\(calendar.component(.day, from: date))"
            self.isCurrentMonth = isCurrentMonth
        }
    }
    
    struct Week {
        var number: String
        var values: [Day]
    }
    
    // MARK: - Variables
    
    var id: String
    var name: String
    var values: [Week]
    
    var weekDaysNames: [String] {
        var weekdays = calendar.veryShortWeekdaySymbols
        let first = weekdays.remove(at: 0)
        weekdays.append(first)
        return weekdays
    }
    
    // MARK: - Public methods
    
    mutating func update(_ date: Date) {
        self.name = Month.getName(from: date)
        self.values = Month.getWeeks(from: date)
    }
    
    
    static func generate(for date: Date) -> Month {
        return Month(
            id: UUID().uuidString,
            name: getName(from: date),
            values: getWeeks(from: date))
    }
    
    // MARK: - Private methods
    
    static private func getName(from date: Date) -> String {
        return monthFormatter.string(from: date).capitalized
    }
    
    static private func getMonthDates(from date: Date) -> [Date] {
        let start = date.startOfMonth()
        let end = date.endOfMonth()
        
        var result = datesRange(from: start, to: end)
        
        let startComponents = calendar.dateComponents(
            dateComponents,
            from: start)
        
        let daysBefore = (startComponents.weekday! - calendar.firstWeekday + 7) % 7
        let weekStart = calendar.date(byAdding: .day, value: -daysBefore, to: start)!
        result.insert(
            contentsOf: datesRange(
                from: weekStart,
                to: calendar.date(byAdding: .day, value: -1, to: start)!),
            at: 0)
        
        let daysAfter = 7 - result.count % 7
        if daysAfter != 7 {
            let weekEnd = calendar.date(byAdding: .day, value: daysAfter, to: end)!
            result.append(
                contentsOf: datesRange(
                    from: calendar.date(byAdding: .day, value: 1, to: end)!,
                    to: weekEnd))
        }
        
        return result
    }
    
    static private func makeDays(array: [Date], for date: Date) -> [Day] {
        let currentMonth = calendar.component(.month, from: date)
        return array.map { element in
            return Day(
                date: element,
                isCurrentMonth: currentMonth == calendar.component(.month, from: element))
        }
    }
    
    static private func makeWeeks(days: [Day]) -> [Week] {
        return days.chunked(into: 7)
            .map { week in
                let date = week.first!.date
                let weekNumber = calendar.dateComponents(dateComponents, from: date).weekOfYear!
                return Week(number: "\(weekNumber)", values: week)
            }
    }
    
    // TODO: Добавить опциию отображения дней соседних месяцев
    static private func getWeeks(from date: Date) -> [Week] {
        let monthDates: [Date] = getMonthDates(from: date)
        let days = makeDays(array: monthDates, for: date)
        
        return makeWeeks(days: days)
    }
}
