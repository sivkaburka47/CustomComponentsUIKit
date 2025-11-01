//
//  RatingColor.swift
//  CustomComponentsApp
//
//  Created by Станислав Дейнекин on 01.11.2025.
//

import UIKit

enum RatingColor {

    static func color(for rating: Double) -> UIColor {
        switch rating {
        case 7...10:
            return .systemGreen
        case 5..<7:
            return .systemYellow
        default:
            return .systemRed
        }
    }
}

