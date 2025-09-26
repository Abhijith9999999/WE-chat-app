//
//  NavigateView.swift
//  We
//
//

import SwiftUI

struct NavigateView: View {
    @AppStorage("thankYou") private var showingThankYou: Bool = true
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var primarySelection: PrimarySelection? = .forYou
    @State private var selectedPostId: Post.ID?
    @State private var searchText = ""
    
    enum PrimarySelection: Hashable {
        case account
        case forYou
        case followingPosts
        case board(Board.ID)
    }
    
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            NavigationSidebarView(primarySelection: $primarySelection)
                .environmentObject(authViewModel)
        } content: {
            NavigationContentView(primarySelection: $primarySelection)
        } detail: {
            NavigationDetailView(selectedPostId: $selectedPostId)
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $showingThankYou) {
            ThankYouView()
        }
    }
}

#Preview {
    NavigateView()
        .environmentObject(AuthViewModel())
}
