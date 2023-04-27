//
//  ColorSelectorView.swift
//  WallCall
//
//  Created by Aleksei Tiurnin on 05.04.2023.
//  Copyright © 2023 Redmadrobot OOO. All rights reserved.
//

import SwiftUI

struct ColorSelectorView: View {
    
    let colors: [Color]
    @Binding var color: Color
    
    @Environment(\.colorScheme) var colorScheme
    func getSelectionColor(for color: Color) -> Color {
        let accent: Color = colorScheme == .dark ? .white : .black
        return color == self.color ? accent : Color.gray.opacity(0.5)
    }
    
    var body: some View {
        VStack {
            ForEach(colors, id: \.self) { color in
                Button(action: {
                    self.color = color
                }) {
                    Circle()
                        .fill(color)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(getSelectionColor(for: color), lineWidth: 1)
                        )
                }
            }
        }
    }
}

struct ColorSelectorView_Previews: PreviewProvider {
    
    static var colors: [Color] = [.red, .green, .blue]
    @State static var color: Color = .red
    
    static var previews: some View {
        ColorSelectorView(colors: colors, color: $color)
    }
}
