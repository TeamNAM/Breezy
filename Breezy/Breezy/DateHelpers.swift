//
//  DateHelpers.swift
//  Breezy
//
//  Created by Matthew Goo on 10/24/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

extension NSDate
{
    convenience
    init(dateString:String, dateStringFormatter: NSDateFormatter! = NSDateFormatter()) {
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}