//
//  BoardDetailView.swift
//  We
//
//

import SwiftUI

struct BoardDetailView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var boardId: String

    @State private var showingEditSheet: Bool = false
    @State private var showingCreatePost: Bool = false
    @State private var isLoading: Bool = false
    @State private var lastLoadedBoardId: String?

    private var isFollowing: Bool {
        guard let board = authViewModel.selectedBoard else { return false }
        return authViewModel.followedBoards.contains { $0.id == board.id }
    }

    var body: some View {
        ZStack {
            if authViewModel.isLoadingBoardPosts {
                ProgressView()
            } else {
                VStack {
                    if authViewModel.boardPosts.isEmpty {
                        ContentUnavailableView("New Board", systemImage: "rectangle.center.inset.filled.badge.plus", description: Text("Please create a post in this board to see some content."))
                    } else {
                        PostListView(posts: authViewModel.boardPosts)
                    }
                }
            }
        }
        .navigationTitle(authViewModel.selectedBoard?.title ?? "Board Details")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    handleToggleFollow()
                } label: {
                    Label(isFollowing ? "Following" : "Follow", systemImage: isFollowing ? "checkmark" : "plus")
                }
                .buttonStyle(.borderedProminent)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if isAdminOrModerator {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit", systemImage: "slider.horizontal.3")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button {
                        // Add action for filter functionality
                        print("Filter button tapped")
                    } label: {
                        Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Updated Just Now")
                        Text("02:00 PM")
                            .foregroundStyle(.secondary)
                    }
                    .font(.caption2)
                    
                    Spacer()
                    
                    Button {
                        showingCreatePost.toggle()
                    } label: {
                        Label("New Post", systemImage: "square.and.pencil")
                    }
                }
            }
        }
        .onAppear {
            if lastLoadedBoardId != boardId {
                loadData()
            }
        }
        .refreshable {
            loadData()
        }
        .sheet(isPresented: $showingEditSheet) {
            if let board = authViewModel.selectedBoard {
                EditBoardView(
                    boardId: board.id,
                    title: board.title,
                    description: board.description,
                    symbolColor: board.symbolColor,
                    systemImageName: board.systemImageName
                )
                .environmentObject(authViewModel)
                .onDisappear {
                    authViewModel.fetchBoard(by: board.id)
                }
            }
        }
        .sheet(isPresented: $showingCreatePost) {
            if let board = authViewModel.selectedBoard {
                CreatePostView(selectedBoard: board)
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { authViewModel.errorMessage != nil },
            set: { _ in authViewModel.errorMessage = nil }
        )) {
            Alert(title: Text("Alert"), message: Text(authViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - Helper Methods
    
    private func loadData() {
        isLoading = true
        lastLoadedBoardId = boardId
        authViewModel.fetchBoard(by: boardId)
        authViewModel.fetchBoardPosts(for: boardId)
    }
    
    private func handleToggleFollow() {
        guard let board = authViewModel.selectedBoard else { return }
        authViewModel.toggleFollowBoard(boardId: board.id)
    }
    
    private var isAdminOrModerator: Bool {
        guard let role = authViewModel.currentUser?.role else { return false }
        return role.lowercased() == "admin" || role.lowercased() == "moderator"
    }
}

#Preview {
    NavigationView {
        BoardDetailView(boardId: "6720220991dfa7246a92ef7c")
            .environmentObject(AuthViewModel())
    }
}
