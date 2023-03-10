//
//  DateEditorView.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 10.03.2023.
//

import SwiftUI

struct DateEditorView: View {
    
    @Binding var date: Date
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ru_RU")
        formatter.dateFormat = "dd LLLL yyyy"
        return formatter
    }()
    
    private let months: [String]
    private let years: [String]
    @State private var selectedMonth: Int = 0
    @State private var selectedYear: Int = 0
    
    private let heights = PresentationDetent.fraction(0.3)
    
    init(current: Date, date: Binding<Date>) {
        self._date = date
        let currentDateComponents = calendar.dateComponents([.year, .month], from: current)
        let currentYear = currentDateComponents.year ?? 2023
        
        let selectedDateComponents = calendar.dateComponents([.year, .month], from: date.wrappedValue)
        let selectedMonth = (selectedDateComponents.month ?? 1) - 1
        let selectedYear = selectedDateComponents.year ?? currentYear
        
        self.years = stride(from: currentYear, to: currentYear + 10, by: 1).map { "\($0)" }
        let months = calendar.standaloneMonthSymbols
        self.months = months
        self._selectedMonth = .init(wrappedValue: selectedMonth)
        self._selectedYear = .init(wrappedValue: years.firstIndex(of: "\(selectedYear)") ?? 0)
    }
    
    var body: some View {
        HStack() {
            Picker(selection: $selectedMonth) {
                ForEach(months.indices, id: \.self) { index in
                    Text(months[index])
                }
            } label: { }
            Picker(selection: $selectedYear) {
                ForEach(years.indices, id: \.self) { index in
                    Text(years[index])
                }
            } label: { }
        }
        .onChange(of: selectedMonth, perform: { newValue in
            let dateString = "01 \(months[newValue]) \(years[selectedYear])"
            date = dateFormatter.date(from: dateString) ?? date
        })
        .onChange(of: selectedYear, perform: { newValue in
            let dateString = "01 \(months[selectedMonth]) \(years[newValue])"
            date = dateFormatter.date(from: dateString) ?? date
        })
        .pickerStyle(.wheel)
        .presentationDetents(Set(arrayLiteral: heights))
    }
}
