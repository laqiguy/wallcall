//
//  MainViewModel.swift
//  main
//
//  Created by Aleksei Tiurnin on 22.02.2024.
//

import Foundation
import SwiftUI

struct MainViewModel {
    var textViewModel: TextViewModel = TextViewModel()
    var image: Image = Image("1")
    let current: Date
    var date: Date
    var month: Month
    var showWeekNumber: Bool = false
    var isBlurred: Bool = false
    let manager = BusinessCalendarManager()
    
    var fontScale: Int = 3
    
    var businessCalendars: [Int: BusinessCalendar] = [:]
    
    init(date: Date) {
        self.current = date
        self.date = date
        self.month = Month.generate(for: date, businessCalendar: manager.getBusinessCalendar(for: date))
    }
    
    mutating func updateMonth() {
        month.update(date, businessCalendar: manager.getBusinessCalendar(for: date))
    }
    
    func load() async {
        await manager.load(for: date)
    }
}
