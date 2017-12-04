//
//  Tempreture.swift
//  Assignment-Karan-iOS
//
//  Created by Karan Gavali on 02/12/17.
//  Copyright © 2017 Karan Gavali. All rights reserved.
//

import Foundation

struct Temperature {
    var name: String
    var url: String
    var listOfTemp: Array<Weather>
    
    init() {
        name = ""
        url = ""
        listOfTemp = []
    }
    
}

struct Weather {
    var year: String
    var listOfValues: Array<String>
    
    init() {
        year = ""
        listOfValues = []
    }
}


