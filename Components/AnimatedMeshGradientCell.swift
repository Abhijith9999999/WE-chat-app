//
//  AnimatedMeshGradientCell.swift
//  We
//
//

import SwiftUI

struct AnimatedMeshGradientCell: View {
    var color1: Color = .clear
    var color2: Color = .mint
    var color3: Color = .teal
    var animationDuration: Double = 5.0

    @State private var isAnimating = false

    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0.0, 0.0], [0.5, 0], [1.0, 0.0],
                [0.0, 0.5], [isAnimating ? 0.1 : 0.9, isAnimating ? 0.1 : 0.9], [1.0, 0.5],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
            ],
            colors: [
                color1, color1, color1,
                color1, isAnimating ? color1 : color2, color2,
                color3, color2, color2
            ],
            smoothsColors: true,
            colorSpace: .perceptual
        )
        .onAppear {
            withAnimation(.easeInOut(duration: animationDuration).repeatForever(autoreverses: true)) {
                isAnimating.toggle()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    AnimatedMeshGradientCell(color1: .clear, color2: .teal, color3: .mint)
}
