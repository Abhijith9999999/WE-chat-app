//
//  ThankYouView.swift
//  We
//
//  Created by Om Preetham Bandi on 11/15/24.
//

import SwiftUI

struct ThankYouView: View {
    @StateObject private var viewModel = ThankYouViewModel()
    @State private var showPaletteSelection = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Private.")
                        Text("Safe.")
                        Text("Anonymous.")
                    }
                    .textCase(.uppercase)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("WE")
                        Text("BUILD")
                        Text("THE")
                        Text("WORLD")
                    }
                    .textCase(.uppercase)
                    .font(.footnote)
                    .fontDesign(.monospaced)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
                }
                .padding(.horizontal)
                .padding(.top)
                
                Spacer()
                
                Text("Thank You For Being A Part Of We")
                    .font(.title)
                    .fontDesign(.serif)
                    .fontWeight(.regular)
                    .foregroundStyle(.black)
                    .padding(.leading)
                
                Text("NOV-19-24")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .padding(.leading)
                
                Spacer()
                
                VStack(spacing: 0) {
                    ForEach(viewModel.selectedPalette.colors, id: \.self) { color in
                        color.frame(height: 60)
                    }
                }
            }
            .navigationTitle("Thank You")
            .frame(maxWidth: 350, maxHeight: 600)
            .background(viewModel.selectedPalette.background)
            .shadow(radius: 8)
            .rotation3DEffect(
                .degrees(viewModel.pitch * 7),
                axis: (x: 1, y: 0, z: 0)
            )
            .rotation3DEffect(
                .degrees(viewModel.roll * 7),
                axis: (x: 0, y: 1, z: 0)
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showPaletteSelection.toggle()
                    } label: {
                        Label("Palette", systemImage: "pencil.and.ellipsis.rectangle")
                    }
                }
            }
            .sheet(isPresented: $showPaletteSelection) {
                PaletteSelectionView(colorPalettes: viewModel.colorPalettes) { selectedPalette in
                    viewModel.selectedPalette = selectedPalette
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}

struct PaletteSelectionView: View {
    @Environment(\.dismiss) var dismiss
    
    let colorPalettes: [ColorPalette]
    var onSelect: (ColorPalette) -> Void
    
    var body: some View {
        NavigationStack {
            List(colorPalettes, id: \.name) { palette in
                Button {
                    onSelect(palette)
                    dismiss()
                } label: {
                    HStack {
                        Text(palette.name)
                        Spacer()
                        ForEach(palette.colors, id: \.self) { color in
                            color.frame(width: 20, height: 20).cornerRadius(5)
                        }
                    }
                }
            }
            .navigationTitle("Palettes")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark.circle.fill")
                            .labelStyle(.titleOnly)
                    }
                    .tint(.red)
                }
            }
        }
    }
}

#Preview {
    ThankYouView()
}
