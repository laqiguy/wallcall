//
//  WeekNumberView.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 27.03.2023.
//

import SwiftUI

struct WeekNumberView: View {
    
    var data: String
    @Binding var textViewModel: TextViewModel
    
    var body: some View {
        Text(data)
            .font(.custom(textViewModel.font, size: 10 * textViewModel.scale))
            .foregroundColor(textViewModel.textColor)
            .clipped()
            .shadow(color: textViewModel.shadowColor,
                    radius: 1)
            .frame(width: 24 * textViewModel.scale, height: 24 * textViewModel.scale)
    }
}
