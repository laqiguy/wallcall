//
//  ContentView.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 07.03.2023.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    
    @State var current: Date = Date()
    
    var month: Month {
        Month.generate(current)
    }
    
    var textColor: Color {
        isWhite ? .white : .black
    }
    var shadowColor: Color {
        isWhite ? .black : .white
    }
    
    @State var isShowPhotoPicker: Bool = false
    @State var isShowFontPicker: Bool = false
    @State var isShowDatePicker: Bool = false
    
    @State var image: Image = Image("1")
    @State var isWhite: Bool = true
    @State var scale: CGFloat = 1.0
    let defaultFontScale: Int = 3
    @State var fontScale: Int = 3
    @State var fontFamily: String = "Baskerville"
    var fontMultiplier: Double {
        switch fontScale {
        case 1: return 0.75
        case 2: return 0.90
        case 3: return 1.0
        case 4: return 1.1
        case 5: return 1.25
        default: return 1.0
        }
    }
    var fontScaleProxy: Binding<Double> {
        Binding<Double>(get: {
            return Double(fontScale)
        }, set: {
            fontScale = Int($0)
        })
    }

    let heights = PresentationDetent.fraction(0.4)
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { proxy in
                    image
                        .resizable()
                        .scaledToFill()
                        .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
                        .onTapGesture {
                            self.isShowPhotoPicker.toggle()
                        }
                }
                VStack(alignment: .center, spacing: 10) {
                    Text(month.name)
                        .font(.custom(fontFamily, size: 24 * fontMultiplier))
                        .foregroundColor(textColor)
                        .shadow(color: shadowColor,
                                radius: 5)
                        .onTapGesture {
                            isShowDatePicker = true
                        }
                    HStack(alignment: .center, spacing: 4 * fontMultiplier) {
                        ForEach(month.days, id: \.self) { day in
                            Text(day)
                                .font(.custom(fontFamily, size: 14 * fontMultiplier))
                                .foregroundColor(textColor)
                                .shadow(color: shadowColor,
                                        radius: 5)
                                .frame(width: 24 * fontMultiplier, height: 24 * fontMultiplier)
                        }
                    }
                    VStack(spacing: 4 * fontMultiplier) {
                        ForEach(month.values, id: \.number) { week in
                            HStack(alignment: .center, spacing: 4 * fontMultiplier) {
                                ForEach(week.values, id: \.self) { day in
                                    Text(day)
                                        .font(.custom(fontFamily, size: 14 * fontMultiplier))
                                        .foregroundColor(textColor)
                                        .shadow(color: shadowColor,
                                                radius: 5)
                                        .frame(width: 24 * fontMultiplier, height: 24 * fontMultiplier)
                                }
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isShowFontPicker.toggle()
                    }
                }
            }
            .ignoresSafeArea()
            .sheet(isPresented: $isShowPhotoPicker) {
                ImagePicker(image: self.$image)
            }
            .sheet(isPresented: $isShowFontPicker) {
                FontEditorView(fontFamily: $fontFamily, isWhite: $isWhite, fontValue: fontScaleProxy)
            }
            .sheet(isPresented: $isShowDatePicker) {
                DateEditorView(date: $current)
            }
            .statusBar(hidden: true)
        }
    }
}

struct DateEditorView: View {
    
    @Binding var date: Date
    
    let heights = PresentationDetent.fraction(0.4)
    
    var body: some View {
        VStack {
            DatePicker(selection: $date,
                       in: Date()...,
                       displayedComponents: [.date]) {
                VStack {
                    Text("Выбор месяца").font(.body)
                    Text("(число не влияет)").font(.caption)
                }
            }
            .datePickerStyle(.wheel)
            .presentationDetents(Set(arrayLiteral: heights))
        }
    }
}

struct FontEditorView: View {
    @Binding var fontFamily: String
    @Binding var isWhite: Bool
    var fontValue: Binding<Double>
    
    let heights = PresentationDetent.fraction(0.4)
        
    var body: some View {
        VStack(spacing: 16) {
            Toggle(isOn: $isWhite) {
                Text("White color scheme")
            }
            Picker("Please choose a color", selection: $fontFamily) {
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
