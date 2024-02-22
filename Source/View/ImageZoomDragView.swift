//
//  DaisyDraggableImageView.swift
//  main
//
//  Created by Aleksei Tiurnin on 20.02.2024.
//

import SwiftUI

struct ImageZoomDragView: View {
    @State private var scale: CGFloat = 1.0
    @State private var currentScale: CGFloat = 1.0
    @State private var currentPosition: CGSize = .zero
    @State private var translation: CGSize = .zero

    @Binding var image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .scaleEffect(scale * currentScale)
            .offset(currentPosition + translation)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        currentPosition = value.translation
                    }
                    .onEnded { value in
                        translation = translation + currentPosition
                        currentPosition = .zero
                    }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        currentScale = value
                    }
                    .onEnded { value in
                        scale *= currentScale
                        currentScale = 1.0
                    }
            )
    }
}

func +(left: CGSize, right: CGSize) -> CGSize {
    CGSize(width: left.width + right.width, height: left.height + right.height)
}

