//
//  TextLineView.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 10.03.2023.
//

import SwiftUI

struct TextLineView: View {
    
    var data: [String]
    @Binding var textViewModel: TextViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 4 * textViewModel.scale) {
            ForEach(data, id: \.self) { text in
                Text(text)
                    .font(.custom(textViewModel.font, size: 14 * textViewModel.scale))
                    .foregroundColor(textViewModel.textColor)
                    .clipped()
                    .shadow(color: textViewModel.shadowColor,
                            radius: 1)
                    .frame(width: 24 * textViewModel.scale, height: 24 * textViewModel.scale)
            }
        }
    }
}
