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
        let date: Date?
        let value: String
        
        init(date: Date?) {
            guard let date = date else {
                value = " "
                id = UUID().uuidString
                self.date = nil
                return
            }
            
            let formatter = ISO8601DateFormatter()

            id = formatter.string(from: date)
            self.date = date
            self.value = "\(calendar.component(.day, from: date))"
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
        return Month(id: UUID().uuidString, name: getName(from: date), values: getWeeks(from: date))
    }
    
    // MARK: - Private methods
    
    static private func getName(from date: Date) -> String {
        return monthFormatter.string(from: date).capitalized
    }
    
    static private func getMonthDates(from date: Date) -> [Date] {
        return datesRange(from: date.startOfMonth(), to: date.endOfMonth())
    }
    
    static private func makeFullWeeks(array: [Date]) -> [Date?] {
        guard let start = array.first else {
            fatalError("Empty Dates Array")
        }
        
        var result: [Date?] = array
        
        let startComponents = calendar.dateComponents(
            dateComponents,
            from: start)
        
        result.insert(
            contentsOf:
                Array<Date?>(
                    repeating: nil,
                    count: (startComponents.weekday! - calendar.firstWeekday + 7) % 7),
            at: 0)
        let daysAfterCount = 7 - result.count % 7
        if daysAfterCount != 7 {
            result.append(contentsOf: Array<Date?>(repeating: nil, count: daysAfterCount))
        }
        
        return result
    }
    
    static private func makeDays(array: [Date]) -> [Day] {
        let fullWeeks = makeFullWeeks(array: array)
        return fullWeeks.map { Day(date: $0) }
    }
    
    static private func makeWeeks(days: [Day]) -> [Week] {
        let weeks = days.chunked(into: 7)
        
        return weeks.enumerated().map { week in
            guard let date = week.element.first(where: { $0.value != " " })!.date,
                  let weekNumber = calendar.dateComponents(dateComponents, from: date).weekOfYear else {
                fatalError("empty week!")
            }
            return Week(number: "\(weekNumber)", values: week.element)
        }
    }
    
    static private func getWeeks(from date: Date) -> [Week] {
        let monthDates: [Date] = getMonthDates(from: date)
        let days = makeDays(array: monthDates)
        
        return makeWeeks(days: days)
    }
}
