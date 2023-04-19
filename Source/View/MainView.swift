//
//  ContentView.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 07.03.2023.
//

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

struct MainView: View {
    
    @State var viewModel: MainViewModel
    var fontScaleProxy: Binding<Double> {
        Binding<Double>(get: {
            return Double(viewModel.fontScale)
        }, set: {
            viewModel.fontScale = Int($0)
            viewModel.textViewModel.scale = {
                switch viewModel.fontScale {
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
    
    init() {
        self._viewModel = .init(initialValue: MainViewModel(date: Date()))
    }
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                viewModel.image
                    .resizable()
                    .scaledToFill()
                    .modifier(
                        ImageZoomModifier(
                            contentSize: CGSize(
                                width: proxy.size.width,
                                height: proxy.size.height)))
                    .blur(radius: viewModel.isBlurred ? 5 : 0)
                    .onTapGesture {
                        self.isShowPhotoPicker.toggle()
                    }
            }
            .padding(EdgeInsets(top: -10, leading: -10, bottom: -10, trailing: -10))
            VStack(alignment: .center, spacing: 4 * viewModel.textViewModel.scale) {
                Text(viewModel.month.name)
                    .font(
                        .custom(
                            viewModel.textViewModel.font,
                            size: 24 * viewModel.textViewModel.scale))
                    .foregroundColor(viewModel.textViewModel.textColor)
                    .clipped()
                    .shadow(
                        color: viewModel.textViewModel.shadowColor,
                        radius: 2)
                    .onTapGesture {
                        isShowDatePicker = true
                    }
                HStack(spacing: 8) {
                    if viewModel.showWeekNumber {
                        WeekNumberView(data: " ", textViewModel: $viewModel.textViewModel)
                    }
                    WeekHeaderView(
                        data: viewModel.month.weekDaysNames,
                        textViewModel: $viewModel.textViewModel)
                }
                VStack(spacing: 4 * viewModel.textViewModel.scale) {
                    ForEach(viewModel.month.values, id: \.number) { element in
                        HStack(spacing: 8) {
                            if viewModel.showWeekNumber {
                                WeekNumberView(
                                    data: element.number,
                                    textViewModel: $viewModel.textViewModel)
                            }
                            WeekView(
                                data: element.values,
                                textViewModel: $viewModel.textViewModel)
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isShowFontPicker.toggle()
                }
            }
        }
        .sheet(isPresented: $isShowPhotoPicker) {
            ImagePicker(image: self.$viewModel.image)
        }
        .sheet(isPresented: $isShowFontPicker) {
            FontEditorView(
                textViewModel: $viewModel.textViewModel,
                isBlurred: $viewModel.isBlurred,
                fontValue: fontScaleProxy)
        }
        .sheet(isPresented: $isShowDatePicker) {
            DateEditorView(
                current: viewModel.current,
                date: $viewModel.date,
                showWeekNumber: $viewModel.showWeekNumber)
        }
        .onChange(of: viewModel.date) { newValue in
            viewModel.updateMonth()
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
        .task {
            await viewModel.load()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
