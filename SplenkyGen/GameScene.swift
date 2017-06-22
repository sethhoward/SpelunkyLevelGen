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

private let probSnakePit = 8

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
        if self.levelType == .mines && randomInt(min: 1, max: probSnakePit) == 1 {
            func createPit() {
                for y in 0..<2 {
                    for x in 0..<4 {
                        let topPitRoom = rooms[x][y]
                        if topPitRoom.roomType == .sideRoom {
                            if let middleRoom = rooms.neighbor(of: topPitRoom, thatIs: .drop), middleRoom.roomType == .sideRoom, let bottomRoom = rooms.neighbor(of: middleRoom, thatIs: .drop), bottomRoom.roomType == .sideRoom {
                                topPitRoom.roomType = .pitTop
                                middleRoom.roomType = .pitMiddle
                                bottomRoom.roomType = .pitBottom
                                return
                            }
                        }
                    }
                }
            }
            
            createPit()
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
    
    enum KeyState {
        case unknown
        case active(keyCode: UInt16, action: () -> Void)
    }
    
    var keyStates: [KeyState] = [KeyState]()
    
    override func didMove(to view: SKView) {
        (level.rooms.flatMap { $0 }).forEach { addChild($0) }
        
        let cam = SKCameraNode()
   //     cam.xScale = 0.45
   //     cam.yScale = 0.45
        
        camera = cam
        addChild(cam)
        cam.position = CGPoint(x: frame.midX, y: frame.midY)
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
        enum Key: UInt16 {
            case left = 123
            case right = 124
            case down = 125
            case up = 126
        }
        
        guard !event.isARepeat else { return }
        
        let offset: CGFloat = 4
        let key = Key(rawValue: event.keyCode)!
        
        switch key {
        case .left:
            keyStates.append(.active(keyCode: event.keyCode) {
                self.camera?.position = CGPoint(x: self.camera!.position.x - offset, y: self.camera!.position.y)
            })
        case .right:
            keyStates.append(.active(keyCode: event.keyCode) {
                self.camera?.position = CGPoint(x: self.camera!.position.x + offset, y: self.camera!.position.y)
            })
        case .up:
            keyStates.append(.active(keyCode: event.keyCode) {
                self.camera?.position = CGPoint(x: self.camera!.position.x, y: self.camera!.position.y + offset)
            })
        case .down:
            keyStates.append(.active(keyCode: event.keyCode) {
                self.camera?.position = CGPoint(x: self.camera!.position.x, y: self.camera!.position.y - offset)
            })
        }
    }
    
    override func keyUp(with event: NSEvent) {
        // remove the key
        keyStates = keyStates.filter {
            switch $0 {
            case .active(let keyCode, _):
                if keyCode == event.keyCode {
                    return false
                }
            default:
                return true
            }
            
            return true
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // execute any key/touch/mouse events
        for keyState in keyStates {
            if case let .active(_, event) = keyState {
                event()
            }
        }
    }
}
