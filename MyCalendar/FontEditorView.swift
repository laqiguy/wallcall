//
//  FontEditorView.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 10.03.2023.
//

import SwiftUI

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
