//
//  LaunchScreenView.swift
//  We
//
//

import SwiftUI

struct LaunchScreenView: View {
    @StateObject private var viewModel = LaunchScreenViewModel()

    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            LogoCell()
                .offset(y: viewModel.offset)
                .rotationEffect(.degrees(viewModel.rotation))
                .scaleEffect(viewModel.scale)
        }
        .opacity(viewModel.screenOpacity)
        .onAppear {
            viewModel.startAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                isPresented.toggle()
            }
        }
    }
}

#Preview {
    LaunchScreenView(isPresented: .constant(true))
}
