//
//  Sprite.swift
//  SplenkyGen
//
//  Created by Seth Howard on 10/17/18.
//  Copyright © 2018 Seth Howard. All rights reserved.
//

import Foundation
import SpriteKit

// MARK: - SGSprite
// TODO: SGSprite needs a little more refining. This covers mines, but what about jungle etc.
// Sprite information for rendering.
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
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "sBrick.png"), color: .clear, size: spriteSize).build {
                $0.name = "brick"
                $0.physicsBody = SKPhysicsBody(rectangleOf: spriteSize).build {
                    $0.categoryBitMask = CollisionType.brick
                    $0.contactTestBitMask = CollisionType.character
                    $0.pinned = true
                    $0.allowsRotation = false
                }
            }
            
            sprites.append(sprite)
        case .block:
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "sBlock.png"), color: .clear, size: spriteSize)
            sprite.name = "block"
            sprites.append(sprite)
        case .pushBlock:
            let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "sBlock.png"), color: .clear, size: spriteSize)
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
    
    // Based off of the room type and a randomly generated number we'll assign a cooresponding texture.
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
