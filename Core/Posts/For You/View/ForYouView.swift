//
//  ForYouView.swift
//  We
//
//

import SwiftUI

struct ForYouView: View {
    @StateObject private var forYouPostsViewModel = ForYouViewModel()
    @State private var showingCreatePost: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if forYouPostsViewModel.isLoadingForYouPosts && forYouPostsViewModel.forYouPosts.isEmpty {
                    ProgressView()
                } else if forYouPostsViewModel.forYouPosts.isEmpty {
                    ContentUnavailableView("No For You Posts", systemImage: "sharedwithyou.slash", description: Text("You haven't interacted with any boards or posts yet. Start by creating a post or joining a board to see some content."))
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(forYouPostsViewModel.forYouPosts) { post in
                                NavigationLink(destination: PostDetailView(postId: post.id)) {
                                    PostPreviewCell(post: post)
                                        .onAppear {
                                            if post == forYouPostsViewModel.forYouPosts.last {
                                                forYouPostsViewModel.fetchForYouPosts()
                                            }
                                        }
                                }
                                .foregroundStyle(.foreground)
                            }
                        }

                        if forYouPostsViewModel.isLoadingForYouPosts {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else if !forYouPostsViewModel.hasMorePosts {
                            HStack {
                                Spacer()
                                Text("You have reached the end of the your for you posts.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("For You")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: {
                            print("Filter button tapped")
                        }) {
                            Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text(forYouPostsViewModel.lastUpdatedText)
                            Text(DateFormatter.localizedString(from: forYouPostsViewModel.lastUpdated ?? Date(), dateStyle: .none, timeStyle: .short))
                                .foregroundStyle(.secondary)
                        }
                        .font(.caption2)
                        
                        Spacer()
                        
                        Button(action: {
                            showingCreatePost.toggle()
                        }) {
                            Label("New Post", systemImage: "square.and.pencil")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView()
            }
            .onAppear {
                if forYouPostsViewModel.forYouPosts.isEmpty {
                    forYouPostsViewModel.fetchForYouPosts()
                }
            }
            .refreshable {
                forYouPostsViewModel.refreshPosts()
            }
            .alert(isPresented: $forYouPostsViewModel.showAlert) {
                Alert(title: Text("For You Posts Alert"), message: Text(forYouPostsViewModel.errorMessage ?? "Something went wrong."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    ForYouView()
}
