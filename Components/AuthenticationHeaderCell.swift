//
//  AuthenticationHeaderCell.swift
//  We
//
//

import SwiftUI

struct AuthenticationHeaderCell: View {
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading) {
                Text("Join the conversation")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .fontDesign(.monospaced)
                    .fontWeight(.medium)
                    .textCase(.uppercase)
                    .multilineTextAlignment(.leading)
                
                Text("Where your thoughts matter, not your name.")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fontDesign(.serif)
            }
            
            Spacer()
            
            LogoCell()
        }
    }
}

#Preview {
    AuthenticationHeaderCell()
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
}
