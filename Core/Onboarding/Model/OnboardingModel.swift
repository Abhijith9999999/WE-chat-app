//
//  OnboardingModel.swift
//  We
//
//

import Foundation

struct OnboardingInfo: Identifiable {
    var id = UUID()
    var label: String
    var content: String?
    var systemName: String
}
