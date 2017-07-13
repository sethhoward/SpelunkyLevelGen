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
private let probSnakePit = 8
// TODO: remove, was quick and dirty logic to get things moving
var tempGlobalRooms: [[Room]]!

extension RoomCell {
    var pointInRoom: CGPoint {
        return CGPoint(x: CGFloat(gridLocation.x) * spriteSize.width, y: CGFloat(gridLocation.y) * spriteSize.height)
    }
}

extension Room {
    var locationInParent: CGPoint {
        return CGPoint(x: CGFloat(gridLocation.x) * roomSize.width, y: CGFloat(gridLocation.y * roomSize.rows))
    }
    
    var roomSize: CGSize {
        return CGSize(width: spriteSize.width * CGFloat(roomGridSize.x), height: spriteSize.height * CGFloat(roomGridSize.y))
    }
}

struct CollisionType {
    static let brick: UInt32 = 0x1 << 1
    static let character: UInt32 = 0x1 << 2
}

class Level {
    enum LevelType {
        case mines
        case jungle
        case ice
        case temple
    }
    
    // TODO: move portions level generation to LevelType.
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
    
    lazy var startRoom: Room = {
        return ((self.rooms.flatMap { $0 }).filter { return ($0.roomType == .start) }).first!
    }()
}

class Player: SKSpriteNode {
    init() {
        super.init(texture: SKTexture(imageNamed: "charStandLeft.png"), color: .clear, size:CGSize(width: 32, height: 32))
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 28))
        physicsBody.allowsRotation = false
        physicsBody.categoryBitMask = CollisionType.character
        physicsBody.contactTestBitMask = CollisionType.brick
        self.physicsBody = physicsBody
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// scene consists of 4 x 4 grid of rooms
class GameScene: SKScene, SKPhysicsContactDelegate {
    let level = Level()
    var player: Player!
    
    enum KeyState {
        case unknown
        case active(keyCode: UInt16, action: () -> Void)
    }
    
    var keyStates: [KeyState] = [KeyState]()
    
    override func didMove(to view: SKView) {
        (level.rooms.flatMap { $0 }).forEach { addChild($0) }
        
        let camera = SKCameraNode().build {
            $0.xScale = 1//0.4
            $0.yScale = 1//0.4
            
            $0.position = CGPoint(x: frame.midX, y: frame.midY)
            
//            let startRoom = level.startRoom
            
//            if let entrance = startRoom.entranceCell {
//                $0.position = CGPoint(x: startRoom.locationInParent.x + entrance.pointInRoom.x, y: frame.size.height - (startRoom.locationInParent.y + entrance.pointInRoom.y - spriteSize.height))
//            } else {
//                assert(false)
//            }
        }
        
        player = Player()
        let startRoom = level.startRoom

        if let entrance = startRoom.entranceCell {
            player.position = CGPoint(x: startRoom.locationInParent.x + entrance.pointInRoom.x, y: frame.size.height - (startRoom.locationInParent.y + entrance.pointInRoom.y - spriteSize.height))
        } else {
            assert(false)
        }
        
        player.zPosition = 3
      //  addChild(player)
        
        self.camera = camera
        addChild(camera)
        
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("collision: \(contact.bodyA) :: \(contact.bodyB)")
    }
    
    override func keyDown(with event: NSEvent) {
        enum Key: UInt16 {
            case left = 123
            case right = 124
            case down = 125
            case up = 126
        }
        
        guard let key = Key(rawValue: event.keyCode), !event.isARepeat else { return }
        
        let offset: CGFloat = 4
        
        switch key {
        case .left:
            keyStates.append(.active(keyCode: event.keyCode) {
                self.camera?.position = CGPoint(x: self.camera!.position.x - offset, y: self.camera!.position.y)
                self.player.position = self.camera!.position
            })
        case .right:
            keyStates.append(.active(keyCode: event.keyCode) {
                self.camera?.position = CGPoint(x: self.camera!.position.x + offset, y: self.camera!.position.y)
                self.player.position = self.camera!.position
            })
        case .up:
            keyStates.append(.active(keyCode: event.keyCode) {
                self.camera?.position = CGPoint(x: self.camera!.position.x, y: self.camera!.position.y + offset)
                self.player.position = self.camera!.position
            })
        case .down:
            keyStates.append(.active(keyCode: event.keyCode) {
                self.camera?.position = CGPoint(x: self.camera!.position.x, y: self.camera!.position.y - offset)
                self.player.position = self.camera!.position
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
        
     //   self.camera?.position = self.player.position
    }
}
