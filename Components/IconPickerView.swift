//
//  IconPickerView.swift
//  We
//
//

import SwiftUI

struct IconPickerView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var viewTitle: String
    @Binding var selectedColor: String // This will hold the selected color's hex value
    @Binding var selectedSymbol: String
    
    // Predefined list of colors with their hex codes
    private let colorOptions: [(color: Color, hex: String)] = [
        (.teal, "#30B0C7"),
        (.red, "#FF3B30"),
        (.orange, "#FF9400"),
        (.mint, "#00C7BE"),
        (.yellow, "#FFCC00"),
        (.green, "#34C759"),
        (.indigo, "#5856D6"),
        (.blue, "#007AFF"),
        (.purple, "#AF52DE"),
        (.pink, "#FF2D55"),
        (.gray, "#8E8E93"),
        (.brown, "#A2845E"),
        (.black, "#000000"),
        (.cyan, "#32ADE6"),
    ]
    
    // Predefined SF Symbols for icon selection (you can expand this list)
    private let symbols: [String] = [
        // Education and Student Life
        "graduationcap.fill", "book.fill", "books.vertical.fill", "studentdesk", "building.columns.fill",
        "pencil", "bookmark.fill", "backpack.fill", "calendar", "person.3.fill",
        "magnifyingglass", "laptopcomputer", "paperclip", "folder.fill", "doc.text.fill",
        "tray.full.fill", "clipboard.fill", "list.bullet.clipboard.fill", "bubble.left.and.bubble.right.fill", "ruler.fill",
        
        // Job Market and Professional Symbols
        "briefcase.fill", "building.2.fill", "chart.bar.fill", "chart.pie.fill", "person.2.wave.2.fill",
        "doc.text.magnifyingglass", "envelope.fill", "hammer.fill", "person.crop.circle.badge.checkmark", "signature",
        "globe", "network", "creditcard.fill", "dollarsign.circle.fill", "person.crop.circle.fill.badge.questionmark",
        
        // Social and Communication
        "message.fill", "phone.fill", "person.2.fill", "person.wave.2.fill", "person.fill",
        
        // Technology and Tools
        "desktopcomputer", "printer.fill", "camera.fill", "lock.fill", "key.fill",
        
        // Travel and Daily Life
        "airplane", "car.fill", "bicycle", "map.fill", "globe.americas.fill"
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color(hex: selectedColor)) // Color filled from selected hex
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Image(systemName: selectedSymbol)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                }
                .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
                .padding()
                
                List {
                    VStack(spacing: 20) {
                        // Color Picker Grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 15) {
                            ForEach(colorOptions, id: \.hex) { option in
                                Circle()
                                    .fill(option.color.gradient.materialActiveAppearance(.automatic))
                                    .frame(width: 40, height: 40)
                                    .padding(4)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.secondary.opacity(selectedColor == option.hex ? 0.5 : 0), lineWidth: 4)
                                    )
                                    .onTapGesture {
                                        selectedColor = option.hex // Update the hex code when color is selected
                                    }
                            }
                        }
                        
                        Divider()
                        
                        // SF Symbol Picker Grid
                        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 50)), count: 6), spacing: 20) {
                            ForEach(symbols, id: \.self) { symbol in
                                Image(systemName: symbol)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(12)
                                    .background(selectedSymbol == symbol ? Color(hex: selectedColor).opacity(0.5) : .init(uiColor: .tertiaryLabel))
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        selectedSymbol = symbol // Update the selected symbol
                                    }
                            }
                        }
                    }
                }
                .listStyle(.sidebar)
            }
            .navigationTitle(viewTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark.circle.fill")
                            .labelStyle(.titleOnly)
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Done", systemImage: "checkmark.circle.fill")
                            .labelStyle(.titleOnly)
                    }
                }
            }
        }
    }
}

#Preview {
    IconPickerView(viewTitle: "SwiftUI Icon Picker", selectedColor: .constant("#30B0C7"), selectedSymbol: .constant("graduationcap.fill"))
}
