//
//  AuthScreenView.swift
//  We
//
//

import SwiftUI

struct AuthScreenView: View {
    @StateObject private var safariViewModel = SafariViewModel()
    @EnvironmentObject private var viewModel: AuthViewModel
    
    @State private var showingLogin: Bool = false
    @State private var showingRegister: Bool = false

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(spacing: 45) {
                        headerSection
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        authenticationButtons
                        
                        Spacer()
                    }
                    .padding()
                }

                termsAndPrivacySection
                    .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showingLogin) {
            LoginView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingRegister) {
            VerifyView(viewModel: viewModel)
        }
    }
    
    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Group {
                    Text("Private")
                    Text("Safe")
                    Text("Anonymous")
                }
                .font(.largeTitle)
                .fontWeight(.bold)
                .fontDesign(.serif)
                
                Text("Your Campus Discussion Platform")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .fontDesign(.monospaced)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            LogoCell()
        }
    }
    
    private var authenticationButtons: some View {
        VStack(spacing: 20) {
            AuthButton(title: "Login", image: "chevron.compact.right", action: {
                showingLogin.toggle()
            })
            AuthButton(title: "Verify & Sign Up", image: "chevron.compact.up", action: {
                showingRegister.toggle()
            })
        }
    }
    
    private var termsAndPrivacySection: some View {
        VStack(spacing: 8) {
            Text("By using this app, you agree to our")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 4) {
                TermsButton(title: "Terms of Service", url: "https://we.ompreetham.com", viewModel: safariViewModel)
                Text("and")
                    .foregroundStyle(.secondary)
                TermsButton(title: "Privacy Policy", url: "https://we.ompreetham.com", viewModel: safariViewModel)
            }
            .modifier(SafariViewControllerViewModifier(viewModel: safariViewModel))
            .font(.caption)
            
            Text("We use cookies to improve your experience.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
    }
}

struct AuthButton: View {
    let title: String
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: image)
                .padding()
                .frame(maxWidth: .infinity)
        }
        .font(.body)
        .fontWeight(.semibold)
        .foregroundStyle(.background.materialActiveAppearance(.active))
        .background(.foreground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
    }
}

struct TermsButton: View {
    let title: String
    let url: String
    let viewModel: SafariViewModel
    
    var body: some View {
        Button(title) {
            viewModel.openURL(URL(string: url)!)
        }
    }
}

#Preview {
    AuthScreenView()
        .environmentObject(AuthViewModel())
}

