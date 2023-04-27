//
//  Helpers.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 09.03.2023.
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
        tempDate = calendar.date(byAdding: .day, value: 1, to: tempDate)!
        array.append(tempDate)
    }

    return array
}

extension Date {
    func startOfMonth() -> Date {
        return calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: calendar.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func sameDay(as date: Date) -> Bool {
        return calendar.dateComponents([.day], from: self, to: date).day == 0
    }
}

let calendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "ru_RU")
    calendar.firstWeekday = 2

    return calendar
}()

let dateComponents: Set<Calendar.Component> = [.day, .month, .year, .weekday, .weekdayOrdinal, .weekOfYear]

let monthFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = calendar.locale
    dateFormatter.dateFormat = "LLLL"
    return dateFormatter
}()
