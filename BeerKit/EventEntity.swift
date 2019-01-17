//
//  EventEntity.swift
//  BeerKit
//
//  Created by Kei Fujikawa on 2019/01/16.
//  Copyright © 2019 kboy. All rights reserved.
//

import Foundation

public struct EventEntity: Codable {
    let event: String
    let data: Data?
    
    public init(event: String, data: Data? = nil){
        self.event = event
        self.data = data
    }
}
