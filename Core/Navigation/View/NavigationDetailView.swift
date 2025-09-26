//
//  NavigationDetailView.swift
//  We
//
//

import SwiftUI

struct NavigationDetailView: View {
    @Binding var selectedPostId: Post.ID?

    var body: some View {
        if let postId = selectedPostId {
            PostDetailView(postId: postId)
        } else {
            ContentUnavailableView("No Content Selected", systemImage: "square.and.pencil", description: Text("It seems you haven’t selected anything yet. Please choose an item from the list to view its details."))
        }
    }
}
