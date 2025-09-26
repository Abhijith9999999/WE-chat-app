//
//  FollowedBoardsView.swift
//  We
//
//

import SwiftUI

struct FollowedBoardsView: View {    
    @StateObject private var viewModel: FollowedBoardsViewModel
    
    init(authViewModel: AuthViewModel) {
        _viewModel = StateObject(wrappedValue: FollowedBoardsViewModel(authViewModel: authViewModel))
    }

    var body: some View {
        NavigationStack {
            if viewModel.isLoadingFollowedBoards {
                ProgressView()
                    .navigationTitle("Followed Boards")
            } else if viewModel.filteredBoards.isEmpty {
                VStack {
                    Text("You are not following any boards yet.")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .navigationTitle("Followed Boards")
            } else {
                List(viewModel.filteredBoards) { board in
                    NavigationLink(destination: BoardDetailView(boardId: board.id)) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color(hex: board.symbolColor).gradient)
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
                .navigationTitle("Followed Boards")
                .searchable(text: $viewModel.searchText, prompt: "Search Boards")
                .refreshable {
                    viewModel.fetchFollowedBoards()
                }
            }
        }
        .onAppear {
            if viewModel.followedBoards.isEmpty {
                viewModel.fetchFollowedBoards()
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Followed Boards Alert"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    FollowedBoardsView(authViewModel: AuthViewModel())
}
