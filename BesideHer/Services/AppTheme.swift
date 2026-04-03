//
//  AppTheme.swift
//  BesideHer
//
//  Centralized theme constants for consistent styling
//

import SwiftUI

struct AppTheme {
    
    // MARK: - Colors
    
    static let primary = Color(hex: "3B7DD8")
    static let primaryDark = Color(hex: "2B5EA7")
    static let primaryLight = Color(hex: "E8F0FE")
    
    static let background = Color(hex: "F7F9FC")
    static let card = Color.white
    
    static let textPrimary = Color(hex: "1A2B42")
    static let textSecondary = Color(hex: "5A6B80")
    static let textTertiary = Color(hex: "8E9BAD")
    
    static let border = Color(hex: "E4EAF1")
    
    static let accent = Color(hex: "56B89F")
    static let accentLight = Color(hex: "E6F7F2")
    
    static let warning = Color(hex: "E8963F")
    static let warningLight = Color(hex: "FEF3E6")
    
    // MARK: - Gradients
    
    static let primaryGradient = LinearGradient(
        colors: [primary, primaryDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Shadows
    
    static let cardShadow = Color.black.opacity(0.04)
    static let primaryShadow = primary.opacity(0.25)
    
    // MARK: - Corner Radius
    
    static let cornerRadius: CGFloat = 14
    static let cornerRadiusSmall: CGFloat = 10
    static let cornerRadiusPill: CGFloat = 20
}
