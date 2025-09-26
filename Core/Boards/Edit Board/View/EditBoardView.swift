//
//  EditBoardView.swift
//  We
//
//

import SwiftUI

struct EditBoardView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: EditBoardViewModel
    
    @State private var showingIconPicker = false
    @State private var showErrorAlert: Bool = false

    init(boardId: String, title: String, description: String, symbolColor: String, systemImageName: String) {
        _viewModel = StateObject(wrappedValue: EditBoardViewModel(
            boardId: boardId,
            title: title,
            description: description,
            symbolColor: symbolColor,
            systemImageName: systemImageName
        ))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Board Icon and Color Section
                ZStack(alignment: .bottomTrailing) {
                    ZStack {
                        Rectangle()
                            .fill(Color(hex: viewModel.symbolColor).gradient.materialActiveAppearance(.automatic))
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        Image(systemName: viewModel.systemImageName)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 50)
                    }
                    .padding()
                    .onTapGesture {
                        showingIconPicker = true
                    }
                    
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
                        .padding([.trailing, .bottom], 12)
                        .onTapGesture {
                            showingIconPicker = true
                        }
                }
                .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)

                // Form for Editing Board Details
                Form {
                    Section(header: Text("Board Details")) {
                        TextField("Title", text: $viewModel.title)
                            .disableAutocorrection(true)
                        
                        TextField("Description", text: $viewModel.description)
                            .disableAutocorrection(true)
                    }
                }
                .navigationTitle("Edit Board")
                .navigationBarTitleDisplayMode(.inline)
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
                            saveChanges()
                        } label: {
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                Label("Save", systemImage: "checkmark.circle.fill")
                                    .labelStyle(.titleOnly)
                            }
                        }
                        .disabled(viewModel.title.isEmpty || viewModel.description.isEmpty || viewModel.symbolColor.isEmpty || viewModel.systemImageName.isEmpty)
                    }
                }
            }
            .sheet(isPresented: $showingIconPicker) {
                IconPickerView(viewTitle: "Board Icon", selectedColor: $viewModel.symbolColor, selectedSymbol: $viewModel.systemImageName)
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred.")
            }
        }
    }
    
    /// Saves the changes made to the board.
    private func saveChanges() {
        viewModel.updateBoard { success in
            if success {
                dismiss()
            } else {
                showErrorAlert = true
            }
        }
    }
}

#Preview {
    EditBoardView(
        boardId: "123",
        title: "Graduation",
        description: "This board is for graduation.",
        symbolColor: "33C1FF",
        systemImageName: "graduationcap.fill"
    )
}
