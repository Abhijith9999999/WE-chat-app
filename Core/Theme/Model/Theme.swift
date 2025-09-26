//
//  Theme.swift
//  We
//
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
    case automatic
    case light
    case dark

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .automatic:
            return "Automatic"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}
