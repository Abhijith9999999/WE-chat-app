//
//  ContentView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("theme") private var theme: String = Theme.automatic.rawValue

    @EnvironmentObject private var authViewModel: AuthViewModel

    @State private var showingLaunchScreen: Bool = true
    
    var body: some View {
        ZStack {
            if showingLaunchScreen {
                LaunchScreenView(isPresented: $showingLaunchScreen)
            } else {
                ContainerView()
            }
        }
        .onAppear {
            authViewModel.checkLoginStatus()
        }
        .preferredColorScheme(selectedColorScheme)
    }
    
    private var selectedColorScheme: ColorScheme? {
        switch Theme(rawValue: theme) ?? .automatic {
        case .automatic:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
