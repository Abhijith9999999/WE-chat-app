//
//  SafariViewModel.swift
//  We
//
//

import Foundation

class SafariViewModel: ObservableObject {
    @Published var urlToOpen: IdentifiableURL?
    
    func openURL(_ url: URL) {
        urlToOpen = IdentifiableURL(url: url)
    }
    
    func closeURL() {
        urlToOpen = nil
    }
}
