//
//  SafariView.swift
//  We
//
//

import SwiftUI
import SafariServices

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}

struct SafariViewControllerViewModifier: ViewModifier {
    @ObservedObject var viewModel: SafariViewModel
    
    func body(content: Content) -> some View {
        content
            .environment(\.openURL, OpenURLAction { url in
                viewModel.openURL(url)
                return .handled
            })
            .sheet(item: $viewModel.urlToOpen) { identifiableURL in
                SFSafariView(url: identifiableURL.url)
            }
    }
}

struct SFSafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

extension View {
    func handleOpenURLInApp(viewModel: SafariViewModel) -> some View {
        modifier(SafariViewControllerViewModifier(viewModel: viewModel))
    }
}
