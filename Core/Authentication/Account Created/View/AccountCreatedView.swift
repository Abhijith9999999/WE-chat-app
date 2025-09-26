//
//  AccountCreatedView.swift
//  We
//
//

import SwiftUI

struct AccountCreatedView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            AnimatedMeshGradientCell()
            
            VStack(spacing: 16) {
                LogoCell()
                    .scaleEffect(1.5)
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                    
                    HackerTextEffectView(textItems: [
                        // First text: a valid email address
                        TextItem(heading: "Initializing Hashing Process:", text: "yourid@islander.tamucc.edu", useRandomChars: false),
                        // Second text: random characters simulating hashing
                        TextItem(heading: "Generating Secure Hash:", text: String(repeating: " ", count: 64), useRandomChars: true),
                        // Third text: random characters simulating salting
                        TextItem(heading: "Applying Salt for Additional Security:", text: String(repeating: " ", count: 64), useRandomChars: true),
                        // Fourth text: random characters simulating encryption
                        TextItem(heading: "Encrypting Data for Final Protection:", text: String(repeating: " ", count: 128), useRandomChars: true)
                    ])
                } else {
                    Group {
                        Text("Account Created")
                            .font(.largeTitle)
                            .fontDesign(.serif)
                            .fontWeight(.bold)
                        
                        Text("Thank you for registering! Your account has been successfully created.")
                            .font(.subheadline)
                            .fontDesign(.monospaced)
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                    
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Login Now")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(.background)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding()
                }
            }
            .navigationBarBackButtonHidden()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                withAnimation {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    AccountCreatedView()
}
