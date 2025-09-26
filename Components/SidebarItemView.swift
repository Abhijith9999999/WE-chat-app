//
//  SidebarItemView.swift
//  We
//
//

import SwiftUI

struct SidebarItemView: View {
    var title: String
    var description: String
    var imageName: String
    var gradientColor: Color
    
    @State var isAccount: Bool = false

    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .fill(gradientColor.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: isAccount ? 30 : 8))
                
                Image(systemName: imageName)
                    .scaleEffect(isAccount ? 1.5 : 1)
                    .foregroundStyle(.background)
            }
            .frame(width: isAccount ? 60 : 50, height: isAccount ? 60 : 50)
            .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
            .padding(.trailing, 8)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
    }
}

#Preview {
    SidebarItemView(
        title: "We Account",
        description: "Your personal account settings",
        imageName: "person.badge.shield.checkmark.fill",
        gradientColor: .blue,
        isAccount: true
    )
}
