//
//  WhatsNew.swift
//  We
//
//

import Foundation

struct Feature: Identifiable {
    var id = UUID()
    var title: String
    var content: String
}

struct WhatsNew: Identifiable {
    var id = UUID()
    var version: String
    var features: [Feature]
}
