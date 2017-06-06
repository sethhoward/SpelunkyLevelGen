//
//  GameScene.swift
//  SplenkyGen
//
//  Created by Seth Howard on 6/4/17.
//  Copyright © 2017 Seth Howard. All rights reserved.
//

import SpriteKit
import GameplayKit

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

class RoomCell {
    let background: SKSpriteNode
    
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
    
    init(position: CGPoint, size: CGSize) {
        background = SKSpriteNode(color: .clear, size: size)
        background.colorBlendFactor = 1
        // The positions should be static
        self.position = position
        background.anchorPoint = CGPoint(x: 0, y: 0)
    }
}

var rgb: (CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0)
var count = -1
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
    case -1:
        rgb.0 += 3.1875
    case 0:
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

// 10 x 8 collection of sprites that make up a room
class Room: SKNode {
    private let screenSize = CGSize(rows: 8, cols: 10)
    private let spriteSize = CGSize(width: 32, height: 32)
    
    private lazy var roomLayoutNodes: [[RoomCell]] = {
        rgb.0 = 0
        rgb.1 = 0
        rgb.2 = 0
        var nodes = [[RoomCell]]()
        for cols in 0...self.screenSize.cols {
            var row = [RoomCell]()
            for rows in 0...self.screenSize.rows {
                let position = CGPoint(x: CGFloat(cols) * self.spriteSize.width, y: CGFloat(rows) * self.spriteSize.height)
                let roomCell = RoomCell(position: position, size: self.spriteSize)
                roomCell.bgColor = randomRPG()
                row.append(roomCell)
            }
            nodes.append(row)
        }
        
        count += 1
        return nodes
    }()
    
    init(indexX: Int, indexY: Int) {
        super.init()
        position = CGPoint(x: (CGFloat(screenSize.cols) * spriteSize.width) * CGFloat(indexX), y: (CGFloat(screenSize.rows) * spriteSize.height) * CGFloat(indexY))
        for cols in roomLayoutNodes {
            for node in cols {
                addChild(node.background)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// scene consists of 4 x 4 grid of rooms
class GameScene: SKScene {
    private let gridSize = CGSize(rows: 4, cols: 4)
    
    private lazy var rooms: [[Room]] = {
        var rooms = [[Room]]()
        for rows in 0...self.gridSize.rows {
            var col = [Room]()
            for cols in 0...self.gridSize.cols {
                let room = Room(indexX: cols, indexY: rows)
                col.append(room)
            }
            rooms.append(col)
        }
        
        return rooms
    }()
    
    override func didMove(to view: SKView) {
        //(rooms.flatMap { $0 }).forEach { addChild($0) }
        for cols in 0...gridSize.cols {
            for rows in 0...gridSize.rows {
                addChild(rooms[cols][rows])
            }
        }
        
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
