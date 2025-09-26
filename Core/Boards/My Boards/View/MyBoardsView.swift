//
//  MyBoardsView.swift
//  We
//
//

import SwiftUI

struct MyBoardsView: View {    
    @StateObject private var viewModel: MyBoardsViewModel
    
    init(authViewModel: AuthViewModel) {
        _viewModel = StateObject(wrappedValue: MyBoardsViewModel(authViewModel: authViewModel))
    }

    var body: some View {
        NavigationStack {
            if viewModel.isLoadingUserBoards {
                ProgressView()
                    .navigationTitle("My Boards")
            } else if viewModel.filteredBoards.isEmpty {
                    ContentUnavailableView("No Boards", systemImage: "square.stack.3d.up.slash.fill", description: Text("No boards are available at this time."))
            } else {
                List(viewModel.filteredBoards) { board in
                    NavigationLink(destination: BoardDetailView(boardId: board.id)) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color(hex: board.symbolColor).materialActiveAppearance(.active))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))

                                Image(systemName: board.systemImageName)
                                    .foregroundStyle(.background)
                            }
                            .frame(width: 50, height: 50)
                            .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
                            .padding(.trailing, 8)

                            VStack(alignment: .leading) {
                                Text(board.title)
                                    .font(.headline)
                                    .lineLimit(1)

                                Text(board.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }
                    }
                }
                .navigationTitle("My Boards")
                .searchable(text: $viewModel.searchText, prompt: "Search Boards")
                .refreshable {
                    viewModel.fetchUserBoards()
                }
            }
        }
        .onAppear {
            if viewModel.userBoards.isEmpty {
                viewModel.fetchUserBoards()
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("My Boards Alert"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    MyBoardsView(authViewModel: AuthViewModel())
}
