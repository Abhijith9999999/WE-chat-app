//
//  NavigationSidebarView.swift
//  We
//
//

import SwiftUI

struct NavigationSidebarView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var primarySelection: NavigateView.PrimarySelection?

    @State private var searchText: String = ""

    var filteredBoards: [Board] {
        if searchText.isEmpty {
            return authViewModel.allBoards
        } else {
            return authViewModel.allBoards.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var filteredFollowedBoards: [Board] {
        if searchText.isEmpty {
            return authViewModel.followedBoards
        } else {
            return authViewModel.followedBoards.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        ZStack {
            List(selection: $primarySelection) {
                // Account Section
                Section {
                    NavigationLink(value: NavigateView.PrimarySelection.account) {
                        SidebarItemView(
                            title: authViewModel.currentUser?.username ?? "We Account",
                            description: "We Account, Personalization, and more.",
                            imageName: "person.badge.shield.checkmark.fill",
                            gradientColor: .teal,
                            isAccount: true
                        )
                    }
                }

                // Personalized Section
                Section(header: Text("Personalized")) {
                    NavigationLink(value: NavigateView.PrimarySelection.forYou) {
                        SidebarItemView(
                            title: "For You",
                            description: "A curated feed based on your interests.",
                            imageName: "shared.with.you",
                            gradientColor: .blue
                        )
                    }

                    NavigationLink(value: NavigateView.PrimarySelection.followingPosts) {
                        SidebarItemView(
                            title: "Following",
                            description: "Posts from boards you follow.",
                            imageName: "checkmark.seal.fill",
                            gradientColor: Color(red: 212/255, green: 175/255, blue: 55/255)
                        )
                    }
                }

                // Followed Boards Section
                Section(header: Text("Followed Boards")) {
                    if authViewModel.isLoadingFollowedBoards {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else if filteredFollowedBoards.isEmpty {
                        Text("You have not followed any boards.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(filteredFollowedBoards) { board in
                            NavigationLink(value: NavigateView.PrimarySelection.board(board.id)) {
                                SidebarItemView(
                                    title: board.title,
                                    description: board.description,
                                    imageName: board.systemImageName,
                                    gradientColor: Color(hex: board.symbolColor)
                                )
                            }
                        }
                    }
                }

                // Boards Section
                Section(header: Text("All Boards")) {
                    if authViewModel.isLoadingAllBoards {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else if filteredBoards.isEmpty {
                        Text("No boards available.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(filteredBoards) { board in
                            NavigationLink(value: NavigateView.PrimarySelection.board(board.id)) {
                                SidebarItemView(
                                    title: board.title,
                                    description: board.description,
                                    imageName: board.systemImageName,
                                    gradientColor: Color(hex: board.symbolColor)
                                )
                            }
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("III")
            .searchable(text: $searchText, prompt: "Search We")
            .onAppear {
                if authViewModel.currentUser == nil {
                    authViewModel.fetchCurrentUser()
                }
                if authViewModel.allBoards.isEmpty {
                    authViewModel.fetchAllBoards()
                }
                if authViewModel.followedBoards.isEmpty {
                    authViewModel.fetchFollowedBoards()
                }
            }
            .refreshable {
                authViewModel.fetchAllBoards()
                authViewModel.fetchFollowedBoards()
                authViewModel.fetchCurrentUser()
            }
            .alert(isPresented: Binding<Bool>(
                get: { authViewModel.errorMessage != nil },
                set: { _ in authViewModel.errorMessage = nil }
            )) {
                Alert(title: Text("Alert"), message: Text(authViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    NavigationSidebarView(primarySelection: Binding(.constant(.forYou)))
        .environmentObject(AuthViewModel())
}
