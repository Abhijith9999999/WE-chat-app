//
//  ZoomableImageView.swift
//  We
//
//

import SwiftUI

struct ZoomableImageView: View {
    let imageUrl: URL
    @Environment(\.dismiss) var dismiss

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    // Zoom levels for double-tap gesture
    private let zoomLevels: [CGFloat] = [1.0, 2.0, 4.0]
    @State private var currentZoomLevelIndex = 0

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Black background

            GeometryReader { geometry in
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(scale)
                            .offset(offset)
                            .gesture(
                                SimultaneousGesture(
                                    TapGesture(count: 2).onEnded {
                                        withAnimation {
                                            currentZoomLevelIndex = (currentZoomLevelIndex + 1) % zoomLevels.count
                                            scale = zoomLevels[currentZoomLevelIndex]
                                            lastScale = scale
                                            if scale == 1.0 {
                                                offset = .zero
                                                lastOffset = .zero
                                            }
                                        }
                                    },
                                    DragGesture().onChanged { value in
                                        offset = CGSize(
                                            width: lastOffset.width + value.translation.width,
                                            height: lastOffset.height + value.translation.height
                                        )
                                    }
                                    .onEnded { _ in
                                        lastOffset = offset
                                    }
                                )
                                .simultaneously(with:
                                    MagnificationGesture().onChanged { value in
                                        scale = lastScale * value
                                    }
                                    .onEnded { _ in
                                        lastScale = scale
                                    }
                                )
                            )
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    case .failure:
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.gray)
                                .frame(width: 100, height: 100)
                                .padding()
                            Text("Failed to load image")
                                .foregroundStyle(.white)
                                .padding(.bottom, 20)
                            Button {
                                // Dismiss the view
                                dismiss()
                            } label: {
                                Text("Close")
                                    .foregroundStyle(.white)
                                    .padding()
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            // Close Button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }

    // Helper methods
    private func resetZoom() {
        scale = 1.0
        lastScale = 1.0
        offset = .zero
        lastOffset = .zero
        currentZoomLevelIndex = 0
    }
}
