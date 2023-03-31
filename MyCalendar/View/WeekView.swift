//
//  TextLineView.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 10.03.2023.
//

import SwiftUI

struct WeekView: View {
    
    var data: [Month.Day]
    @Binding var textViewModel: TextViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 4 * textViewModel.scale) {
            ForEach(data, id: \.id) { model in
                Text(model.value)
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
