//
//  Suggestion.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/27/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

//let images = {"rain": {"imageName": "umbrella", "message": "It's going to rain today! Be sure to bring an umbrella"}}
//let suggestionData = ["rain": ["imageName": "umbrella", "message": "It's going to rain today! Be sure to bring an umbrella"]]

class Suggestion {
    
    var name: String
    var imageName: String?
    var message: String?
    var description: String?{
        return message
    }
    
    init(name: String) {
        self.name = name
        self.imageName = name
        print(suggestionStrings)
        if suggestionStrings != nil {
            self.message = suggestionStrings![name] as? String
        }
    }
}
