//
//  VerifyView.swift
//  We
//
//

import SwiftUI

struct VerifyView: View {
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
                                TextField("Enter university email..", text: $viewModel.emailAddress)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .onChange(of: viewModel.emailAddress) {
                                        viewModel.errorMessage = nil
                                    }
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)

                            if !viewModel.isEmailValid && !viewModel.emailAddress.isEmpty {
                                Text("Please enter a valid university email ending with @islander.tamucc.edu")
                                    .foregroundStyle(.red)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }

                            VStack(alignment: .leading) {
                                Text("A verification code will be sent to your university email.")
                                    .font(.footnote)
                            }

                            Button {
                                viewModel.requestVerificationCode()
                            } label: {
                                if viewModel.isLoading {
                                    ProgressView()
                                } else {
                                    Label("Send Code", systemImage: "chevron.compact.up")
                                        .font(.body)
                                        .foregroundStyle(.background)
                                        .padding()
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .background(.primary)
                                        .opacity(viewModel.isSendCodeButtonDisabled ? 0.6 : 1)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
                                }
                            }
                            .disabled(viewModel.isSendCodeButtonDisabled)
                        }
                    }
                    .navigationTitle("Verify")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(isPresented: $viewModel.isCodeSent) {
                        RegistrationView(viewModel: viewModel)
                    }
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
                
                Button {
                    viewModel.isCodeSent = true
                } label: {
                    Text("Already have a code?")
                        .font(.footnote)
                        .underline()
                }
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    VerifyView(viewModel: AuthViewModel())
}
