//
//  OnboardingView.swift
//  We
//
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isShowingOnboarding: Bool
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            AnimatedMeshGradientCell()
            
            VStack {
                TabView {
                    ForEach(onboardingData) { info in
                        VStack {
                            Image(systemName: info.systemName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                                .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
                                .foregroundStyle(colorForSystemImage(systemName: info.systemName))
                            
                            Text(info.label)
                                .font(.largeTitle)
                                .fontDesign(.serif)
                                .fontWeight(.bold)
                                .padding()
                                .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)

                            if let content = info.content {
                                Text(content)
                                    .font(.subheadline)
                                    .fontDesign(.monospaced)
                                    .padding()
                            }
                        }
                        .multilineTextAlignment(.center)
                        .padding()
                    }
                }
                
                Button(role: .cancel) {
                    isShowingOnboarding = false
                } label: {
                    Text("Get Started")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.background)
                        .background(.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(30)
            }
            .interactiveDismissDisabled()
            .tabViewStyle(.page)
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = .label
                UIPageControl.appearance().pageIndicatorTintColor = .secondaryLabel
            }
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    OnboardingView(isShowingOnboarding: .constant(true))
}

