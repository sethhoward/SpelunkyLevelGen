//
//  Room.swift
//  SplenkyGen
//
//  Created by Seth Howard on 6/10/17.
//  Copyright © 2017 Seth Howard. All rights reserved.
//

import Foundation
import SpriteKit

// MARK: -

enum PathDirection {
    case unknown
    case left
    case right
    case drop
    case up
}

typealias RoomTemplate = String

fileprivate extension RoomTemplate {
    private enum TileType: Int {
        case start = 8
        case ground = 5
        case air = 6
        
        var obstacles: (obs1: String, obs2: String, obs3: String) {
            var strObs1: String!
            var strObs2: String!
            var strObs3: String!
            
            switch self {
            case .start:
                switch randomInt(min: 1, max: 8) {
                case 1:  strObs1 = "00900"; strObs2 = "01110"; strObs3 = "11111"
                case 2:  strObs1 = "00900"; strObs2 = "02120"; strObs3 = "02120"
                case 3:  strObs1 = "00000"; strObs2 = "00000"; strObs3 = "92222"
                case 4:  strObs1 = "00000"; strObs2 = "00000"; strObs3 = "22229"
                case 5:  strObs1 = "00000"; strObs2 = "11001"; strObs3 = "19001"
                case 6:  strObs1 = "00000"; strObs2 = "10011"; strObs3 = "10091"
                case 7:  strObs1 = "11111"; strObs2 = "10001"; strObs3 = "40094"
                case 8:  strObs1 = "00000"; strObs2 = "12021"; strObs3 = "12921"
                default: assert(false)
                }
            case .ground:
                switch randomInt(min: 1, max: 16) {
                case 1:  strObs1 = "11111"; strObs2 = "00000"; strObs3 = "00000"
                case 2:  strObs1 = "00000"; strObs2 = "11110"; strObs3 = "00000"
                case 3:  strObs1 = "00000"; strObs2 = "01111"; strObs3 = "00000"
                case 4:  strObs1 = "00000"; strObs2 = "00000"; strObs3 = "11111"
                case 5:  strObs1 = "00000"; strObs2 = "20200"; strObs3 = "17177"
                case 6:  strObs1 = "00000"; strObs2 = "02020"; strObs3 = "71717"
                case 7:  strObs1 = "00000"; strObs2 = "00202"; strObs3 = "77171"
                case 8:  strObs1 = "00000"; strObs2 = "22200"; strObs3 = "11100"
                case 9:  strObs1 = "00000"; strObs2 = "02220"; strObs3 = "01110"
                case 10:  strObs1 = "00000"; strObs2 = "00222"; strObs3 = "00111"
                case 11:  strObs1 = "11100"; strObs2 = "22200"; strObs3 = "00000"
                case 12:  strObs1 = "01110"; strObs2 = "02220"; strObs3 = "00000"
                case 13:  strObs1 = "00111"; strObs2 = "00222"; strObs3 = "00000"
                case 14:  strObs1 = "00000"; strObs2 = "02220"; strObs3 = "21112"
                case 15:  strObs1 = "00000"; strObs2 = "20100"; strObs3 = "77117"
                case 16:  strObs1 = "00000"; strObs2 = "00102"; strObs3 = "71177"
                default: assert(false)
                }
            case .air:
                switch randomInt(min: 1, max: 10) {
                case 1:  strObs1 = "11111"; strObs2 = "00000"; strObs3 = "00000"
                case 2:  strObs1 = "22222"; strObs2 = "00000"; strObs3 = "00000"
                case 3:  strObs1 = "11100"; strObs2 = "22200"; strObs3 = "00000"
                case 4:  strObs1 = "01110"; strObs2 = "02220"; strObs3 = "00000"
                case 5:  strObs1 = "00111"; strObs2 = "00222"; strObs3 = "00000"
                case 6:  strObs1 = "00000"; strObs2 = "01110"; strObs3 = "00000"
                case 7:  strObs1 = "00000"; strObs2 = "01110"; strObs3 = "02220"
                case 8:  strObs1 = "00000"; strObs2 = "02220"; strObs3 = "01110"
                case 9:  strObs1 = "00000"; strObs2 = "00220"; strObs3 = "01111"
                case 10:  strObs1 = "00000"; strObs2 = "22200"; strObs3 = "11100"
                default: assert(false)
                }
            }
            
            return (strObs1, strObs2, strObs3)
        }
    }
    
    mutating func placeObstacle() {
        //var template = String(self)! // returned value
        print("\(self)")
        var tempString = String(self)! // observed
        for i in 0..<self.count {
            if let tileValue = Int(String(tempString.characters.popFirst()!)), let tile = TileType(rawValue: tileValue) {
                    var j = i
                    let obstacles = tile.obstacles
                    
                    func substituteObstacle(at offset: Int, with obstacleFragment: String) {
                        let start = self.index(self.startIndex, offsetBy: j)
                        let end = self.index(self.startIndex, offsetBy: j + 4)
                        self.replaceSubrange(start...end, with: obstacleFragment)
                    }
                    
                    substituteObstacle(at: j, with: obstacles.obs1)
                    j += 10
                    substituteObstacle(at: j, with: obstacles.obs2)
                    j += 10
                    substituteObstacle(at: j, with: obstacles.obs3)
            }
        }
        
       // return template
    }
}

enum RoomType {
    case unknown
    case path // also known as 'main room'
    case start
    case end
    
    func template(room: Room) -> RoomTemplate? {
        let paths = room.pathDirection
        switch self {
        case .start:
            var template: RoomTemplate = {
                var random: Int {
                    if paths.contains(.drop) {
                        return randomInt(min: 5, max: 8)
                    } else {
                        return randomInt(min: 1, max: 4)
                    }
                }
                
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
            
            template.placeObstacle()
            return template
        case .unknown:
            var template: RoomTemplate = {
                var randome: Int {
                    return randomInt(min: 1, max: 9)
                }
                
                switch randome {
                case 1: return "00000000000010111100000000000000011010000050000000000000000000000000001111111111"
                // high walls
                case 2: return "110000000040L600000011P000000011L000000011L5000000110000000011000000001111111111"
                case 3: return "00000000110060000L040000000P110000000L110050000L11000000001100000000111111111111"
                case 4: return "110000000040L600000011P000000011L000000011L0000000110000000011000000001112222111"
                case 5: return "00000000110060000L040000000P110000000L110000000L11000000001100000000111112222111"
                case 6: return "11111111110221111220002111120000022220000002222000002111120002211112201111111111"
                case 7: return "11111111111112222111112000021111102201111120000211111022011111200002111112222111"
                case 8: return "11111111110000000000110000001111222222111111111111112222221122000000221100000011"
                case 9: return "121111112100L2112L0011P1111P1111L2112L1111L1111L1111L1221L1100L0000L001111221111"
                // idols
                case 10: return "22000000220000B0000000000000000000000000000000000000000000000000I000001111A01111"
                // altars
                case 11: return "220000002200000000000000000000000000000000000000000000x0000002211112201111111111"
                default:
                    assert(false)
                }
            }()
            
            template.placeObstacle()
            return template
        case .path where !paths.contains(.up) && !paths.contains(.drop): // left or right room
            var template: RoomTemplate = {
                let random = randomInt(min: 1, max: 12)
                
                switch random {
                // basic rooms
                case 1: return "60000600000000000000000000000000000000000050000000000000000000000000001111111111"
                case 2: return "60000600000000000000000000000000000000005000050000000000000000000000001111111111"
                case 3: return "60000600000000000000000000000000050000000000000000000000000011111111111111111111"
                case 4: return "60000600000000000000000600000000000000000000000000000222220000111111001111111111"
                case 5: return "11111111112222222222000000000000000000000050000000000000000000000000001111111111"
                case 6: return "11111111112111111112022222222000000000000050000000000000000000000000001111111111"
                // low ceiling
                case 7: return "11111111112111111112211111111221111111120111111110022222222000000000001111111111"
                // ladders
                case 8:
                    if randomInt(min: 1, max: 2) == 1 {
                        return "1111111111000000000L111111111P000000000L5000050000000000000000000000001111111111"
                    } else {
                        return "1111111111L000000000P111111111L0000000005000050000000000000000000000001111111111"
                    }
                case 9: return "000000000000L0000L0000P1111P0000L0000L0000P1111P0000L1111L0000L1111L001111111111"
                // upper plats
                case 10: return "00000000000111111110001111110000000000005000050000000000000000000000001111111111"
                case 11: return "00000000000000000000000000000000000000000021111200021111112021111111121111111111"
                // treasure below
                case 12:
                    if randomInt(min: 1, max: 2) == 1 {
                        return "2222222222000000000000000000L001111111P001050000L011000000L010000000L01111111111"
                    } else {
                        return "222222222200000000000L000000000P111111100L500000100L000000110L000000011111111111"
                    }
                default:
                    assert(false)
                }
            }()
                
            template.placeObstacle()
            return template
        case .path where paths.contains(.up):   // has an up path
            var template: RoomTemplate = {
                switch(randomInt(min: 1, max: 8)) {
                    // basic rooms
                    case 1: return "00000000000000000000000000000000000000000050000000000000000000000000001111111111"
                    case 2: return "00000000000000000000000000000000000000005000050000000000000000000000001111111111"
                    case 3: return "00000000000000000000000000000050000500000000000000000000000011111111111111111111"
                    case 4: return "00000000000000000000000600000000000000000000000000000111110000111111001111111111"
                    // upper plats
                    case 5: return "00000000000111111110001111110000000000005000050000000000000000000000001111111111"
                    case 6: return "00000000000000000000000000000000000000000021111200021111112021111111121111111111"
                    case 7: return "10000000011112002111111200211100000000000022222000111111111111111111111111111111"
                    // treasure below
                    case 8:
                        if (randomInt(min: 1, max: 2) == 1) {
                            return "0000000000000000000000000000L001111111P001050000L011000000L010000000L01111111111"
                        }
                        else {
                            return "000000000000000000000L000000000P111111100L500000100L000000110L000000011111111111"
                        }
                default:
                    assert(false)
                }
            }()
            
            template.placeObstacle()
            return template
        case .path where paths.contains(.drop):
            var template: RoomTemplate = {
                var random = 0
                
                if let t = tempGlobalRooms.neighbor(of: room, thatIs: .up), !t.pathDirection.contains(.drop) {
                    random = randomInt(min: 1, max: 12)
                } else {
                    random = randomInt(min: 1, max: 8)
                }
                
                switch random {
                case 1: return "00000000006000060000000000000000000000006000060000000000000000000000000000000000"
                case 2: return "00000000006000060000000000000000000000000000050000000000000000000000001202111111"
                case 3: return "00000000006000060000000000000000000000050000000000000000000000000000001111112021"
                case 4: return "00000000006000060000000000000000000000000000000000000000000002200002201112002111"
                case 5: return "00000000000000220000000000000000200002000112002110011100111012000000211111001111"
                case 6: return "00000000000060000000000000000000000000000000000000001112220002100000001110111111"
                case 7: return "00000000000060000000000000000000000000000000000000002221110000000001201111110111"
                case 8: return "00000000000060000000000000000000000000000000000000002022020000100001001111001111"
                case 9: return "11111111112222222222000000000000000000000000000000000000000000000000001120000211"
                case 10: return "11111111112222111111000002211100000002110000000000200000000000000000211120000211"
                case 11: return "11111111111111112222111220000011200000000000000000000000000012000000001120000211"
                case 12: return "11111111112111111112021111112000211112000002112000000022000002200002201111001111"
                default: assert(false)
                }
            }()
            
            template.placeObstacle()
            return template
        case .end:
            var template: RoomTemplate = {
                var randomeNumber = 0
                if (paths.contains(.up)) {
                    randomeNumber = randomInt(min: 2, max: 4)
                } else {
                    randomeNumber = randomInt(min: 3, max: 6)
                }
                switch randomeNumber {
                case 1: return "00000000006000060000000000000000000000000008000000000000000000000000001111111111"
                case 2: return "00000000000000000000000000000000000000000008000000000000000000000000001111111111"
                case 3: return "00000000000010021110001001111000110111129012000000111111111021111111201111111111"
                case 4: return "00000000000111200100011110010021111011000000002109011111111102111111121111111111"
                // no drop
                case 5: return "60000600000000000000000000000000000000000008000000000000000000000000001111111111"
                case 6: return "11111111112222222222000000000000000000000008000000000000000000000000001111111111"
                default: assert(false)
                }
            }()
            
            template.placeObstacle()
            return template
        default:
            return nil
        }
    }
}

// MARK: -

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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateRoom() {
        //        guard isStartRoom else {
        //            assert(false)
        //        }
        
        print("\(roomType)")
        
        if let template = roomType.template(room: self) {
            var template = template
            
            for y in 0..<roomGridSize.y {
                for x in 0..<roomGridSize.x {
                    let char = template.characters.popFirst()!
                    switch char {
                    case "0":
                        roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "sCaveBG.png")
                    case "1":
                        if randomInt(min: 1, max: 10) == 1 {
                            roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "sBlock.png")
                        } else {
                            roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "sBrick.png")
                        }
                    case "2":
                        if randomInt(min: 1, max: 2) == 1 {
                            if randomInt(min: 1, max: 10) == 1 {
                                roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "sBlock.png")
                            } else {
                                roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "sBrick.png")
                            }
                        } else {
                            roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "sCaveBG.png")
                        }
                    case "4":
                        if randomInt(min: 1, max: 4) == 1 {
                            roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "PushBlock.png")
                        } else {
                            roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "sCaveBG.png")
                        }
                    case "7":
                        if randomInt(min: 1, max: 3) == 1 {
                            roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "sCaveBG.png")
                        } else {
                            roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "Spikes.png")
                        }
                    case "9":
                        if roomType == .start {
                            roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "Entrance.png")
                        } else {
                            roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "Exit.png")
                        }
                    case "L":
                        roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "Ladder.png")
                    case "P":
                        roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "LadderTop.png")
                    default:()
                        print("******** missing texture \(char)")
                        //  roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "sCaveBG.png")
                    }
                    
                    
                }
            }
        }
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
        var path = [Room]()
        let startRoom: Room = {
            let randomX = randomInt(min: 0, max: 3)
            let room = self.rooms[randomX][0]
            room.isStartRoom = true
            room.roomType = .start
            room.pathDirection = [.left, .right]
            self.rooms[randomX][0] = room
            return room
        }()
        
        var currentRoom: Room = startRoom
        path.append(startRoom)
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
            
            var leftPath: Room? {
                guard let leftRoom = rooms.neighbor(of: currentRoom, thatIs: .left), leftRoom.roomType == .unknown else { return nil }
                
                leftRoom.pathDirection = [.left, .right]
                leftRoom.roomType = .path
                return leftRoom
            }
            
            var rightPath: Room? {
                guard let rightRoom = rooms.neighbor(of: currentRoom, thatIs: .right), rightRoom.roomType == .unknown else { return nil }
                
                rightRoom.pathDirection = [.right, .left]
                rightRoom.roomType = .path
                return rightRoom
            }
            
            // mutating
            var downPath: Room? {
                guard let downRoom = rooms.neighbor(of: currentRoom, thatIs: .drop) else {
                    currentRoom.roomType = .end
                    currentRoom.isEndRoom = true
                    rooms[currentRoom.gridLocation.x][currentRoom.gridLocation.y] = currentRoom
                   // path.append(currentRoom)
                    return nil
                }
                
                currentRoom.pathDirection = [.left, .right, .drop]
                if currentRoom.roomType == .unknown {
                    currentRoom.roomType = .path
                }
                rooms[currentRoom.gridLocation.x][currentRoom.gridLocation.y] = currentRoom
                //path.append(currentRoom)
                downRoom.pathDirection = [.left, .right, .up]
                downRoom.roomType = .path
                return downRoom
            }
            
            func append(room: Room) {
                currentRoom = room
                rooms[currentRoom.gridLocation.x][currentRoom.gridLocation.y] = currentRoom
                path.append(currentRoom)
            }
            
            // Path generation
            switch randomNumber {
            case 0..<3, 6, 7:
                if let room = leftPath {
                    append(room: room)
                } else if let room = rightPath {
                    append(room: room)
                } else {
                    if let room = downPath {
                        append(room: room)
                    } else {
                        running = false
                    }
                }
            case 3, 4:
                if let room = rightPath {
                    append(room: room)
                } else if let room = leftPath {
                    append(room: room)
                } else {
                    if let room = downPath {
                        append(room: room)
                    } else {
                        running = false
                    }
                }
            default: // 5
                if let room = downPath {
                    append(room: room)
                } else {
                    running = false
                }
            }
        }
        
        for room in path {
            print("l: \(room.gridLocation) d: \(room.pathDirection) t: \(room.roomType)")
        }
    }
}
