//
//  AboutViewModel.swift
//  We
//
//

import SwiftUI
import Combine

class AboutViewModel: ObservableObject {
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
