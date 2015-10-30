//
//  File.swift
//  Breezy
//
//  Created by Matthew Goo on 10/29/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

class ColorPalette : NSObject {
    
    let red = UIColor(red: 252/255, green: 91/255 , blue: 63/255, alpha: 1)
    let orange = UIColor(red: 252/255, green: 176/255 , blue: 60/255, alpha: 1)
    let green = UIColor(red: 111/255, green: 176/255 , blue: 127/255, alpha: 1)
    let turquoise = UIColor(red: 6/255, green: 133/255 , blue: 135/255, alpha: 1)
    let blue = UIColor(red: 26/255, green: 79/255 , blue: 99/255, alpha: 1)
    
    
    func getAverageColorForTemp(temp:Double) -> UIColor {
        switch temp {
        case 0..<40:
            return red
        case 40..<60:
            return orange
        case 60..<65:
            return green
        case 80..<85:
            return turquoise
        case 85...200:
            return blue
        default:
            return green
        }
    }
}