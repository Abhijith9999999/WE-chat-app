//
//  HackerTextEffect.swift
//  We
//
//

import SwiftUI

struct HackerTextEffectView: View {
    @State private var displayedText: String = ""
    @State private var currentTextIndex = 0
    @State private var sectionHeading: String = ""
    @State private var isAnimating = false
    
    let textItems: [TextItem]
    let animationDuration: Double = 1.0 // Duration of each effect in seconds
    let updateInterval: Double = 0.05   // How often the text updates in seconds
    
    var body: some View {
        Section {
            Text(displayedText)
                .font(.headline)
                .fontWeight(.semibold)
                .fontDesign(.monospaced)
                .onAppear {
                    startNextAnimation()
                }
        } header: {
            Text(sectionHeading)
                .font(.callout)
                .fontDesign(.serif)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    func startNextAnimation() {
        guard currentTextIndex < textItems.count else {
            // All animations completed
            return
        }
        
        let textItem = textItems[currentTextIndex]
        isAnimating = true
        let totalIterations = Int(animationDuration / updateInterval)
        var currentIteration = 0
        
        Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { timer in
            if currentIteration >= totalIterations {
                timer.invalidate()
                displayedText = textItem.text
                isAnimating = false
                currentTextIndex += 1
                // Start the next animation after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    startNextAnimation()
                }
            } else {
                sectionHeading = textItem.heading
                let linearProgress = Double(currentIteration) / Double(totalIterations)
                let easedProgress = easeOutSine(x: linearProgress)
                if textItem.useRandomChars {
                    displayedText = generateRandomString(length: textItem.text.count/3)
                } else {
                    displayedText = generateRandomText(targetText: textItem.text, progress: easedProgress)
                }
                currentIteration += 1
            }
        }
    }
    
    func generateRandomText(targetText: String, progress: Double) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let targetChars = Array(targetText)
        var result = ""
        for i in 0..<targetChars.count {
            if Double.random(in: 0...1) < progress {
                // Use the target character
                result.append(targetChars[i])
            } else {
                // Use a random character
                if let randomChar = characters.randomElement() {
                    result.append(randomChar)
                }
            }
        }
        return result
    }
    
    func generateRandomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-=_+[]{}|;:',.<>/?"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
    
    func easeOutSine(x: Double) -> Double {
        return sin((x * .pi) / 2)
    }
}

struct TextItem: Identifiable {
    let id: UUID = UUID()
    let heading: String
    let text: String
    let useRandomChars: Bool
}

struct HackerTextTestView: View {
    var body: some View {
        HackerTextEffectView(textItems: [
            // First text: a valid email address
            TextItem(heading: "Initializing Hashing Process:", text: "yourid@islander.tamucc.edu", useRandomChars: false),
            // Second text: random characters simulating hashing
            TextItem(heading: "Generating Secure Hash:", text: String(repeating: " ", count: 64), useRandomChars: true),
            // Third text: random characters simulating salting
            TextItem(heading: "Applying Salt for Additional Security:", text: String(repeating: " ", count: 64), useRandomChars: true),
            // Fourth text: random characters simulating encryption
            TextItem(heading: "Encrypting Data for Final Protection:", text: String(repeating: " ", count: 128), useRandomChars: true)
        ])
    }
}

#Preview {
    HackerTextTestView()
}
