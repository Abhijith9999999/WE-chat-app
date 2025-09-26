//
//  AboutView.swift
//  We
//
//

import SwiftUI

struct AboutView: View {
    @Environment(\.openURL) var openURL
    
    @StateObject private var viewModel: AboutViewModel = AboutViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        viewModel.openURL("https://x.com/TeamWe")
                    } label: {
                        Label("X", systemImage: "arrow.up.right.square")
                    }
                    
                    Button {
                        viewModel.openURL("https://instagram.com/teamwe")
                    } label: {
                        Label("Instagram", systemImage: "arrow.up.right.square")
                    }
                    
                    Button {
                        viewModel.openURL("https://we.ompreetham.com/")
                    } label: {
                        Label("Website", systemImage: "arrow.up.right.square")
                    }
                } header: {
                    Text("Follow")
                        .font(.caption)
                        .textCase(.uppercase)
                }
                .padding(.vertical, 8)
                
                Section {
                    NavigationLink(destination: Text("Terms of Service Page")) {
                        Text("Terms of Service")
                    }
                    
                    NavigationLink(destination: Text("Privacy Policy Page")) {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink(destination: Text("Licenses Page")) {
                        Text("Licenses")
                    }
                } header: {
                    Text("Legal")
                        .font(.caption)
                        .textCase(.uppercase)
                }
                .padding(.vertical, 8)
                
                VStack(alignment: .center) {
                    Text("Version 1.0")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text("© 2024 We. All rights reserved.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 8)
            }
            .navigationBarTitle("About We")
        }
    }
}

#Preview {
    AboutView()
}
