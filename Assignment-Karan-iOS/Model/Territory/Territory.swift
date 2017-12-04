//
//  Territory.swift
//  Assignment-Karan-iOS
//
//  Created by Karan Gavali on 02/12/17.
//  Copyright © 2017 Karan Gavali. All rights reserved.
//

import Foundation

struct Territory {
    var name: String
    var temperature: Array<Temperature>
    
    init() {
        name = ""
        temperature = []
    }
}

