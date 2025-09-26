//
//  RegistrationView.swift
//  We
//
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var focusedField: FocusField?
    
    enum FocusField {
        case verificationCode, username, password, confirmPassword
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        AuthenticationHeaderCell()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        VStack(spacing: 20)  {
                            // Verification Code Input
                            CodeInputCell(code: $viewModel.verificationCode, codeLength: 6)
                                .padding(.bottom)
                                .focused($focusedField, equals: .verificationCode)
                            
                            Group {
                                // Username Input
                                TextField("Enter username (min 4 characters)", text: $viewModel.username)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .focused($focusedField, equals: .username)
                                
                                // Password Input
                                SecureField("Create password..", text: $viewModel.password)
                                    .focused($focusedField, equals: .password)
                                
                                // Confirm Password Input
                                SecureField("Confirm password..", text: $viewModel.confirmPassword)
                                    .focused($focusedField, equals: .confirmPassword)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)

                            PasswordStrengthView(password: $viewModel.password)
                                .padding(.horizontal)
                            
                            Text("""
**Password must be at least 8 characters, with 1 uppercase, 1 lowercase, 1 number, and 1 special character.

There is no option to recover a forgotten password.**
""")
                            .font(.footnote)
                            .lineLimit(4)
                            .multilineTextAlignment(.center)
                            
                            if !viewModel.doPasswordsMatch {
                                Text("Passwords do not match.")
                                    .foregroundStyle(.red)
                                    .font(.footnote)
                            }
                            
                            // Create Account Button
                            Button {
                                viewModel.registerUser()
                            } label: {
                                Group {
                                    if viewModel.isLoading {
                                        ProgressView()
                                    } else {
                                        Label("Create Account", systemImage: "chevron.compact.up")
                                    }
                                }
                                .font(.body)
                                .foregroundStyle(.background)
                                .padding()
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .background(.primary)
                                .opacity(viewModel.isRegisterButtonDisabled ? 0.6 : 1)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
                            }
                            .disabled(viewModel.isRegisterButtonDisabled)
                        }
                    }
                    .navigationTitle("Register")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(isPresented: $viewModel.isAccountCreated) {
                        AccountCreatedView()
                    }
                    .padding()
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.focusedField = .verificationCode
            }
        }
    }
}

#Preview {
    RegistrationView(viewModel: AuthViewModel())
}
