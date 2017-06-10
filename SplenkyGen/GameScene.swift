//
//  GameScene.swift
//  SplenkyGen
//
//  Created by Seth Howard on 6/4/17.
//  Copyright © 2017 Seth Howard. All rights reserved.
//

import SpriteKit
import GameplayKit

fileprivate let levelGridSize: (x: Int, y: Int) = (4, 4)
private let spriteSize = CGSize(width: 32, height: 32)
fileprivate let roomGridSize: (x: Int, y: Int) = (10, 8)

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

// MARK: -

class RoomCell {
    let background: SKSpriteNode
    
//    var indexPosition: (x: Int, y: Int)! {
//        didSet {
//            gridLocation = (x: indexPosition.x, y: indexPosition.y)
//
//        }
//    }
    
    var gridLocation: (x: Int, y: Int) = (0, 0) {
        didSet {
            position = CGPoint(x: (CGFloat(gridLocation.x) * spriteSize.width), y: ((CGFloat(roomGridSize.x) - 1 - CGFloat(gridLocation.y)) * spriteSize.height))
        }
    }
    
    var position: CGPoint {
        get {
            return background.position
        }
        set(newPosition) {
            background.position = newPosition
        }
    }
    
    var bgColor: SKColor {
        set(newColor) {
            background.color = newColor
        }
        get {
            return background.color
        }
    }
    
    init() {
        background = SKSpriteNode(color: .clear, size: spriteSize)
        background.anchorPoint = CGPoint(x: 0, y: 0)
    }
    
//    init(index: (x: Int, y: Int), size: CGSize) {
//        background = SKSpriteNode(color: .clear, size: size)
//       // background.colorBlendFactor = 1
//        // The positions should be static
//        // CGPoint(x: CGFloat(rows) * self.spriteSize.width, y: CGFloat(cols) * self.spriteSize.height)
//
//        position = CGPoint(x: (CGFloat(index.x) * spriteSize.width), y: ((CGFloat(roomGridSize.x) - 1 - CGFloat(index.y)) * spriteSize.height))
//        print("\(position)")
//      //  self.position = CGPoint(x: position.x, y: position.y)
//        background.anchorPoint = CGPoint(x: 0, y: 0)
//    }
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

// MARK: -

enum PathDirection {
    case unknown
    case left
    case right
    case down
    case up
}

// TODO: check what the room types are... i think 2 is a passage and 3 is a down
enum RoomType {
    case unknown
    case path
}

// 10 x 8 collection of sprites that make up a room
class Room: SKNode {
    var isStartRoom = false
    var isEndRoom = false
    var pathDirection: [PathDirection] = [.unknown] // [.left, .right, .top]
    var gridLocation: (x: Int, y: Int) = (0, 0)
    var roomType: RoomType = .unknown
    
    private lazy var roomLayoutNodes: [[RoomCell]] = {
        var nodes = dim(roomGridSize.x, dim(roomGridSize.y, RoomCell()))
        
        for x in 0..<roomGridSize.x {
            for y in 0..<roomGridSize.y {
               // let position = CGPoint(x: CGFloat(rows) * spriteSize.width, y: CGFloat(cols) * spriteSize.height)
                nodes[x][y] = RoomCell()
                nodes[x][y].gridLocation = (x: x, y: y)
                nodes[x][y].bgColor = randomRPG()
            }
        }
        
        count += 1
        return nodes
    }()
    
    var indexPosition: (x: Int, y: Int)! {
        didSet {
            gridLocation = (x: indexPosition.x, y: indexPosition.y)
            position = CGPoint(x: (CGFloat(roomGridSize.x) * spriteSize.width) * CGFloat(indexPosition.x), y: (CGFloat(roomGridSize.y) * spriteSize.height) * (3 - CGFloat(indexPosition.y)))
        }
    }
    
    override init() {
        super.init()
        for cols in roomLayoutNodes {
            for node in cols {
                addChild(node.background)
            }
        }
    }
//
//    init(indexX: Int, indexY: Int) {
//
//
//        super.init()
//        position = CGPoint(x: (CGFloat(roomGridSize.rows) * spriteSize.width) * CGFloat(indexX), y: (CGFloat(roomGridSize.rows) * spriteSize.height) * (3 - CGFloat(indexY)))
//
//    //    (roomLayoutNodes.flatMap { $0 }).forEach { addChild($0.background) }
//
//        for cols in roomLayoutNodes {
//            for node in cols {
//                addChild(node.background)
//            }
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateStartRoom() {
//        guard isStartRoom else {
//            assert(false)
//        }
        
        var template: String = {
            var random: Int {
                if pathDirection.contains(.left) || pathDirection.contains(.right) {
                    return randomInt(min: 5, max: 8)
                } else {
                    return randomInt(min: 1, max: 4)
                }
            }
            
            return "11111111112222222222000000000000000000000008000000000000000000000000001111111111"
            
            switch random {
            case 1:
                return "60000600000000000000000000000000000000000008000000000000000000000000001111111111"
            case 2:
                return "11111111112222222222000000000000000000000008000000000000000000000000001111111111"
            case 3:
                return "00000000000008000000000000000000L000000000P111111000L111111000L00111111111111111"
            case 4:
                return "0000000000008000000000000000000000000L000111111P000111111L001111100L001111111111"
            case 5:
                return "60000600000000000000000000000000000000000008000000000000000000000000002021111120"
            case 6:
                return "11111111112222222222000000000000000000000008000000000000000000000000002021111120"
            case 7:
                return "00000000000008000000000000000000L000000000P111111000L111111000L00011111111101111"
            case 8:
                return "0000000000008000000000000000000000000L000111111P000111111L001111000L001111011111"
            default:
                assert(false)
            }
        }()
        
        for y in 0..<roomGridSize.y {
            for x in 0..<roomGridSize.x {
                let char = template.characters.popFirst()!
                print("\(char) \(x) \(y) \(roomLayoutNodes[x][y].position)")
                switch char {
                case "1":
                    roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "sBrick.png")
                case "L":
                    roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "Ladder.png")
                case "P":
                    roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "LadderTop.png")
                default:
                    roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "sCaveBG.png")
                }
                
                
            }
        }
    }
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
        case .down:
            let index: (x: Int, y: Int) = (room.gridLocation.x, room.gridLocation.y + 1)
            if index.y < self[0].count {
                return self[index.x][index.y]
            }
        default: ()
        }
        
        return nil
    }
}

private func randomInt(min: Int, max:Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

// MARK: -

/*
 0 - side roome
 1 - left and right
 2- left right and bottom
 3 - left right top
 
 */

// maybe make this a class?
struct RoomPath {
    var rooms: [[Room]]
    
    mutating func generatePath() {
        let startRoom: Room = {
            let randomX = randomInt(min: 0, max: 3)
            let room = rooms[randomX][0]
            room.isStartRoom = true
            room.roomType = .path
            rooms[randomX][0] = room
           return room
        }()
       // var previousRoom = startRoom
        var currentRoom = startRoom
        var running = true
        
        while running {
            var randomNumber: Int {
                switch currentRoom.gridLocation.x {
                case 0:
                    return randomInt(min: 3, max: 5) // right
                case 3:
                    return randomInt(min: 5, max: 7) // left
                default:
                    return randomInt(min: 1, max: 5)
                }
            }
            
            func createLeftPath() -> Bool {
                guard let leftRoom = rooms.neighbor(of: currentRoom, thatIs: .left), leftRoom.roomType == .unknown else { return false }
                
                leftRoom.pathDirection = [.left, .right]
                leftRoom.roomType = .path
                currentRoom = leftRoom
                rooms[currentRoom.gridLocation.x][currentRoom.gridLocation.y] = currentRoom
                
                return true
            }
            
            func createRightPath() -> Bool {
                guard let rightRoom = rooms.neighbor(of: currentRoom, thatIs: .right), rightRoom.roomType == .unknown else { return false }
                
                rightRoom.pathDirection = [.right, .left]
                rightRoom.roomType = .path
                currentRoom = rightRoom
                rooms[currentRoom.gridLocation.x][currentRoom.gridLocation.y] = currentRoom
                    
                return true
            }
            
            func createDownPath() -> Bool {
                guard let downRoom = rooms.neighbor(of: currentRoom, thatIs: .down) else {
                    currentRoom.roomType = .path
                    currentRoom.isEndRoom = true
                    rooms[currentRoom.gridLocation.x][currentRoom.gridLocation.y] = currentRoom
                    
                    return false
                }
                
                currentRoom.pathDirection = [.left, .right, .down]
                currentRoom.roomType = .path
                rooms[currentRoom.gridLocation.x][currentRoom.gridLocation.y] = currentRoom
                downRoom.pathDirection = [.left, .right, .up]
                downRoom.roomType = .path
                currentRoom = downRoom
                rooms[currentRoom.gridLocation.x][currentRoom.gridLocation.y] = currentRoom
                
                return true
            }
            
            // Path generation
            switch randomNumber {
            case 0..<3, 6, 7:
                if !createLeftPath() {
                    if !createRightPath() {
                        if !createDownPath() {
                            running = false
                        }
                    }
                }
            case 3, 4:
                if !createRightPath() {
                    if !createLeftPath() {
                        if !createDownPath() {
                            running = false
                        }
                    }
                }
            default:
                if !createDownPath() {
                    running = false
                }
            }
        }
    }
}

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
        
//        var rooms = [[Room]]()
//        for rows in 0..<levelGridSize.rows {
//            var row = [Room]()
//            for cols in 0..<levelGridSize.cols {
//                let room = Room(indexX: rows, indexY: cols)
//                row.append(room)
//            }
//            rooms.append(row)
//        }
        
 //       var roomPath = RoomPath(rooms: rooms)
       // roomPath.generatePath()
        
        // TODO: consider caching the actual room paths, rebuilding from the grid is a pain in the ass.
//        for rows in 0..<levelGridSize.rows {
//            for cols in 0..<levelGridSize.cols {
//                print("\(rooms[rows][cols].gridLocation), \(rooms[rows][cols].roomType), \(rooms[rows][cols].pathDirection) start:\(rooms[rows][cols].isStartRoom), end: \(rooms[rows][cols].isEndRoom)")
//            }
//        }
        
        rooms[1][0].generateStartRoom()
        
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
