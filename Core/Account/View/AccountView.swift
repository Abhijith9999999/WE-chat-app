//
//  AccountView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct AccountView: View {
    @Environment(\.openURL) var openURL
    
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    @StateObject private var accountViewModel: AccountViewModel = AccountViewModel()
    
    @State private var searchText: String = ""
    @State private var showingAuthScreen: Bool = false
    @State private var showingSignOutAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                SettingsSectionView(title: "Profile", items: profileItems)
                
                SettingsSectionView(title: "Account", items: accountItems)
                
                // Conditionally include the Authorized section
                if accountViewModel.isAdminOrModerator {
                    SettingsSectionView(title: "Authorized", items: authorizedItems)
                }
                
                SettingsSectionView(title: "Customize", items: customizeItems)
                
                SettingsSectionView(title: "Special", items: specialItems)

                SettingsSectionView(title: "Support", items: supportItems)
                
                SettingsSectionView(title: "More", items: moreItems)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("We Account")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSignOutAlert.toggle()
                    } label: {
                        Label("Sign Out", systemImage: "power")
                    }
                    .tint(.red)
                }
            }
            .searchable(text: $searchText, prompt: "Search")
            .sheet(isPresented: $showingAuthScreen) {
                AuthScreenView()
            }
            .alert("Sign Out", isPresented: $showingSignOutAlert) {
                Button("Sign Out", role: .destructive) {
                    authViewModel.logout()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
        .onAppear {
            accountViewModel.fetchCurrentUser()
        }
    }
    
    private var profileItems: [SettingsItem] {
        [
            SettingsItem(title: "Activity", description: "View your recent activities", icon: "heart.text.square", destination: AnyView(ActivityView())),
            SettingsItem(title: "Bookmarks", description: "Access your saved bookmarks", icon: "bookmark", destination: AnyView(BookmarksView())),
            SettingsItem(title: "Followed Boards", description: "See which boards you are following", icon: "checkmark.rectangle.stack", destination: AnyView(FollowedBoardsView(authViewModel: AuthViewModel()))),
        ]
    }
    
    private var accountItems: [SettingsItem] {
        [
            SettingsItem(title: "Username", content: "ShinjiIkariUnit01", description: "Change your username", icon: "theatermask.and.paintbrush", destination: AnyView(UpdateUsernameView())),
            SettingsItem(title: "Password", description: "Update your password", icon: "key.viewfinder", destination: AnyView(ChangePasswordView()))
        ]
    }
    
    private var authorizedItems: [SettingsItem] {
        [
            SettingsItem(title: "My Boards", description: "View all your created boards", icon: "square.grid.2x2", destination: AnyView(MyBoardsView(authViewModel: AuthViewModel()))),
            SettingsItem(title: "Create Board", description: "Create a new board", icon: "plus.square", destination: AnyView(CreateBoardView())),
        ]
    }
    
    private var customizeItems: [SettingsItem] {
        [
            SettingsItem(title: "App Icon", description: "Change the app icon", icon: "app.badge", destination: AnyView(AppIconView())),
            SettingsItem(title: "Theme", description: "Customize the app's theme", icon: "paintbrush", destination: AnyView(ThemeView())),
        ]
    }
    
    private var specialItems: [SettingsItem] {
        [
            SettingsItem(title: "Thank You", description: "A special thank you to you for using our app!", icon: "append.page", destination: AnyView(ThankYouView())),
        ]
    }
    
    private var supportItems: [SettingsItem] {
        [
            SettingsItem(title: "FAQs", description: "Frequently Asked Questions", icon: "questionmark.circle", destination: AnyView(FAQView())),
            SettingsItem(title: "Send Feedback", description: "Send us your feedback", icon: "paperplane", action: {
                sendFeedback()
            }),
            SettingsItem(title: "What's New", description: "Check out the latest features", icon: "star", destination: AnyView(WhatsNewView()))
        ]
    }
    
    private var moreItems: [SettingsItem] {
        [
            SettingsItem(title: "Onboarding", description: "View the onboarding process again", icon: "questionmark.circle", destination: AnyView(OnboardingView(isShowingOnboarding: .constant(true)))),
            SettingsItem(title: "About", description: "Learn more about this app", icon: "info.circle", destination: AnyView(AboutView()))
        ]
    }
    
    // Function to open the default mail app
    func sendFeedback() {
        let email = "support@teamwe.com"
        let subject = "App Feedback: "
        let body = ""
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)"
        if let url = URL(string: urlString) {
            openURL(url)
        }
    }
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let title: String
    var content: String = ""
    var description: String = ""
    let icon: String
    let destination: AnyView?
    let action: (() -> Void)?
    
    init(title: String, content: String = "", description: String = "", icon: String, destination: AnyView? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.content = content
        self.description = description
        self.icon = icon
        self.destination = destination
        self.action = action
    }
}

struct SettingsSectionView: View {
    let title: String
    let items: [SettingsItem]
    
    var body: some View {
        Section {
            ForEach(items) { item in
                if let action = item.action {
                    Button(action: action) {
                        HStack(spacing: 16) {
                            Image(systemName: item.icon)
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.headline)
                                if !item.description.isEmpty {
                                    Text(item.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                } else if let destination = item.destination {
                    NavigationLink(destination: destination) {
                        HStack(spacing: 16) {
                            Image(systemName: item.icon)
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.headline)
                                if !item.description.isEmpty {
                                    Text(item.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        } header: {
            Text(title)
                .font(.caption)
                .textCase(.uppercase)
        }
    }
}

#Preview {
    AccountView()
        .environmentObject(AuthViewModel())
}
