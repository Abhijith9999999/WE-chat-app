//
//  PasswordStrengthView.swift
//  We
//
//

import SwiftUI

struct PasswordStrengthView: View {
    @Binding var password: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
//            Text("Password Strength:")
//                .font(.caption)
            
            HStack(spacing: 5) {
                ForEach(0..<4) { index in
                    Rectangle()
                        .fill(self.color(forStrength: index))
                        .frame(height: 5)
                }
            }
        }
    }
    
    private func color(forStrength strength: Int) -> Color {
        let passwordStrength = self.passwordStrength()
        return strength < passwordStrength ? .green : .gray.opacity(0.3)
    }
    
    private func passwordStrength() -> Int {
        var strength = 0
        let patterns = ["[a-z]", "[A-Z]", "[0-9]", "[^a-zA-Z0-9]"]
        
        for pattern in patterns {
            if password.range(of: pattern, options: .regularExpression) != nil {
                strength += 1
            }
        }
        
        return strength
    }
}

#Preview {
    PasswordStrengthView(password: .constant("hello"))
}
