//
//  File.swift
//  Breezy
//
//  Created by Matthew Goo on 10/29/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

class ColorPalette : NSObject {
    
    static let red = UIColor(red: 252/255, green: 91/255 , blue: 63/255, alpha: 1)
    static let orange = UIColor(red: 252/255, green: 176/255 , blue: 60/255, alpha: 1)
    static let green = UIColor(red: 111/255, green: 176/255 , blue: 127/255, alpha: 1)
    static  let turquoise = UIColor(red: 6/255, green: 133/255 , blue: 135/255, alpha: 1)
    static let blue = UIColor(red: 26/255, green: 79/255 , blue: 99/255, alpha: 1)
    
    
    static func getAverageColorForTemp(temp:Double) -> UIColor {
        switch temp {
        case 0..<40:
            return blue
        case 40..<60:
            return turquoise
        case 60..<65:
            return green
        case 80..<85:
            return orange
        case 85...200:
            return red
        default:
            return green
        }
    }
}