//
//  ReplyPostView.swift
//  We
//
//  Created by Om Preetham Bandi on 11/14/24.
//

import SwiftUI

struct ReplyPostView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: ReplyPostViewModel = ReplyPostViewModel()
    
    @FocusState private var isContentFocused: Bool
    
    var postId: String
    
    var body: some View {
        NavigationStack {
            List {
                // Username Field
                HStack {
                    Text("From:")
                        .foregroundStyle(.secondary)
                    
                    TextField("", text: $viewModel.username)
                        .listRowSeparator(.hidden, edges: .top)
                }
                
                // Title Field
                HStack {
                    Text("Title:")
                        .foregroundStyle(.secondary)
                    
                    TextField("", text: $viewModel.title)
                }
                
                // Content Field
                TextEditor(text: $viewModel.content)
                    .frame(minHeight: 200)
                    .focused($isContentFocused)
                    .listRowSeparator(.hidden, edges: .bottom)
            }
            .listStyle(.plain)
            .navigationTitle(viewModel.title.isEmpty ? "Reply" : viewModel.title)
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
                        viewModel.replyToPost(postId: postId) { success in
                            if success {
                                dismiss()
                            }
                        }
                    } label: {
                        HStack {
                            if viewModel.isReplying {
                                ProgressView()
                            } else {
                                Text("Reply")
                                    .bold()
                            }
                        }
                    }
                    .disabled(viewModel.username.isEmpty || viewModel.title.isEmpty || viewModel.content.isEmpty)
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Reply Post Alert"), message: Text(viewModel.errorMessage ?? "Something went wrong."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    ReplyPostView(postId: "somePostId")
}
