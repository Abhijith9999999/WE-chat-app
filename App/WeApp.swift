//
//  WeApp.swift
//  We
//
//  Created  on 10/3/24.
//

import SwiftUI

@main
struct WeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel())
        }
    }
}
