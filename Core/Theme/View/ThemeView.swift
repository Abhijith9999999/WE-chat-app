//
//  ThemeView.swift
//  We
//
//

import SwiftUI

struct ThemeView: View {
    @AppStorage("theme") private var theme: String = Theme.automatic.rawValue

    var body: some View {
        VStack {
            List {
                Section(header: Text("Appearance").textCase(.uppercase)) {
                    Picker("Current Theme", selection: $theme) {
                        ForEach(Theme.allCases) { mode in
                            Text(mode.displayName)
                                .tag(mode.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Text("Select a theme to apply to the app. The default theme is automatic.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .textCase(nil)
            }
        }
        .navigationTitle("Theme")
    }
}

#Preview {
    NavigationStack {
        ThemeView()
    }
}
