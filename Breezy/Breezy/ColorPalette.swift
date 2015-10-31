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
    static let orange = UIColor(red: 252/255, green: 176/255 , blue: 63/255, alpha: 1)
    static let green = UIColor(red: 111/255, green: 176/255 , blue: 127/255, alpha: 1)
    static  let turquoise = UIColor(red: 6/255, green: 133/255 , blue: 135/255, alpha: 1)
    static let blue = UIColor(red: 26/255, green: 79/255 , blue: 135/255, alpha: 1)
    static let yellow = UIColor(red: 0.996, green: 0.693, blue: 0.163, alpha: 1)
    
    static func getAverageColorForTemp(temp:Double) -> UIColor {
        switch temp {
        case -100..<32:
            return UIColor(red: 0.09, green: 0.306, blue: 0.391, alpha: 1)
        case 32..<60:
            let gValue = CGFloat(round((133-93)/28*(temp-32)+93))
            return UIColor(red: 6/255, green: gValue/255 , blue: 135/255, alpha: 1)
        case 60..<70:
            return yellow
        case 70..<100:
            let gValue = CGFloat(round((176-91)/30*(100-temp)+91))
            return UIColor(red: 252/255, green: gValue/255, blue: 63/255, alpha: 1)
        default:
            return green
        }
    }
}

