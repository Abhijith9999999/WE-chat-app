//
//  PostListView.swift
//  We
//
//

import SwiftUI

struct PostListView: View {
    let posts: [Post]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(posts, id: \.id) { post in
                    NavigationLink(destination: PostDetailView(postId: post.id)) {
                        PostPreviewCell(post: post)
                    }
                    .foregroundStyle(.foreground)
                }
            }
        }
    }
}

#Preview {
    PostListView(posts: samplePosts)
}
