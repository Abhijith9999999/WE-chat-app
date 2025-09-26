//
//  NavigationContentView.swift
//  We
//
//

import SwiftUI

struct NavigationContentView: View {    
    @Binding var primarySelection: NavigateView.PrimarySelection?

    var body: some View {
        if let selection = primarySelection {
            switch selection {
            case .account:
                AccountView()
            case .forYou:
                ForYouView()
            case .followingPosts:
                FollowingPostsView()
            case .board(let boardId):
                BoardDetailView(boardId: boardId)
            }
        } else {
            Text("Select an item")
        }
    }
}
