//
//  FAQView.swift
//  We
//
//

import SwiftUI

struct FAQView: View {
    @ObservedObject var viewModel = FAQViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.faqs) { faq in
                NavigationLink(destination: FAQDetailView(faq: faq)) {
                    Text(faq.question)
                        .font(.headline)
                        .padding(.vertical, 8)
                }
            }
            .listStyle(.automatic)
            .navigationBarTitle("FAQs")
        }
    }
}

struct FAQDetailView: View {
    var faq: FAQ
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text(faq.question)
                    .fontDesign(.serif)
                    .font(.title2)
                    .bold()
                
                Text(faq.answer)
                    .font(.body)
                    .padding(.top, 10)
            }
            .padding()
        }
        .navigationBarTitle("FAQ", displayMode: .inline)
    }
}
#Preview {
    FAQView()
}
