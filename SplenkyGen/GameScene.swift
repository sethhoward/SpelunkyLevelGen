//
//  GameScene.swift
//  SplenkyGen
//
//  Created by Seth Howard on 6/4/17.
//  Copyright © 2017 Seth Howard. All rights reserved.
//

import SpriteKit
import GameplayKit

let levelGridSize: (x: Int, y: Int) = (4, 4)
let spriteSize = CGSize(width: 32, height: 32)
let roomGridSize: (x: Int, y: Int) = (10, 8)
var tempGlobalRooms: [[Room]]!

// scene consists of 4 x 4 grid of rooms
class GameScene: SKScene {
    private lazy var rooms: [[Room]] = {
        var rooms = dim(levelGridSize.x, dim(levelGridSize.y, Room()))
        
        for y in 0..<levelGridSize.y {
            for x in 0..<levelGridSize.x {
                rooms[x][y] = Room()
                rooms[x][y].indexPosition = (x, y)
            }
        }
        
        tempGlobalRooms = rooms
        
        var roomPath = RoomPath(rooms: rooms)
        roomPath.generatePath()
        
        for y in 0..<levelGridSize.y {
            for x in 0..<levelGridSize.x {
                rooms[x][y].generateRoom()
            }
        }
        
        // TODO: consider caching the actual room paths, rebuilding from the grid is a pain in the ass.
//        for rows in 0..<levelGridSize.rows {
//            for cols in 0..<levelGridSize.cols {
//                print("\(rooms[rows][cols].gridLocation), \(rooms[rows][cols].roomType), \(rooms[rows][cols].pathDirection) start:\(rooms[rows][cols].isStartRoom), end: \(rooms[rows][cols].isEndRoom)")
//            }
//        }
        
    //    rooms[1][0].generateStartRoom()
        
        return rooms
    }()
    
    override func didMove(to view: SKView) {
        (rooms.flatMap { $0 }).forEach { addChild($0) }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func mouseDown(with event: NSEvent) {

    }
    
    override func mouseDragged(with event: NSEvent) {

    }
    
    override func mouseUp(with event: NSEvent) {

    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        default:()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
