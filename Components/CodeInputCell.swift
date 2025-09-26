//
//  CodeInputCell.swift
//  We
//
//

import SwiftUI

struct CodeInputCell: View {
    @Binding var code: String
    let codeLength: Int
    
    @FocusState private var isInputActive: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(0..<codeLength, id: \.self) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                            .frame(width: 50, height: 60)
                            .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)

                        if index < code.count {
                            Text(String(code[code.index(code.startIndex, offsetBy: index)]))
                                .font(.title)
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
            .overlay(
                TextField("", text: $code)
                    .keyboardType(.numberPad)
                    .focused($isInputActive)
                    .opacity(0)
                    .onChange(of: code) { oldValue, newValue in
                        if newValue.count > codeLength {
                            code = String(newValue.prefix(codeLength))
                        }
                    }
            )
        }
        .onTapGesture {
            isInputActive = true
        }
    }
}

#Preview {
    CodeInputCell(code: .constant("123"), codeLength: 6)
}
