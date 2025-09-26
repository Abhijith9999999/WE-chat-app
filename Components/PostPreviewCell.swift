//
//  PostPreviewCell.swift
//  We
//
//

import SwiftUI

struct PostPreviewCell: View {
    let post: Post

    @State private var isImagePreviewPresented = false

    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 8) {
                if post.parentPost != nil {
                    Label("REPLY", systemImage: "arrowshape.turn.up.left.fill")
                        .fontDesign(.monospaced)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(.quinary)
                        .clipShape(.capsule)
                }
                
                // Display the image at the top
                if let imageUrl = post.image, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 100)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onTapGesture {
                                    isImagePreviewPresented = true
                                }
                                .clipped()
                        case .failure:
                            Image(systemName: "photo.fill") // Fallback image
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(height: 100)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.gray)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                // Display the post content
                Text(post.content)
                    .font(.subheadline)
                    .lineLimit(9)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Divider()
                    .padding(.bottom, 2)

                // Display additional details
                HStack(alignment: .center) {
                    Label(post.board.title, systemImage: post.board.systemImageName)
                    
                    Spacer()
                    
                    Text(post.username)
                    
                    Spacer()
                    
                    Text(post.createdAt.relativeDate())
                }
                .font(.caption2)
                .fontWeight(.medium)
                .lineLimit(1)
                .truncationMode(.tail)
                .foregroundStyle(.secondary)
            }
        } label: {
            Text(post.title)
        }
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .padding(.vertical, 2)
        .sheet(isPresented: $isImagePreviewPresented) {
            if let imageUrl = post.image, let url = URL(string: imageUrl) {
                ZoomableImageView(imageUrl: url)
            }
        }
    }
}

#Preview {
    PostPreviewCell(post: samplePosts[1])
}
