//
//  LogoCell.swift
//  We
//
//

import SwiftUI

struct LogoCell: View {
    var body: some View {
        HStack {
            ForEach(0..<3) { _ in
                Rectangle()
                    .frame(width: 6, height: 45)
                    .padding(.horizontal, 2)
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .overlay {
                        Color.primary
                    }
                    .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
            }
        }
    }
}

#Preview {
    LogoCell()
}
