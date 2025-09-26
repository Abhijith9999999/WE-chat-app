//
//  LoginView.swift
//  We
//
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 10) {
                        AuthenticationHeaderCell()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        VStack(spacing: 20)  {
                            Group {
                                TextField("Enter university email..", text: $viewModel.loginEmail)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                
                                TextField("Enter username..", text: $viewModel.loginUsername)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                
                                SecureField("Enter password..", text: $viewModel.loginPassword)
                                    .autocorrectionDisabled()
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
                            .disabled(viewModel.isLoading)
                            
                            // Show validation error if email is invalid
                            if !viewModel.isLoginEmailValid && !viewModel.loginEmail.isEmpty {
                                Text("Please enter a valid university email ending with @islander.tamucc.edu")
                                    .foregroundStyle(.red)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Button {
                                viewModel.loginUser()
                            } label: {
                                Group {
                                    if viewModel.isLoading {
                                        ProgressView()
                                    } else {
                                        Label("Login", systemImage: "chevron.compact.right")
                                    }
                                }
                                .font(.body)
                                .foregroundStyle(.background)
                                .padding()
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .background(.primary)
                                .cornerRadius(8)
                                .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
                                .opacity(viewModel.isLoginButtonDisabled ? 0.6 : 1)
                            }
                            .disabled(viewModel.isLoginButtonDisabled)
                        }
                    }
                    .navigationTitle("Login")
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button {
                                dismiss()
                            } label: {
                                Text("Cancel")
                            }
                        }
                    }
                    .interactiveDismissDisabled()
                    .alert(isPresented: Binding<Bool>(
                        get: { viewModel.errorMessage != nil },
                        set: { _ in viewModel.errorMessage = nil }
                    )) {
                        Alert(
                            title: Text("Alert"),
                            message: Text(viewModel.errorMessage ?? "An error occurred."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
        }
        .onAppear {
            viewModel.isLoggedIn = false
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel())
}
