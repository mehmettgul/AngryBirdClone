//
//  GameScene.swift
//  AngryBirdClone
//
//  Created by Mehmet Gül on 11.09.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var box1 = SKSpriteNode()
    var box2 = SKSpriteNode()
    var box3 = SKSpriteNode()
    var box4 = SKSpriteNode()
    var box5 = SKSpriteNode()
    
    var gameStarted = false
    var originalPosition : CGPoint?
    
    enum ColliderType : UInt32 { // burda verilen 1,2 gibi değerler toplanınca diğer veriyi vermemeli
        case Bird = 1
        case Box = 2
    }
    
    var score = 0
    var scoreLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        // View Çerçeve
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame) // bir çerçeve oluşturuyor.
        self.scene?.scaleMode = .aspectFit
        self.physicsWorld.contactDelegate = self
        
        // Label
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = .black
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height / 3)
        scoreLabel.zPosition = 2 // en üstte olsun ki kuşla etkileşime girmesin.
        self.addChild(scoreLabel)
        
        // Bird
        bird = childNode(withName: "bird") as! SKSpriteNode // Tasarımı koda aktarma işlemi.
        let birdTexture = SKTexture(imageNamed: "bird")
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 13)
        bird.physicsBody?.affectedByGravity = false // yerçekiminden etkilenecek.
        bird.physicsBody?.isDynamic = true // Fiziksel hareketlerden etkilenecek mi etkilenmeyecek mi?
        bird.physicsBody?.mass = 0.15 // kuşun kütlesi kg cinsten.
        originalPosition = bird.position
        
        bird.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue // çarpışma olayı için
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.collisionBitMask = ColliderType.Box.rawValue // kendisini de çarpışma olarak algılamasın.
        
        // Box
        let boxTexture = SKTexture(imageNamed: "brick")
        let size = CGSize(width: boxTexture.size().width / 6, height: boxTexture.size().height / 6)
        
        box1 = childNode(withName: "box1") as! SKSpriteNode
        box1.physicsBody = SKPhysicsBody(rectangleOf: size)
        box1.physicsBody?.isDynamic = true
        box1.physicsBody?.affectedByGravity = true
        box1.physicsBody?.allowsRotation = true // sağa sola dönsün mü dönmesin mi değeri
        box1.physicsBody?.mass = 0.4
        
        box1.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue // çarpışmaları ayırt etmek için.
         
        box2 = childNode(withName: "box2") as! SKSpriteNode
        box2.physicsBody = SKPhysicsBody(rectangleOf: size)
        box2.physicsBody?.isDynamic = true
        box2.physicsBody?.affectedByGravity = true
        box2.physicsBody?.allowsRotation = true // sağa sola dönsün mü dönmesin mi değeri
        box2.physicsBody?.mass = 0.4
        
        box2.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        box3 = childNode(withName: "box3") as! SKSpriteNode
        box3.physicsBody = SKPhysicsBody(rectangleOf: size)
        box3.physicsBody?.isDynamic = true
        box3.physicsBody?.affectedByGravity = true
        box3.physicsBody?.allowsRotation = true // sağa sola dönsün mü dönmesin mi değeri
        box3.physicsBody?.mass = 0.4
        
        box3.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        box4 = childNode(withName: "box4") as! SKSpriteNode
        box4.physicsBody = SKPhysicsBody(rectangleOf: size)
        box4.physicsBody?.isDynamic = true
        box4.physicsBody?.affectedByGravity = true
        box4.physicsBody?.allowsRotation = true // sağa sola dönsün mü dönmesin mi değeri
        box4.physicsBody?.mass = 0.4
        
        box4.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        box5 = childNode(withName: "box5") as! SKSpriteNode
        box5.physicsBody = SKPhysicsBody(rectangleOf: size)
        box5.physicsBody?.isDynamic = true
        box5.physicsBody?.affectedByGravity = true
        box5.physicsBody?.allowsRotation = true // sağa sola dönsün mü dönmesin mi değeri
        box5.physicsBody?.mass = 0.4
        
        box5.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
    }
    
    func didBegin(_ contact: SKPhysicsContact) { // Çarpışma gerçekleşince yapılacak işlemler.
        if contact.bodyA.collisionBitMask == ColliderType.Bird.rawValue ||
            contact.bodyB.collisionBitMask == ColliderType.Bird.rawValue {
            score += 1
            scoreLabel.text = String(score)
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* // kuşun uçma işlemi
         bird.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 100))
         bird.physicsBody?.affectedByGravity = true
        */
        if gameStarted == false {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self) // dokunulan yeri al
                let touchNodes = nodes(at: touchLocation) // dokunulan yerin node'unu al
                if touchNodes.isEmpty == false { // dokunulan node boş değilse
                    for node in touchNodes { // dokunulan nodelarını al.
                        if let sprite = node as? SKSpriteNode { // node'u çek
                            if sprite == bird { // çekilen node bird mü diye bak
                                bird.position = touchLocation // eğer bird'se yeni pozisyonu çekilen pozisyon olacak.
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self) // dokunulan yeri al
                let touchNodes = nodes(at: touchLocation) // dokunulan yerin node'unu al
                if touchNodes.isEmpty == false { // dokunulan node boş değilse
                    for node in touchNodes { // dokunulan nodelarını al.
                        if let sprite = node as? SKSpriteNode { // node'u çek
                            if sprite == bird { // çekilen node bird mü diye bak
                                bird.position = touchLocation // eğer bird'se yeni pozisyonu çekilen pozisyon olacak.
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self) // dokunulan yeri al
                let touchNodes = nodes(at: touchLocation) // dokunulan yerin node'unu al
                if touchNodes.isEmpty == false { // dokunulan node boş değilse
                    for node in touchNodes { // dokunulan nodelarını al.
                        if let sprite = node as? SKSpriteNode { // node'u çek
                            if sprite == bird { // çekilen node bird mü diye bak
                                let dx = -(touchLocation.x - originalPosition!.x) // x'ler arasındaki fark. TAM TERSİ YÖNE GİTSİN DİYE -
                                let dy = -(touchLocation.y - originalPosition!.y) // y'ler arasındaki fark.
                                let impulse = CGVector(dx: dx, dy: dy)
                                bird.physicsBody?.applyImpulse(impulse)
                                bird.physicsBody?.affectedByGravity = true
                                gameStarted = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let birdPhysicsBody = bird.physicsBody {
            if birdPhysicsBody.velocity.dx <= 0.1 &&
                birdPhysicsBody.velocity.dy <= 0.1 &&
                birdPhysicsBody.angularVelocity <= 0.1 &&
                gameStarted == true{
                bird.physicsBody?.affectedByGravity = false
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.angularVelocity = 0
                bird.zPosition = 1
                bird.position = originalPosition!
                gameStarted = false
                score = 0
                scoreLabel.text = String(score)
            }
        }
    }
}
/*
 burası -> en başta
 var bird2 = SKSpriteNode() // node oluşturuldu.
 burası -> didMove
 // kodla pozisyon ve büyüklük değerleri
 var texture = SKTexture(imageNamed: "bird")
 bird2 = SKSpriteNode(texture: texture)
 bird2.position = CGPoint(x: 0, y: 0)
 bird2.size = CGSize(width: 100, height: 100)
 bird2.zPosition = 1
 self.addChild(bird2)
 */
