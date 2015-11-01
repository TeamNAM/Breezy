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


let suggestionIndex = [
    "rain",
    "hail",
    "sleet",
    "snow",
    "freezing",
    "cold",
    "chilly",
    "warm",
    "hot",
    "clear",
    "scattered_clouds",
    "overcast",
]

class Suggestion: Hashable {
    
    var name: String
    var imageName: String?
    var message: String?
    var description: String? {
        return message
    }
    
    init(name: String) {
        self.name = name
        self.imageName = name
        if suggestionStrings != nil {
            self.message = suggestionStrings![name] as? String
        }
    }
    
    var hashValue: Int {
        if let hash = suggestionIndex.indexOf(self.name) {
            return hash
        } else {
            assert(false, "Invalid suggestion name supplied: \(self.name)")
        }
        return 0
    }
    
    func getWhiteImage(named: String) -> UIImageView {
        var image = UIImage(named: named)
        image = image?.imageWithRenderingMode(.AlwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .ScaleAspectFit
        imageView.tintColor = UIColor.whiteColor()
        return imageView
    }
}

func ==(lhs: Suggestion, rhs: Suggestion) -> Bool {
    return lhs.name == rhs.name
}

