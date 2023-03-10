//
//  FontEditorView.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 10.03.2023.
//

import SwiftUI

struct FontEditorView: View {
    @Binding var textViewModel: TextViewModel
    @State var selectedColor: Int
    var fontValue: Binding<Double>
    
    private let heights = PresentationDetent.fraction(0.4)
        
    init(textViewModel: Binding<TextViewModel>, fontValue: Binding<Double>) {
        self._textViewModel = textViewModel
        self._selectedColor = .init(
            initialValue: textViewModel.wrappedValue.colors.firstIndex(of: textViewModel.wrappedValue.textColor) ?? 0)
        self.fontValue = fontValue
    }
    
    @Environment(\.colorScheme) var colorScheme
    func getSelectionColor(for color: Color) -> Color {
        let accent: Color = colorScheme == .dark ? .white : .black
        return textViewModel.textColor == color ? accent : Color.gray.opacity(0.5)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                ForEach(textViewModel.colors, id: \.self) { color in
                    Button(action: {
                        textViewModel.textColor = color
                        textViewModel.shadowColor = color == .black ? .white : .black
                    }) {
                        Circle()
                            .fill(color)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .stroke(getSelectionColor(for: color), lineWidth: 3)
                            )
                    }
                }
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
