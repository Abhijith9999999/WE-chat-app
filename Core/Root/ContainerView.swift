//
//  ContainerView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct ContainerView: View {
    @AppStorage("onboarding") private var showingOnboarding: Bool = true
    
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            if viewModel.isLoggedIn {
                NavigateView()
            } else {
                AuthScreenView()
            }
        }
        .sheet(isPresented: $showingOnboarding) {
            OnboardingView(isShowingOnboarding: $showingOnboarding)
        }
    }
}

#Preview {
    ContainerView()
        .environmentObject(AuthViewModel())
}
