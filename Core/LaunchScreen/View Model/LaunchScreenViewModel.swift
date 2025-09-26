//
//  LaunchScreenViewModel.swift
//  We
//
//

import SwiftUI
import Combine

class LaunchScreenViewModel: ObservableObject {
    @Published var screenOpacity: Double = 1.0
    @Published var scale: CGSize = CGSize(width: 0.1, height: 0.1)
    @Published var rotation: Double = 0
    @Published var offset: Double = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    func startAnimation() {
        withAnimation(.bouncy(duration: 0.5)) {
            scale = CGSize(width: 1.5, height: 1.5)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.bouncy(duration: 1)) {
                self.scale = CGSize(width: 1.0, height: 1.0)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.bouncy(duration: 1)) {
                self.scale = CGSize(width: 1.0, height: 1.0)
            }
        }

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.bouncy(duration: 1)) {
                self.rotation = 90
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.bouncy(duration: 0.4)) {
                self.offset = -1000
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.4)) {
                self.screenOpacity = 0
            }
        }
    }
}
