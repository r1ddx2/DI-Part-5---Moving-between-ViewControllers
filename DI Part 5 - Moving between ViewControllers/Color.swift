//
//  Color.swift
//  DI Part 5 - Moving between ViewControllers
//
//  Created by Red Wang on 2023/11/1.
//

import UIKit
enum Color: String, CaseIterable {
    case red
    case orange
    case yellow
    case green
    case blue
    
    var backgroundColor: UIColor {
        switch self {
        case .red:
            return .red
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .blue:
            return .blue
        }
    }
}
