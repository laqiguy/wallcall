//
//  FontEditorView.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 10.03.2023.
//

import SwiftUI

struct FontEditorView: View {
    @Binding var textViewModel: TextViewModel
    @Binding var isBlurred: Bool
    @State var selectedColor: Int
    var fontValue: Binding<Double>
    
    private let heights = PresentationDetent.height(320)
        
    init(textViewModel: Binding<TextViewModel>, isBlurred: Binding<Bool>, fontValue: Binding<Double>) {
        self._textViewModel = textViewModel
        self._isBlurred = isBlurred
        self._selectedColor = .init(
            initialValue: textViewModel.wrappedValue.colors.firstIndex(of: textViewModel.wrappedValue.textColor) ?? 0)
        self.fontValue = fontValue
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Toggle("Блюр", isOn: $isBlurred)
                .padding()
            HStack {
                ColorSelectorView(colors: textViewModel.colors, color: $textViewModel.textColor)
                ColorSelectorView(colors: textViewModel.colors, color: $textViewModel.dayoffColor)
                Picker("Выбери шрифт", selection: $textViewModel.family) {
                    ForEach(UIFont.familyNames, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.wheel)
            }
            Slider(value: fontValue, in: 1...5) {
                Text("Размер шрифта")
            }
            if UIFont.fontNames(forFamilyName: textViewModel.family).count > 1 {
                Picker("", selection: $textViewModel.font) {
                    ForEach(
                        UIFont.fontNames(forFamilyName: textViewModel.family),
                        id: \.self) { name in
                            Text(name).font(.custom(name, size: 14 * textViewModel.scale))
                        }
                }
            } else {
                Spacer(minLength: 35)
            }
        }
        .onChange(of: textViewModel.family, perform: { newValue in
            textViewModel.family = newValue
            textViewModel.font = UIFont.fontNames(forFamilyName: newValue)[0]
        })
        .onChange(of: textViewModel.textColor, perform: { newValue in
            textViewModel.shadowColor = newValue == .black ? .white : .black
        })
        .padding()
        .presentationDragIndicator(.visible)
        .presentationDetents(Set(arrayLiteral: heights))
    }
}
