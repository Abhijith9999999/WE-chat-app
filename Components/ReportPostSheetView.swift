//
//  ReportPostSheetView.swift
//  We
//
//

import SwiftUI

struct ReportPostSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var postViewModel: PostDetailViewModel = PostDetailViewModel()

    @Binding var reportReason: String

    var postId: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    TextField("Reason", text: $reportReason, axis: .vertical)
                }
                .padding()
            }
            .navigationTitle("Report Post")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        postViewModel.reportPost(postId: postId, reason: reportReason)
                        dismiss()
                    } label: {
                        Label("Report", systemImage: "paperplane.fill")
                    }
                    .tint(.red)
                    .disabled(reportReason.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ReportPostSheetView(reportReason: .constant(""),  postId: "samplePostId")
}
