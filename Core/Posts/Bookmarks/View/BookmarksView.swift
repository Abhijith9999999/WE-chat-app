//
//  BookmarksView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/28/24.
//

import SwiftUI

struct BookmarksView: View {
    @StateObject private var bookmarksViewModel = BookmarksViewModel()
    @State private var showingCreatePost: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if bookmarksViewModel.isLoadingBookmarkPosts {
                    ProgressView()
                } else if bookmarksViewModel.bookmarkPosts.isEmpty {
                    ContentUnavailableView("No Bookmarks", systemImage: "bookmark.slash.fill", description: Text("You haven't bookmarked any posts yet. Bookmark some posts to see them here."))
                } else {
                    PostListView(posts: bookmarksViewModel.bookmarkPosts)
                }
            }
            .navigationTitle("Bookmarks")
            .toolbar {
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
                            Text(bookmarksViewModel.lastUpdatedText)
                            Text(DateFormatter.localizedString(from: bookmarksViewModel.lastUpdated ?? Date(), dateStyle: .none, timeStyle: .short))
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
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView()
            }
            .onAppear {
                if bookmarksViewModel.bookmarkPosts.isEmpty {
                    bookmarksViewModel.fetchBookmarkPosts()
                }
            }
            .refreshable {
                bookmarksViewModel.fetchBookmarkPosts()
            }
            .alert(isPresented: $bookmarksViewModel.showAlert) {
                Alert(
                    title: Text("Bookmarks Alert"),
                    message: Text(bookmarksViewModel.errorMessage ?? "Something went wrong."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    BookmarksView()
}
