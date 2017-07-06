//
//  Helpers.swift
//  SplenkyGen
//
//  Created by Seth Howard on 6/10/17.
//  Copyright © 2017 Seth Howard. All rights reserved.
//

import Foundation
import SpriteKit

protocol Buildable: class {}
extension Buildable {
    @discardableResult func build(_ transform: (Self) -> Void) -> Self {
        transform(self)
        return self
    }
}

extension NSObject: Buildable {}

func randomInt(min: Int, max:Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
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
