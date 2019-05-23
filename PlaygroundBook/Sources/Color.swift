//
//  Color.swift
//  Book_Sources
//
//  Created by Satsuki Hashiba on 2019/03/24.
//

import UIKit

class Color {
    class var purple: UIColor { return #colorLiteral(red: 0.7254901961, green: 0.5764705882, blue: 0.8392156863, alpha: 1) }
    class var blue: UIColor { return #colorLiteral(red: 0.6470588235, green: 0.8, blue: 0.8196078431, alpha: 1) }
    class var red: UIColor { return #colorLiteral(red: 0.5529411765, green: 0.231372549, blue: 0.4470588235, alpha: 1) }
    class var pink: UIColor { return #colorLiteral(red: 0.9215686275, green: 0.4823529412, blue: 0.7529411765, alpha: 1) }
    class var mint: UIColor { return #colorLiteral(red: 0.4980392157, green: 0.7176470588, blue: 0.7450980392, alpha: 1) }

    static func get(index: Int) -> UIColor {
        switch index % 5 {
        case 0: return Color.purple
        case 1: return Color.blue
        case 2: return Color.red
        case 3: return Color.pink
        default: return Color.mint
        }
    }
}
