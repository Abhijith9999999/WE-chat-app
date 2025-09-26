//
//  WhatsNewView.swift
//  We
//
//  Created by Om Preetham Bandi on 11/3/24.
//

import SwiftUI

struct WhatsNewView: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(whatsNewData) { update in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Version \(update.version)")
                            .font(.title)
                            .fontDesign(.serif)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                        ForEach(update.features) { feature in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(feature.title)
                                    .font(.headline)
                                
                                Text(feature.content)
                                    .font(.subheadline)
                            }
                            .padding(.bottom, 10)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("What's New")
    }
}

#Preview {
    NavigationStack {
        WhatsNewView()
    }
}
