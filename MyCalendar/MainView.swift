//
//  ContentView.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 07.03.2023.
//

import PhotosUI
import SwiftUI

struct TextViewModel {
    var textColor: Color = .white
    var shadowColor: Color = .black
    var isWhite: Bool = true
    var family: String = "Baskerville"
    var scale: Double = 1.0
    
    mutating func update() {
        textColor = isWhite ? .white : .black
        shadowColor = isWhite ? .black : .white
    }
}

struct MainView: View {
    
    struct ViewModel {
        var textViewModel: TextViewModel = TextViewModel()
        var current: Date = Date()
        var month: Month
        
        var fontScale: Int = 3
        
        init(date: Date) {
            self.current = date
            self.month = Month.generate(date)
        }
        
        mutating func updateMonth() {
            self.month = Month.generate(current)
        }
        
        mutating func updateColor() {
            
        }
    }
    
    @State var viewModel: ViewModel
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
    
    @State var image: Image = Image("1")
    
    init() {
        self._viewModel = .init(initialValue: ViewModel(date: Date()))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { proxy in
                    image
                        .resizable()
                        .scaledToFill()
                        .modifier(ImageZoomModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
                        .onTapGesture {
                            self.isShowPhotoPicker.toggle()
                        }
                }
                VStack(alignment: .center, spacing: 4 * viewModel.textViewModel.scale) {
                    Text(viewModel.month.name)
                        .font(.custom(viewModel.textViewModel.family, size: 24 * viewModel.textViewModel.scale))
                        .foregroundColor(viewModel.textViewModel.textColor)
                        .shadow(color: viewModel.textViewModel.shadowColor,
                                radius: 5)
                        .onTapGesture {
                            isShowDatePicker = true
                        }
                    TextLineView(data: viewModel.month.days, textViewModel: $viewModel.textViewModel)
                    VStack(spacing: 4 * viewModel.textViewModel.scale) {
                        ForEach(viewModel.month.values, id: \.number) { element in
                            TextLineView(
                                data: element.values,
                                textViewModel: $viewModel.textViewModel)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isShowFontPicker.toggle()
                    }
                }
            }
            .sheet(isPresented: $isShowPhotoPicker) {
                ImagePicker(image: self.$image)
            }
            .sheet(isPresented: $isShowFontPicker) {
                FontEditorView(textViewModel: $viewModel.textViewModel, fontValue: fontScaleProxy)
            }
            .onChange(of: viewModel.textViewModel.isWhite) { newValue in
                viewModel.textViewModel.textColor = newValue ? .white : .black
                viewModel.textViewModel.shadowColor = newValue ? .black : .white
            }
            .sheet(isPresented: $isShowDatePicker) {
                DateEditorView(date: $viewModel.current)
            }
            .onChange(of: viewModel.current) { newValue in
                viewModel.updateMonth()
            }
            .ignoresSafeArea()
            .statusBar(hidden: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
