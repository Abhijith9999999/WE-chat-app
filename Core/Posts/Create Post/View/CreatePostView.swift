//
//  CreatePostView.swift
//  We
//
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    @StateObject private var viewModel: CreatePostViewModel
    @FocusState private var isContentFocused: Bool
    @State private var isShowingImagePicker = false

    init(selectedBoard: Board? = nil) {
        _viewModel = StateObject(wrappedValue: CreatePostViewModel(selectedBoard: selectedBoard))
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    // Board Picker
                    Picker("To: ", selection: $viewModel.selectedBoard) {
                        ForEach(authViewModel.allBoards, id: \.id) { board in
                            Label(board.title, systemImage: board.systemImageName)
                                .tag(board as Board?)
                        }
                    }
                    .pickerStyle(.menu)
                    .listRowSeparator(.hidden, edges: .top)
                    .foregroundStyle(.secondary)

                    // Username Field
                    HStack {
                        Text("From:")
                            .foregroundStyle(.secondary)

                        TextField("Enter username", text: $viewModel.username)
                    }

                    // Subject Field
                    HStack {
                        Text("Subject:")
                            .foregroundStyle(.secondary)

                        TextField("Enter Subject", text: $viewModel.subject)
                    }

                    // Content Field
                    TextEditor(text: $viewModel.content)
                        .focused($isContentFocused)
                        .listRowSeparator(.hidden, edges: .bottom)
                    
                    
                    // Display selected image
                    if let selectedImage = viewModel.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .onTapGesture {
                                isShowingImagePicker = true
                            }
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .onAppear {
                    isContentFocused = true
                }

                // Add Photo Button at the Bottom
                Button {
                    isShowingImagePicker = true
                } label: {
                    HStack {
                        Image(systemName: "photo")
                        Text(viewModel.selectedImage == nil ? "Add Photo" : "Change Photo")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle(viewModel.subject.isEmpty ? "New Post" : viewModel.subject)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark.circle.fill")
                            .labelStyle(.titleOnly)
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        if viewModel.validateFields() {
                            viewModel.createPost {
                                dismiss()
                            }
                        }
                    } label: {
                        HStack {
                            if viewModel.isSubmitting {
                                ProgressView()
                            } else {
                                Text("Post")
                                    .bold()
                            }
                        }
                    }
                    .disabled(viewModel.subject.isEmpty || viewModel.content.isEmpty || viewModel.selectedBoard == nil)
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Create Post Alert"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $viewModel.selectedImage)
            }
        }
    }
}

#Preview {
    CreatePostView()
        .environmentObject(AuthViewModel())
}
