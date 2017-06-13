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

class Level {
    enum LevelType {
        case mines
        case jungle
        case ice
        case temple
    }
    
    var levelType = LevelType.mines
    lazy var rooms: [[Room]] = {
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
        
        // check for pit
        if self.levelType == .mines {
            for y in 0..<2 {
                for x in 0..<4 {
                    let topPitRoom = rooms[x][y]
                    if topPitRoom.roomType == .sideRoom {
                        if let middleRoom = rooms.neighbor(of: topPitRoom, thatIs: .drop), middleRoom.roomType == .sideRoom, let bottomRoom = rooms.neighbor(of: middleRoom, thatIs: .drop), bottomRoom.roomType == .sideRoom {
                            topPitRoom.roomType = .pitTop
                            middleRoom.roomType = .pitMiddle
                            bottomRoom.roomType = .pitBottom
                        }
                    }
                }
            }
        }
        
        for y in 0..<levelGridSize.y {
            for x in 0..<levelGridSize.x {
                rooms[x][y].generateRoom()
            }
        }
        return rooms
    }()
}

// scene consists of 4 x 4 grid of rooms
class GameScene: SKScene {
    let level = Level()
    
    override func didMove(to view: SKView) {
        (level.rooms.flatMap { $0 }).forEach { addChild($0) }
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
