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
    case down
    case up
}

enum RoomType {
    case unknown
    case path // also known as 'main room'
    case start
    case end
    
    // TODO: make extension on string... also make string a typealias
    private func placeObstacle(template: inout String) {
        let start: Character = "8"
        let ground: Character = "5"
        let air: Character = "6"
        
        var tempString = template
        for i in 0..<template.count {
            var strObs1 = "00000"
            var strObs2 = "00000"
            var strObs3 = "00000"
            let tile = tempString.characters.popFirst()!
            
            if tile == start {
                switch randomInt(min: 1, max: 8) {
                    case 1:  strObs1 = "00900"; strObs2 = "01110"; strObs3 = "11111";
                    case 2:  strObs1 = "00900"; strObs2 = "02120"; strObs3 = "02120";
                    case 3:  strObs1 = "00000"; strObs2 = "00000"; strObs3 = "92222";
                    case 4:  strObs1 = "00000"; strObs2 = "00000"; strObs3 = "22229";
                    case 5:  strObs1 = "00000"; strObs2 = "11001"; strObs3 = "19001";
                    case 6:  strObs1 = "00000"; strObs2 = "10011"; strObs3 = "10091";
                    case 7:  strObs1 = "11111"; strObs2 = "10001"; strObs3 = "40094";
                    case 8:  strObs1 = "00000"; strObs2 = "12021"; strObs3 = "12921";
                    default: assert(false)
                }
            }
            else if tile == ground {
                switch randomInt(min: 1, max: 16) {
                    case 1:  strObs1 = "11111"; strObs2 = "00000"; strObs3 = "00000";
                    case 2:  strObs1 = "00000"; strObs2 = "11110"; strObs3 = "00000";
                    case 3:  strObs1 = "00000"; strObs2 = "01111"; strObs3 = "00000";
                    case 4:  strObs1 = "00000"; strObs2 = "00000"; strObs3 = "11111";
                    case 5:  strObs1 = "00000"; strObs2 = "20200"; strObs3 = "17177";
                    case 6:  strObs1 = "00000"; strObs2 = "02020"; strObs3 = "71717";
                    case 7:  strObs1 = "00000"; strObs2 = "00202"; strObs3 = "77171";
                    case 8:  strObs1 = "00000"; strObs2 = "22200"; strObs3 = "11100";
                    case 9:  strObs1 = "00000"; strObs2 = "02220"; strObs3 = "01110";
                    case 10:  strObs1 = "00000"; strObs2 = "00222"; strObs3 = "00111";
                    case 11:  strObs1 = "11100"; strObs2 = "22200"; strObs3 = "00000";
                    case 12:  strObs1 = "01110"; strObs2 = "02220"; strObs3 = "00000";
                    case 13:  strObs1 = "00111"; strObs2 = "00222"; strObs3 = "00000";
                    case 14:  strObs1 = "00000"; strObs2 = "02220"; strObs3 = "21112";
                    case 15:  strObs1 = "00000"; strObs2 = "20100"; strObs3 = "77117";
                    case 16:  strObs1 = "00000"; strObs2 = "00102"; strObs3 = "71177";
                    default: assert(false)
                }
            }
            else if tile == air {
                switch randomInt(min: 1, max: 10) {
                case 1:  strObs1 = "11111"; strObs2 = "00000"; strObs3 = "00000";
                case 2:  strObs1 = "22222"; strObs2 = "00000"; strObs3 = "00000";
                case 3:  strObs1 = "11100"; strObs2 = "22200"; strObs3 = "00000";
                case 4:  strObs1 = "01110"; strObs2 = "02220"; strObs3 = "00000";
                case 5:  strObs1 = "00111"; strObs2 = "00222"; strObs3 = "00000";
                case 6:  strObs1 = "00000"; strObs2 = "01110"; strObs3 = "00000";
                case 7:  strObs1 = "00000"; strObs2 = "01110"; strObs3 = "02220";
                case 8:  strObs1 = "00000"; strObs2 = "02220"; strObs3 = "01110";
                case 9:  strObs1 = "00000"; strObs2 = "00220"; strObs3 = "01111";
                case 10:  strObs1 = "00000"; strObs2 = "22200"; strObs3 = "11100";
                default: assert(false)
                }
            }
            
            var j = i
            if tile == "5" || tile == "6" || tile == "8" {
                var start = template.index(template.startIndex, offsetBy: j)
                var end = template.index(template.startIndex, offsetBy: j + 4)
                template.replaceSubrange(start...end, with: strObs1)
                j += 10;
                
                start = template.index(template.startIndex, offsetBy: j)
                end = template.index(template.startIndex, offsetBy: j + 4)
                template.replaceSubrange(start...end, with: strObs2)
                
                j += 10;
                start = template.index(template.startIndex, offsetBy: j)
                end = template.index(template.startIndex, offsetBy: j + 4)
                template.replaceSubrange(start...end, with: strObs3)
            }
        }
    }
    
    func template(paths: [PathDirection]) -> String? {
        switch self {
        case .start:
            var template: String = {
                var random: Int {
                    if paths.contains(.left) || paths.contains(.right) {
                        return randomInt(min: 5, max: 8)
                    } else {
                        return randomInt(min: 1, max: 4)
                    }
                }
                
                var returnString = ""//11111111112222222222000000000000000000000008000000000000000000000000001111111111"
                
               // return returnString
                
                switch random {
                case 1:
                    returnString = "60000600000000000000000000000000000000000008000000000000000000000000001111111111"
                case 2:
                    returnString =  "11111111112222222222000000000000000000000008000000000000000000000000001111111111"
                case 3:
                    returnString =  "00000000000008000000000000000000L000000000P111111000L111111000L00111111111111111"
                case 4:
                    returnString =  "0000000000008000000000000000000000000L000111111P000111111L001111100L001111111111"
                case 5:
                    returnString =  "60000600000000000000000000000000000000000008000000000000000000000000002021111120"
                case 6:
                    returnString =  "11111111112222222222000000000000000000000008000000000000000000000000002021111120"
                case 7:
                    returnString =  "00000000000008000000000000000000L000000000P111111000L111111000L00011111111101111"
                case 8:
                    returnString =  "0000000000008000000000000000000000000L000111111P000111111L001111000L001111011111"
                default:
                    assert(false)
                }
                
                placeObstacle(template: &returnString)
                return returnString
            }()
            
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
        
        if let template = roomType.template(paths: pathDirection) {
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
                    case "9":
                        if roomType == .start {
                            roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "Entrance.png")
                        }
                    case "L":
                        roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "Ladder.png")
                    case "P":
                        roomLayoutNodes[x][y].background.texture = SKTexture(imageNamed: "LadderTop.png")
                    default:()
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
        let startRoom: Room = {
            let randomX = randomInt(min: 0, max: 3)
            let room = rooms[randomX][0]
            room.isStartRoom = true
            room.roomType = .path
            rooms[randomX][0] = room
            return room
        }()
        
        var currentRoom = startRoom
        currentRoom.roomType = .start
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
                    currentRoom.roomType = .end
                    currentRoom.isEndRoom = true
                    rooms[currentRoom.gridLocation.x][currentRoom.gridLocation.y] = currentRoom
                    
                    return false
                }
                
                currentRoom.pathDirection = [.left, .right, .down]
                if currentRoom.roomType == .unknown {
                    currentRoom.roomType = .path
                }
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
