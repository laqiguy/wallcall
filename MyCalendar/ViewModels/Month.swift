//
//  CalendarCalc.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 07.03.2023.
//

import Foundation

struct Month {
    
    struct Week {
        var number: String
        var values: [String]
    }
    
    var id: String
    var name: String
    var days: [String]
    var values: [Week]
    
    static func generate(_ date: Date) -> Month {
        let components = calendar.dateComponents(dateComponents, from: date)
        let monthNumber = components.month ?? 42
        
        let start = date.startOfMonth()
        let end = date.endOfMonth()
        
        var array: [Date?] = datesRange(from: start, to: end)
        
        let startComp = calendar.dateComponents(
            dateComponents,
            from: start)
        
        array.insert(contentsOf: Array<Date?>(repeating: nil, count: (startComp.weekday! - calendar.firstWeekday + 7) % 7), at: 0)
        let daysAfter = 7 - array.count % 7
        if daysAfter != 7 {
            array.append(contentsOf: Array<Date?>(repeating: nil, count: daysAfter))
        }
        
        let dates = array.chunked(into: 7).map { dates in
            return dates.map { date in
                guard let date else {
                    return " "
                }
                return "\(calendar.component(.day, from: date))"
            }
        }
        var weekdays = calendar.veryShortWeekdaySymbols
        let first = weekdays.remove(at: 0)
        weekdays.append(first)
        
        let name = monthFormatter.string(from: date).capitalized
        let weeks = dates.enumerated().map { item in
            let day = Int(item.element.first(where: { $0 != " " })!)
            var weekNumber = " "
            if let date = DateComponents(calendar: calendar, year: components.year, month: components.month, day: day).date,
               let weekDay = calendar.dateComponents(dateComponents, from: date).weekOfYear {
                weekNumber = "\(weekDay)"
            }
            return Week(number: weekNumber, values: item.element)
        }
        
        return Month(
            id: "\(components.month!)+\(components.year!)",
            name: name,
            days: weekdays,
            values: weeks
        )
    }
}
