//
//  FollowingPostsView.swift
//  We
//
//

import SwiftUI

struct FollowingPostsView: View {
    @StateObject private var followingPostsViewModel = FollowingPostsViewModel()
    @State private var showingCreatePost: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                if followingPostsViewModel.isLoadingFollowingPosts && followingPostsViewModel.followingPosts.isEmpty {
                    ProgressView()
                } else if followingPostsViewModel.followingPosts.isEmpty {
                    ContentUnavailableView("No Following Posts", systemImage: "heart.slash.fill", description: Text("You haven't followed any boards yet. Follow boards to see posts here."))
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(followingPostsViewModel.followingPosts, id: \.id) { post in
                                NavigationLink(destination: PostDetailView(postId: post.id)) {
                                    PostPreviewCell(post: post)
                                        .onAppear {
                                            if post == followingPostsViewModel.followingPosts.last {
                                                followingPostsViewModel.fetchFollowingPosts()
                                            }
                                        }
                                }
                                .foregroundStyle(.foreground)
                            }
                        }
                        
                        if followingPostsViewModel.isLoadingFollowingPosts {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else if !followingPostsViewModel.hasMorePosts {
                            HStack {
                                Spacer()
                                Text("You have reached the end of your following posts.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Following")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            print("Filter button tapped")
                        } label: {
                            Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                        }

                        Spacer()

                        VStack {
                            Text(followingPostsViewModel.lastUpdatedText)
                            Text(DateFormatter.localizedString(from: followingPostsViewModel.lastUpdated ?? Date(), dateStyle: .none, timeStyle: .short))
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
                if followingPostsViewModel.followingPosts.isEmpty {
                    followingPostsViewModel.fetchFollowingPosts()
                }
            }
            .refreshable {
                followingPostsViewModel.refreshPosts()
            }
            .alert(isPresented: $followingPostsViewModel.showAlert) {
                Alert(title: Text("Following Posts Alert"), message: Text(followingPostsViewModel.errorMessage ?? "Something went wrong."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    FollowingPostsView()
}
