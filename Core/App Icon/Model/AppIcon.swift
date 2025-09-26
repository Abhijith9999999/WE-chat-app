//
//  AppIcon.swift
//  We
//
//

enum AppIcon: String, CaseIterable {
    case appIcon = "Default"
    case appIcon1 = "Rozha"
    case appIcon2 = "TAMUCC"
    
    var iconValue: String? {
        if self == .appIcon {
            return nil
        } else {
            return rawValue
        }
    }
    
    var previewImage: String {
        switch self {
        case .appIcon: return "Default"
        case .appIcon1: return "Rozha"
        case .appIcon2: return "TAMUCC"
        }
    }
    
    var description: String {
        switch self {
        case .appIcon:
            return "The default app icon with the original design."
        case .appIcon1:
            return "Featuring the original teal color with 'We' in a serif font, symbolizing elegance."
        case .appIcon2:
            return "Inspired by the 'shakas up' hand sign, with the 'Three Pillars of Trust' above the hand, symbolizing unity."
        }
    }
}
