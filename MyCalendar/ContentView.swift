//
//  ContentView.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 07.03.2023.
//

import PhotosUI
import SwiftUI

struct TextViewModel {
    var textColor: Color = .white
    var shadowColor: Color = .black
    var isWhite: Bool = true
    var family: String = "Baskerville"
    var scale: Double = 1.0
}

struct ContentView: View {
    
    @State var current: Date = Date()
    
    @State var month: Month
    
    @State var textViewModel: TextViewModel = TextViewModel()
    
    @State var fontScale: Int = 3
    var fontScaleProxy: Binding<Double> {
        Binding<Double>(get: {
            return Double(fontScale)
        }, set: {
            fontScale = Int($0)
            textViewModel.scale = {
                switch fontScale {
                case 1: return 0.75
                case 2: return 0.90
                case 3: return 1.0
                case 4: return 1.1
                case 5: return 1.25
                default: return 1.0
                }
            }()
        })
    }
    
    @State var isShowPhotoPicker: Bool = false
    @State var isShowFontPicker: Bool = false
    @State var isShowDatePicker: Bool = false
    
    @State var image: Image = Image("1")
    
    init() {
        self._month = .init(initialValue: Month.generate(Date()))
        self._current = .init(initialValue: Date())
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { proxy in
                    image
                        .resizable()
                        .scaledToFill()
                        .modifier(ImageZoomModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
                        .onTapGesture {
                            self.isShowPhotoPicker.toggle()
                        }
                }
                VStack(alignment: .center, spacing: 4 * textViewModel.scale) {
                    Text(month.name)
                        .font(.custom(textViewModel.family, size: 24 * textViewModel.scale))
                        .foregroundColor(textViewModel.textColor)
                        .shadow(color: textViewModel.shadowColor,
                                radius: 5)
                        .onTapGesture {
                            isShowDatePicker = true
                        }
                    TextLineView(data: $month.days, textViewModel: $textViewModel)
                    VStack(spacing: 4 * textViewModel.scale) {
                        ForEach(0..<month.values.count) { index in
                            TextLineView(data: $month.values[index].values, textViewModel: $textViewModel)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isShowFontPicker.toggle()
                    }
                }
            }
            .onChange(of: textViewModel.isWhite) { newValue in
                textViewModel.textColor = newValue ? .white : .black
                textViewModel.shadowColor = newValue ? .black : .white
            }
            .onChange(of: current) { newValue in
                month = Month.generate(newValue)
            }
            .ignoresSafeArea()
            .sheet(isPresented: $isShowPhotoPicker) {
                ImagePicker(image: self.$image)
            }
            .sheet(isPresented: $isShowFontPicker) {
                FontEditorView(textViewModel: $textViewModel, fontValue: fontScaleProxy)
            }
            .sheet(isPresented: $isShowDatePicker) {
                DateEditorView(date: $current)
            }
            .statusBar(hidden: true)
        }
    }
}

struct TextLineView: View {
    
    @Binding var data: [String]
    @Binding var textViewModel: TextViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 4 * textViewModel.scale) {
            ForEach(data, id: \.self) { text in
                Text(text)
                    .font(.custom(textViewModel.family, size: 14 * textViewModel.scale))
                    .foregroundColor(textViewModel.textColor)
                    .shadow(color: textViewModel.shadowColor,
                            radius: 10)
                    .frame(width: 24 * textViewModel.scale, height: 24 * textViewModel.scale)
            }
        }
    }
}

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
    
    private let heights = PresentationDetent.fraction(0.4)
    
    init(date: Binding<Date>) {
        self._date = date
        let comps = calendar.dateComponents([.year, .month], from: date.wrappedValue)
        let month = comps.month ?? 0
        let year = comps.year ?? 2023
        
        self.years = stride(from: year, to: year + 10, by: 1).map { "\($0)" }
        let months = calendar.standaloneMonthSymbols
        self.months = months
        self._selectedMonth = .init(wrappedValue: month)
        self._selectedYear = .init(wrappedValue: years.firstIndex(of: "\(year)") ?? 0)
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

struct FontEditorView: View {
    @Binding var textViewModel: TextViewModel
    var fontValue: Binding<Double>
    
    private let heights = PresentationDetent.fraction(0.4)
        
    var body: some View {
        VStack(spacing: 16) {
            Toggle(isOn: $textViewModel.isWhite) {
                Text("White color scheme")
            }
            Picker("Please choose a color", selection: $textViewModel.family) {
                ForEach(UIFont.familyNames, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.wheel)
            Text("Размер шрифта")
            Slider(value: fontValue, in: 1...5) {
                Text("Размер шрифта")
            }
        }
        .padding()
        .presentationDetents(Set(arrayLiteral: heights))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
