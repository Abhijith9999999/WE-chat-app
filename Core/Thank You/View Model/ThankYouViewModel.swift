//
//  ThankYouViewModel.swift
//  We
//
//

import SwiftUI
import CoreMotion

// Define a color palette model
struct ColorPalette {
    let background: Color
    let colors: [Color]
    let name: String
}

class ThankYouViewModel: ObservableObject {
    private var motionManager = CMMotionManager()
    
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    
    @Published var selectedPalette: ColorPalette
    @Published var colorPalettes: [ColorPalette]
    
    // Initialize with a default color palette
    init() {
        selectedPalette = ColorPalette(
            background: Color(red: 221/255, green: 213/255, blue: 196/255),
            colors: [
                Color(red: 247/255, green: 197/255, blue: 68/255),
                Color(red: 229/255, green: 76/255, blue: 53/255),
                Color(red: 198/255, green: 49/255, blue: 45/255),
                Color(red: 152/255, green: 45/255, blue: 65/255),
                Color(red: 112/255, green: 38/255, blue: 71/255)
            ],
            name: "Default"
        )
        
        // List of color palettes
        colorPalettes = [
            ColorPalette(
                background: Color(red: 221/255, green: 213/255, blue: 196/255),
                colors: [
                    Color(red: 247/255, green: 197/255, blue: 68/255),
                    Color(red: 229/255, green: 76/255, blue: 53/255),
                    Color(red: 198/255, green: 49/255, blue: 45/255),
                    Color(red: 152/255, green: 45/255, blue: 65/255),
                    Color(red: 112/255, green: 38/255, blue: 71/255)
                ],
                name: "Default"
            ),
            ColorPalette(
                background: Color(red: 200/255, green: 230/255, blue: 201/255),
                colors: [
                    Color(red: 120/255, green: 144/255, blue: 156/255),
                    Color(red: 96/255, green: 125/255, blue: 139/255),
                    Color(red: 69/255, green: 90/255, blue: 100/255),
                    Color(red: 55/255, green: 71/255, blue: 79/255),
                    Color(red: 38/255, green: 50/255, blue: 56/255)
                ],
                name: "Cool Tones"
            ),
            ColorPalette(
                background: Color(red: 255/255, green: 236/255, blue: 179/255),
                colors: [
                    Color(red: 255/255, green: 202/255, blue: 40/255),
                    Color(red: 251/255, green: 140/255, blue: 0/255),
                    Color(red: 239/255, green: 108/255, blue: 0/255),
                    Color(red: 230/255, green: 81/255, blue: 0/255),
                    Color(red: 191/255, green: 54/255, blue: 12/255)
                ],
                name: "Warm Tones"
            ),
            ColorPalette(
                background: Color(red: 240/255, green: 240/255, blue: 240/255),
                colors: [
                    Color(red: 189/255, green: 189/255, blue: 189/255),
                    Color(red: 158/255, green: 158/255, blue: 158/255),
                    Color(red: 117/255, green: 117/255, blue: 117/255),
                    Color(red: 66/255, green: 66/255, blue: 66/255),
                    Color(red: 33/255, green: 33/255, blue: 33/255)
                ],
                name: "Neutral Tones"
            ),
            ColorPalette(
                background: Color(red: 245/255, green: 233/255, blue: 211/255),
                colors: [
                    Color(red: 193/255, green: 154/255, blue: 107/255),
                    Color(red: 156/255, green: 122/255, blue: 95/255),
                    Color(red: 112/255, green: 85/255, blue: 70/255),
                    Color(red: 87/255, green: 69/255, blue: 61/255),
                    Color(red: 64/255, green: 50/255, blue: 40/255)
                ],
                name: "Earth Tones"
            ),
            ColorPalette(
                background: Color(red: 255/255, green: 244/255, blue: 228/255),
                colors: [
                    Color(red: 255/255, green: 204/255, blue: 204/255),
                    Color(red: 255/255, green: 229/255, blue: 204/255),
                    Color(red: 255/255, green: 255/255, blue: 204/255),
                    Color(red: 204/255, green: 255/255, blue: 204/255),
                    Color(red: 204/255, green: 229/255, blue: 255/255)
                ],
                name: "Pastel Tones"
            ),
            ColorPalette(
                background: Color(red: 240/255, green: 255/255, blue: 240/255),
                colors: [
                    Color(red: 0/255, green: 128/255, blue: 128/255),
                    Color(red: 0/255, green: 150/255, blue: 136/255),
                    Color(red: 75/255, green: 175/255, blue: 80/255),
                    Color(red: 139/255, green: 195/255, blue: 74/255),
                    Color(red: 255/255, green: 235/255, blue: 59/255)
                ],
                name: "Vibrant Tones"
            ),
            ColorPalette(
                background: Color(red: 250/255, green: 230/255, blue: 255/255),
                colors: [
                    Color(red: 233/255, green: 30/255, blue: 99/255),
                    Color(red: 156/255, green: 39/255, blue: 176/255),
                    Color(red: 103/255, green: 58/255, blue: 183/255),
                    Color(red: 63/255, green: 81/255, blue: 181/255),
                    Color(red: 33/255, green: 150/255, blue: 243/255)
                ],
                name: "Bright Tones"
            ),
            ColorPalette(
                background: Color(red: 255/255, green: 240/255, blue: 245/255),
                colors: [
                    Color(red: 255/255, green: 105/255, blue: 180/255),
                    Color(red: 255/255, green: 182/255, blue: 193/255),
                    Color(red: 255/255, green: 160/255, blue: 122/255),
                    Color(red: 250/255, green: 128/255, blue: 114/255),
                    Color(red: 255/255, green: 99/255, blue: 71/255)
                ],
                name: "Soft Tones"
            )
        ]
        
        startMotionUpdates()
    }
    
    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1 / 60 // 60 Hz updates
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
                guard let motion = motion, error == nil else { return }
                self?.pitch = motion.attitude.pitch
                self?.roll = motion.attitude.roll
            }
        }
    }
    
    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    deinit {
        stopMotionUpdates()
    }
}
