//
//  UpdateUsername.swift
//  We
//
//

import SwiftUI

struct UpdateUsernameView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var newUsername = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("New Username")) {
                    TextField("Your current username is \(viewModel.currentUser?.username ?? "Shinji")", text: $newUsername)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                if viewModel.isUsernameUpdated {
                    Text("Username updated successfully")
                }

                Section {
                    Button {
                        viewModel.updateUsername(newUsername: newUsername)
                    } label: {
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            Text("Update Username")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(newUsername.isEmpty || viewModel.isLoading)
                }
            }
            .navigationBarTitle("Update Username")
            .alert(isPresented: $viewModel.isUsernameUpdated) {
                Alert(
                    title: Text("Success"),
                    message: Text("Your username has been updated."),
                    dismissButton: .default(Text("OK"), action: {
                        viewModel.isUsernameUpdated = false
                    })
                )
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )) {
                Alert(title: Text("Alert"), message: Text(viewModel.errorMessage ?? "An error occurred."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    UpdateUsernameView()
        .environmentObject(AuthViewModel())
}
