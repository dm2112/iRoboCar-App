//
//  Instruction.swift
//  iRoboCar
//
//  Created by Daniel Morrison on 1/17/19.
//  Copyright © 2019 TheFabFive. All rights reserved.
//

import Foundation
import UIKit

class Instruction: NSObject {
    //public var title: String!
    var direction: String!
    public var duration: Double!
    public var speed: Double!
    
    init(duration: String, speed: String, direction: String)
    {
        //self.title = title
        self.duration = Double(duration)
        self.speed = Double(speed)
        self.direction = direction
    }
}
