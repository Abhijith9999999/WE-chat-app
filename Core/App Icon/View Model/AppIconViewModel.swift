//
//  AppIconViewModel.swift
//  We
//
//

import SwiftUI

class AppIconViewModel: ObservableObject {
    // Published property to track the current selected app icon
    @Published var currentAppIcon: AppIcon = .appIcon
    
    init() {
        loadCurrentIcon()
    }
    
    // Method to change the app icon
    func changeIcon(to appIcon: AppIcon) {
        currentAppIcon = appIcon
        UIApplication.shared.setAlternateIconName(appIcon.iconValue, completionHandler: { error in
            if let error = error {
                print("Error changing app icon: \(error.localizedDescription)")
            } else {
                print("App icon changed to \(appIcon.rawValue)")
            }
        })
    }
    
    // Load the current app icon from the system
    private func loadCurrentIcon() {
        if let alternativeAppIcon = UIApplication.shared.alternateIconName,
           let appIcon = AppIcon(rawValue: alternativeAppIcon) {
            currentAppIcon = appIcon
        } else {
            currentAppIcon = .appIcon
        }
    }
}
