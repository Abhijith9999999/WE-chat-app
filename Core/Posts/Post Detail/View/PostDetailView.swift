//
//  PostDetailView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/19/24.
//

import SwiftUI

struct PostDetailView: View {
    @StateObject private var postDetailViewModel = PostDetailViewModel()
    
    @State private var showingReplyToPost: Bool = false
    @State private var showingImagePreview: Bool = false
    @State private var showingReportSheet = false
    @State private var reportReason = ""
    
    var postId: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Display parent post if it exists
                if let parentPost = postDetailViewModel.parentPost {
                    NavigationLink(destination: PostDetailView(postId: parentPost.id)) {
                        PostPreviewCell(post: parentPost)
                    }
                    .foregroundStyle(.foreground)
                    
                    Divider()
                }
                
                if let post = postDetailViewModel.post {
                    VStack(alignment: .leading, spacing: 8) {
                        if post.parentPost != nil {
                            Label("REPLY", systemImage: "arrowshape.turn.up.left.fill")
                                .fontDesign(.monospaced)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 4)
                                .background(.quinary)
                                .clipShape(.capsule)
                        }
                        
                        // Display post image if available
                        if let imageUrl = post.image, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(height: 100)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .onTapGesture {
                                            showingImagePreview = true
                                        }
                                        .clipped()
                                case .failure:
                                    Image(systemName: "photo.fill") // Fallback image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .foregroundStyle(.gray)
                                        .background(Color.gray.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        
                        // Display post details
                        Text(post.title)
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.leading)
                        
                        Text("By \(post.username)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                        
                        Text(post.content)
                            .font(.callout)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .sheet(isPresented: $showingImagePreview) {
                        if let imageUrl = post.image, let url = URL(string: imageUrl) {
                            ZoomableImageView(imageUrl: url)
                        }
                    }
                    
                    // Upvote and Downvote Buttons
                    HStack(spacing: 40) {
                        Button {
                            postDetailViewModel.upvotePost(postId: postId)
                        } label: {
                            Label("\(post.upvoteCount)", systemImage: "hand.thumbsup.fill")
                                .font(.callout)
                                .foregroundStyle(.primary)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        Button {
                            postDetailViewModel.downvotePost(postId: postId)
                        } label: {
                            Label("\(post.downvoteCount)", systemImage: "hand.thumbsdown.fill")
                                .font(.callout)
                                .foregroundStyle(.primary)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        Button {
                            postDetailViewModel.toggleBookmarkPost(postId: postId)
                        } label: {
                            Image(systemName: postDetailViewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                                .font(.callout)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .font(.callout)
                    .padding()
                    
                    Divider()
                    
                    // Replies Section
                    if postDetailViewModel.isLoadingReplies {
                        ProgressView("Loading replies...")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else if !postDetailViewModel.replies.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Replies")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(postDetailViewModel.replies) { reply in
                                NavigationLink(destination: PostDetailView(postId: reply.id)) {
                                    PostPreviewCell(post: reply)
                                }
                                .foregroundStyle(.foreground)
                            }
                        }
                    } else {
                        Text("No replies yet.")
                            .foregroundStyle(.secondary)
                            .padding()
                    }
                } else if postDetailViewModel.isLoadingPost {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ContentUnavailableView("Post Not Found", systemImage: "text.page.slash.fill", description: Text("Post is not available. Please try again later."))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(postDetailViewModel.post?.board.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            postDetailViewModel.fetchPost(by: postId)
            postDetailViewModel.checkIfPostIsBookmarked(postId: postId)
            postDetailViewModel.fetchPostReplies(postId: postId)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Report Post") {
                        showingReportSheet = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
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
                        Text(postDetailViewModel.lastUpdatedText)
                        Text(DateFormatter.localizedString(from: postDetailViewModel.lastUpdated ?? Date(), dateStyle: .none, timeStyle: .short))
                            .foregroundStyle(.secondary)
                    }
                    .font(.caption2)
                    
                    Spacer()
                    
                    Button {
                        showingReplyToPost.toggle()
                    } label: {
                        Label("Reply to Post", systemImage: "square.and.pencil")
                    }
                }
            }
        }
        .sheet(isPresented: $showingReplyToPost) {
            ReplyPostView(postId: postId)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showingReportSheet) {
            ReportPostSheetView(reportReason: $reportReason, postId: postId)
                .presentationDetents([.medium, .large])
        }
        .alert(isPresented: $postDetailViewModel.showAlert) {
            Alert(title: Text("Post Alert"), message: Text(postDetailViewModel.errorMessage ?? "Something went wrong."), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailView(postId: "672f23333453b558ef1eb8d2")
    }
}
