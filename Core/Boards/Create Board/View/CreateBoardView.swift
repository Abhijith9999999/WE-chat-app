//
//  CreateBoardView.swift
//  We
//
//

import SwiftUI

struct CreateBoardView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var showingIconPicker = false
    @State private var isCreatingBoard = false
    @State private var errorMessage: String?

    @State private var title = ""
    @State private var description = ""
    @State private var symbolColor: String = "#30B0C7"
    @State private var systemImageName: String = "graduationcap.fill"

    var body: some View {
        NavigationStack {
            VStack {
                // Board Icon and Color Section
                ZStack(alignment: .bottomTrailing) {
                    ZStack {
                        Rectangle()
                            .fill(Color(hex: symbolColor).gradient)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 16))

                        Image(systemName: systemImageName)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 50)
                    }
                    .padding()

                    Image(systemName: "plus.circle.fill")
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

                Form {
                    Section("Board Details") {
                        TextField("Title", text: $title)
                        TextField("Description", text: $description)
                    }
                }
                .navigationTitle("Create Board")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                            createBoard()
                        }) {
                            if isCreatingBoard {
                                ProgressView()
                            } else {
                                Text("Create")
                            }
                        }
                        .disabled(title.isEmpty || description.isEmpty || isCreatingBoard)
                    }
                }
                .sheet(isPresented: $showingIconPicker) {
                    IconPickerView(viewTitle: "Board Icon", selectedColor: $symbolColor, selectedSymbol: $systemImageName)
                }
                .alert(isPresented: Binding<Bool>(
                    get: { errorMessage != nil },
                    set: { _ in errorMessage = nil }
                )) {
                    Alert(title: Text("Alert"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
                }
            }
        }
    }

    func createBoard() {
        isCreatingBoard = true
        errorMessage = nil

        BoardService.shared.createBoard(title: title, description: description, symbolColor: symbolColor, systemImageName: systemImageName) { result in
            DispatchQueue.main.async {
                self.isCreatingBoard = false
                switch result {
                case .success(_):
                    // Optionally, add the new board to a list of boards in your view model
                    dismiss()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    CreateBoardView()
        .environmentObject(AuthViewModel())
}
