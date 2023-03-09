//
//  CalendarCalc.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 07.03.2023.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

func datesRange(from: Date, to: Date) -> [Date] {
    if from > to { return [Date]() }

    var tempDate = from
    var array = [tempDate]

    while tempDate < to {
        tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
        array.append(tempDate)
    }

    return array
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.year, .month],
                from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

let calendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "ru_RU")
    calendar.firstWeekday = 2

    return calendar
}()
let dateComponents: Set<Calendar.Component> = [.day, .month, .year, .weekday, .weekdayOrdinal]

struct Week {
    var number: Int
    var values: [String]
}

struct Month {
    var id: String
    var name: String
    var days: [String]
    var values: [Week]
}

func generate(_ date: Date) -> Month {
    let components = calendar.dateComponents(dateComponents, from: date)

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
    
    print(array)
    var dates = array.chunked(into: 7).map { dates in
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
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = calendar.locale
    dateFormatter.dateFormat = "LLLL"
    let name = dateFormatter.string(from: date).capitalized
    
    var month = Month(
        id: "\(components.month!)+\(components.year!)",
        name: name,
        days: weekdays,
        values: dates.enumerated().map { item in
            return Week(number: item.offset, values: item.element)
        })
    
    return month
}
