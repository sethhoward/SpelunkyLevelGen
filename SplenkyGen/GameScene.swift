//
//  GameScene.swift
//  SplenkyGen
//
//  Created by Seth Howard on 6/4/17.
//  Copyright © 2017 Seth Howard. All rights reserved.
//
 
// Every thing in one place to get things moving.

import SpriteKit
import GameplayKit

// MARK: - Scene dimensions
let levelGridSize: (x: Int, y: Int) = (4, 4)
let spriteSize = CGSize(width: 32, height: 32)
let roomGridSize: (x: Int, y: Int) = (10, 8)

/// The probability that we generate a snake pit in the level
private let probSnakePit = 8
// TODO: remove, was quick and dirty logic to get things moving. It used by an enum and could be better handled as a data type.
var tempGlobalRooms: [[Room]]!

private extension RoomCell {
    var pointInRoom: CGPoint {
        return CGPoint(x: CGFloat(gridLocation.x) * spriteSize.width, y: CGFloat(gridLocation.y) * spriteSize.height)
    }
}

private extension Room {
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

// MARK: - Level

/// A level consists of 16 rooms a 4 x 4 grid. Each room holds 10 x 8 sprites (walls, ladders, floors...). A path is built from the start room to the exit. Each room as a set layout with a bit of random procedurally generated flavor so they don't all look the same see @enum RoomType.
final class Level {
    enum LevelType {
        case mines
        case jungle
        case ice
        case temple
    }
    
    // TODO: move portions level generation to LevelType
    var levelType = LevelType.mines
    // generate the layout for this level.
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
        
        // check for pit. Based on a probability 'roll' and position of rooms. Requires 3 rooms stacked ontop of each other that are not in the path.
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

// MARK: - Player

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

// MARK: - GameScene

/// scene consists of 4 x 4 grid of rooms
class GameScene: SKScene, SKPhysicsContactDelegate {
    private var level = Level()
    private let player = Player()
    
    private enum KeyState {
        case unknown
        case active(keyCode: UInt16, action: () -> Void)
    }
    
    private var keyStates: [KeyState] = [KeyState]()
    
    override func didMove(to view: SKView) {
        load()

        physicsWorld.contactDelegate = self
    }
    
    private func load() {
        (level.rooms.flatMap { $0 }).forEach { addChild($0) }
        
        let startRoom = level.startRoom
        
        if let entrance = startRoom.entranceCell {
            player.position = CGPoint(x: startRoom.locationInParent.x + entrance.pointInRoom.x, y: frame.size.height - (startRoom.locationInParent.y + entrance.pointInRoom.y - spriteSize.height))
        } else {
            fatalError()
        }
        
        let camera = SKCameraNode().build {
            $0.xScale = 1//0.4
            $0.yScale = 1//0.4
            $0.position = CGPoint(x: frame.midX, y: frame.midY)
        }
        
        self.camera = camera
        addChild(camera)
        // Uncomment to place the player
        // player.zPosition = 3
        //  addChild(player)
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
            case reload = 15
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
        case .reload:
            (level.rooms.flatMap { $0 }).forEach { _ in removeAllChildren() }
            level = Level()
            load()
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
        // Uncomment to have the camera follow the player. May need to zoom the camera in a bit.
     //   self.camera?.position = self.player.position
    }
}
