//
//  CalendarCalc.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 07.03.2023.
//

import Foundation

struct Month {
    
    struct Week {
        var number: Int
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
        let endComp = calendar.dateComponents(
            dateComponents,
            from: end)
        
        array.insert(contentsOf: Array<Date?>(repeating: nil, count: (startComp.weekday! - calendar.firstWeekday + 7) % 7), at: 0)
        array.append(contentsOf: Array<Date?>(repeating: nil, count: 7 - array.count % 7))
        
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
            return Week(number: monthNumber * 100 + item.offset, values: item.element)
        }
        
        return Month(
            id: "\(components.month!)+\(components.year!)",
            name: name,
            days: weekdays,
            values: weeks
        )
    }
}
