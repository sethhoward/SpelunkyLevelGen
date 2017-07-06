//
//  Room.swift
//  SplenkyGen
//
//  Created by Seth Howard on 6/10/17.
//  Copyright © 2017 Seth Howard. All rights reserved.
//

import Foundation
import SpriteKit

typealias MatrixIndex = (x: Int, y: Int)

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
            
            print("\(strObs1), \(strObs2), \(strObs3)")
            
            return (strObs1, strObs2, strObs3)
        }
    }
    
    mutating func placeObstacle() {
        print("b: \(self)")
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
        
        print("a: \(self)")
       // return template
    }
}

// TODO: too many pits.. not checking end start for pit creation
enum RoomType {
    case sideRoom
    case path // also known as 'main room'
    case start
    case end
    case pitTop
    case pitMiddle
    case pitBottom
    
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
        case .sideRoom:
            var template: RoomTemplate = {
                var random: Int {
                    return randomInt(min: 1, max: 9)
                }
                
                switch random {
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
        case .path where paths.contains(.drop), .pitTop:
            var template: RoomTemplate = {
                var random: Int {
                    if self == .pitTop {
                        return randomInt(min: 4, max: 12)
                    } else if let t = tempGlobalRooms.neighbor(of: room, thatIs: .up), !t.pathDirection.contains(.drop) {
                        return randomInt(min: 1, max: 12)
                    }
                    
                    return randomInt(min: 1, max: 8)
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
        case .pitMiddle:
            return "111000011111s0000s11111200211111s0000s11111200211111s0000s11111200211111s0000s11"
        case .pitBottom:
            return "111000011111s0000s1111100001111100S0001111S0110S11111STTS1111111M111111111111111"
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

enum SGSprite {
    case caveBackground
    case block
    case brick
    case pushBlock
    case spikes
    case entrance
    case exit
    case ladder
    case ladderTop
    
    func configure() -> [SKSpriteNode] {
        var sprites = [SKSpriteNode]()
        
        switch self {
        case .brick:
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "sBrick.png"), color: .clear, size: spriteSize)//SKSpriteNode(texture: SKTexture(imageNamed: "sBrick.png"))
            sprite.name = "brick"
            let physicsBody = SKPhysicsBody(rectangleOf: spriteSize)
            physicsBody.categoryBitMask = CollisionType.brick
            physicsBody.contactTestBitMask = CollisionType.character
            physicsBody.pinned = true
            physicsBody.allowsRotation = false
            sprite.physicsBody = physicsBody
            sprites.append(sprite)
        case .block:
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "sBlock.png"), color: .clear, size: spriteSize)
            sprite.name = "block"
            sprites.append(sprite)
        case .pushBlock:
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "PushBlock.png"), color: .clear, size: spriteSize)
            sprite.name = "pushBlock"
            sprites.append(sprite)
        case .entrance:
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "Entrance.png"), color: .clear, size: spriteSize)
            sprite.name = "entrance"
            sprites.append(sprite)
        case .exit:
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "Exit.png"), color: .clear, size: spriteSize)
            sprite.name = "exit"
            sprites.append(sprite)
        case .ladder:
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "Ladder.png"), color: .clear, size: spriteSize)
            sprite.name = "ladder"
            sprites.append(sprite)
        case .ladderTop:
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "LadderTop.png"), color: .clear, size: spriteSize)
            sprite.name = "ladderTop"
            sprites.append(sprite)
        case .spikes:
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "Spikes.png"), color: .clear, size: spriteSize)
            sprite.name = "spike"
            sprite.zPosition = 1
            sprites.append(sprite)
            fallthrough
        default:
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "sCaveBG.png"), color: .clear, size: spriteSize)
            sprite.name = "background"
            sprites.append(sprite)
        }
        
        return sprites
    }
    
    init?(character: Character, roomType: RoomType) {
        switch character {
        case "1" where randomInt(min: 1, max: 10) == 1:
            self = .block
        case "1":
            self = .brick
        case "2":
            if randomInt(min: 1, max: 2) == 1 {
                if randomInt(min: 1, max: 10) == 1 {
                    self = .block
                } else {
                    self = .brick
                }
            } else {
                self = .caveBackground
            }
        case "4" where randomInt(min: 1, max: 4) == 1:
            self = .pushBlock
        case "7":
            self = .spikes
        case "9" where roomType == .start:
            self = .entrance
        case "9" where roomType == .end:
            self = .exit
        case "L":
            self = .ladder
        case "P":
            self = .ladderTop
        case "0", "4",
             "7" where randomInt(min: 1, max: 3) == 1:      // can be the future 'default' assuming all textures are accounted for.
            self = .caveBackground
        default:
            print("******** missing texture \(character)")
            return nil
        }
    }
}

class RoomCell  {
    var nodes: [SKSpriteNode]? /// = SKSpriteNode(texture: nil, color: .clear, size: spriteSize)
    var sprite: SGSprite? {
        didSet {
            nodes = sprite?.configure()
            nodes?.forEach {
                $0.position = CGPoint(x: (CGFloat(gridLocation.x) * spriteSize.width), y: ((CGFloat(roomGridSize.x) - 1 - CGFloat(gridLocation.y)) * spriteSize.height))
            }
        }
    }
    var gridLocation: MatrixIndex = (0, 0) {
        didSet {
            nodes?.forEach {
                $0.position = CGPoint(x: (CGFloat(gridLocation.x) * spriteSize.width), y: ((CGFloat(roomGridSize.x) - 1 - CGFloat(gridLocation.y)) * spriteSize.height))
            }
        }
    }
    
    var color: SKColor = .clear {
        didSet {
            nodes?.forEach {
                $0.color = color
            }
        }
    }
    
    init() {}
    
    init(indexLocation: MatrixIndex) {
        gridLocation = indexLocation
    }
}

// MARK: -

// 10 x 8 collection of sprites that make up a room
class Room: SKNode {
    var pathDirection: [PathDirection] = [.unknown]
    var gridLocation: MatrixIndex = (0, 0)
    var roomType: RoomType = .sideRoom
    var entranceCell: RoomCell? {
        guard roomType == .start else { return nil }
        return ((roomLayoutNodes.flatMap { $0 }).filter { $0.sprite == .entrance }).first
    }
    
    private lazy var roomLayoutNodes: [[RoomCell]] = {
        var nodes = dim(roomGridSize.x, dim(roomGridSize.y, RoomCell()))
        
        for x in 0..<roomGridSize.x {
            for y in 0..<roomGridSize.y {
                nodes[x][y] = RoomCell()
                nodes[x][y].gridLocation = (x: x, y: y)
      //          nodes[x][y].color = randomRPG()
            }
        }
        
        return nodes
    }()
    
    var indexPosition: MatrixIndex! {
        didSet {
            gridLocation = (x: indexPosition.x, y: indexPosition.y)
            position = CGPoint(x: (CGFloat(roomGridSize.x) * spriteSize.width) * CGFloat(indexPosition.x), y: (CGFloat(roomGridSize.y) * spriteSize.height) * (3 - CGFloat(indexPosition.y)))
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateRoom() {
        if var template = roomType.template(room: self) {
            for y in 0..<roomGridSize.y {
                for x in 0..<roomGridSize.x {
                    roomLayoutNodes[x][y].sprite = SGSprite(character: template.characters.popFirst()!, roomType: roomType)
                }
            }
        }
        
        for cols in roomLayoutNodes {
            for layoutNode in cols {
                if let layoutNode = layoutNode.nodes{
                    for skNode in layoutNode {
                        addChild(skNode)
                    }
                }
            }
        }
    }
}

// MARK: - RoomPath

class RoomPath {
    var rooms: [[Room]]
    
    init(rooms: [[Room]]) {
        self.rooms = rooms
    }
    
    func generatePath() {
        var path = [Room]()
        let startRoom: Room = {
            var room: Room {
                let randomX = randomInt(min: 0, max: 3)
                return self.rooms[randomX][0]
            }
            room.roomType = .start
            return room
        }()
        
        var currentRoom: Room = startRoom
        path.append(startRoom)
        
        pathLoop: while true {
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
                guard let leftRoom = rooms.neighbor(of: currentRoom, thatIs: .left), leftRoom.roomType == .sideRoom else { return nil }
                
                leftRoom.pathDirection = [.left, .right]
                leftRoom.roomType = .path
                return leftRoom
            }
            
            var rightPath: Room? {
                guard let rightRoom = rooms.neighbor(of: currentRoom, thatIs: .right), rightRoom.roomType == .sideRoom else { return nil }
                
                rightRoom.pathDirection = [.right, .left]
                rightRoom.roomType = .path
                return rightRoom
            }
            
            // mutating currentRoom
            var downPath: Room? {
                guard let downRoom = rooms.neighbor(of: currentRoom, thatIs: .drop) else {
                    currentRoom.roomType = .end
                    return nil
                }
                
                currentRoom.pathDirection = [.left, .right, .drop]
                // label if we're not start or end
                if currentRoom.roomType == .sideRoom {
                    currentRoom.roomType = .path
                }
                
                downRoom.pathDirection = [.left, .right, .up]
                downRoom.roomType = .path
                return downRoom
            }
            
            func append(room: Room) {
                currentRoom = room
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
                        break pathLoop
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
                        break pathLoop
                    }
                }
            default: // 5
                if let room = downPath {
                    append(room: room)
                } else {
                    break pathLoop
                }
            }
        }
    }
}
