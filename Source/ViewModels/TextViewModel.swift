//
//  TextViewModel.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 13.03.2023.
//

import SwiftUI

extension Color {
    static var redMadColor: Color = .init(red: 234.0/255, green: 51.0/255, blue: 35.0/255)
}

struct TextViewModel {
    var colors: [Color] = [.white, .black, .redMadColor]
    var textColor: Color = .white
    var dayoffColor: Color = .red
    var shadowColor: Color = .black
    var isWhite: Bool = true
    var family: String = "CoFo Redmadrobot"
    var font: String = "CoFo Redmadrobot"
    var scale: Double = 1.0
}
