//
//  AppIconView.swift
//  We
//
//

import SwiftUI

struct AppIconView: View {
    @StateObject private var viewModel = AppIconViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(AppIcon.allCases, id: \.rawValue) { appIcon in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 15) {
                                Image(appIcon.previewImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(appIcon.rawValue)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Text(appIcon.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: viewModel.currentAppIcon == appIcon ? "checkmark.seal.fill" : "")
                                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.changeIcon(to: appIcon)
                        }
                    }
                }
            }
            .navigationTitle("App Icons")
        }
    }
}

#Preview {
    AppIconView()
}
