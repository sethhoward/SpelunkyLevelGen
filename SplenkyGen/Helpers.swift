//
//  Helpers.swift
//  SplenkyGen
//
//  Created by Seth Howard on 6/10/17.
//  Copyright © 2017 Seth Howard. All rights reserved.
//

import Foundation
import SpriteKit

func randomInt(min: Int, max:Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

var rgb: (CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0)
var count = -2
func randomRPG() -> SKColor {
    if rgb.0 >= 254 {
        rgb.0 = 0
    }
    if rgb.1 >= 254 {
        rgb.1 = 0
    }
    if rgb.2 >= 254 {
        rgb.2 = 0
    }
    
    switch count {
    case -2, -1, 0:
        rgb.0 += 3.1875
    case 1:
        rgb.1 += 3.1875
    case 2:
        rgb.2 += 3.1875
    default:
        rgb = (0, 0, 0)
        count = 0
        return randomRPG()
    }
    
    return SKColor(calibratedRed: rgb.0/255, green: rgb.1/255, blue: rgb.2/255, alpha: 1)
}

extension Array where Element == [Room] {
    func neighbor(of room: Room, thatIs pathDirection: PathDirection) -> Room? {
        switch pathDirection {
        case .left:
            let index: (x: Int, y: Int) = (room.gridLocation.x - 1, room.gridLocation.y)
            if index.x >= 0 {
                return self[index.x][index.y]
            }
        case .right:
            let index: (x: Int, y: Int) = (room.gridLocation.x + 1, room.gridLocation.y)
            if index.x < self.count {
                return self[index.x][index.y]
            }
        case .drop:
            let index: (x: Int, y: Int) = (room.gridLocation.x, room.gridLocation.y + 1)
            if index.y < self[0].count {
                return self[index.x][index.y]
            }
        default:()
        }
        
        return nil
    }
}

func dim<T>(_ count: Int, _ value: T) -> [T] {
    return [T](repeating: value, count: count)
}

// MARK: -

extension CGSize {
    public init(rows: Int, cols: Int) {
        self = CGSize(width: rows, height: cols)
    }
    
    var rows: Int {
        return Int(self.width)
    }
    
    var cols: Int {
        return Int(self.height)
    }
}
