import SpriteKit
import UIKit

extension CGSize {
	static let liveViewSize = CGSize(width: 600.0, height: 600.0)
}

extension UIColor {
	static let clear = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
	static let sky = UIColor(red: 0.07, green:  0.37, blue:  0.58, alpha: 1.0)
}


extension SKSpriteNode {
	func drawBorder() {
		 if let currentTexture = self.texture {
			let biggerSprite = SKSpriteNode(texture: currentTexture)
			biggerSprite.colorBlendFactor = 1.0
			biggerSprite.color = SKColor.cyan
			biggerSprite.xScale *= 1.3
			biggerSprite.yScale *= 1.3
			biggerSprite.position = CGPoint.zero
			biggerSprite.name = "aura"
			biggerSprite.zPosition = self.zPosition + 1
			addChild(biggerSprite)
		}
	}
}

public class LaunchScene: SKScene {
	
	private var stationaryNodes: [OrbitalObject: SKSpriteNode] = [:]
	private var waitCounters = 0 {
		willSet {
			if newValue == 0 {
				LiveView.clearQueuedActions()
			}
		}
	}
	
	public static func animationDuration(for distance: Double) -> TimeInterval {
		return (distance * Double(CGSize.liveViewSize.height)) / 100.0 as TimeInterval
	}
	
	public func add(object: OrbitalObject, alive: Bool = true, at position: Double = 0.0, at altitude: Double = 0.0, expiring: Double? = nil) {
		let sprite = object.sprite
		sprite.size = CGSize(width: object.size / 5.0, height: object.size / 5.0)
		sprite.anchorPoint.y = 0.0
		sprite.position.x = CGFloat(position) * CGSize.liveViewSize.width
		sprite.position.y = CGFloat(altitude) * CGSize.liveViewSize.height
		if !alive {
			sprite.color = .black
			sprite.colorBlendFactor = 0.5
		}
		self.addChild(sprite)
		self.stationaryNodes[object] = sprite
		if let expiry = expiring {
			let fadeHold = SKAction.fadeAlpha(to: 1.0, duration: expiry)
			let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1)
			self.waitCounters += 1
			sprite.run(SKAction.sequence([fadeHold, fadeOut]), completion: {
				self.waitCounters -= 1
			})
		}
	}
	
	public func addMoving(object: OrbitalObject, at position: Double, at altitude: Double, to newAltitude: Double, expiring: Double? = nil, shield: Bool = false) {
		var offset: CGFloat = 0.0
		if object == .rocketlaunch {
			offset -= 0.1
		}
		let sprite = (shield && object == .rocketshield) ? OrbitalObject.rocketshield.sprite : object.sprite
		sprite.size = CGSize(width: object.size / 5.0, height: object.size / 5.0)
		sprite.anchorPoint.y = 0.0
		sprite.position.x = CGFloat(position) * CGSize.liveViewSize.width
		sprite.position.y = (CGFloat(altitude) + offset) * CGSize.liveViewSize.height
		self.addChild(sprite)
		let distance = CGFloat(newAltitude - altitude)
		let movement = SKAction.moveBy(x: 0.0, y: (distance + offset) * CGSize.liveViewSize.height, duration: LaunchScene.animationDuration(for: Double(distance)))
		self.waitCounters += 1
		sprite.run(movement, completion: {
			self.waitCounters -= 1
		})
		if let expiry = expiring {
			let fadeHold = SKAction.fadeAlpha(to: 1.0, duration: expiry)
			let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1)
			self.waitCounters += 1
			sprite.run(SKAction.sequence([fadeHold, fadeOut]), completion: {
				self.waitCounters -= 1
			})
		}
	}
	
	public func disappear(_ object: OrbitalObject) {
		guard let sprite = self.stationaryNodes[object] else {
			fatalError("Collided with a non-existent SpriteNode? (\(object))")
		}
		let fadeHold = SKAction.fadeAlpha(to: 1.0, duration: LaunchScene.animationDuration(for: object.altitude))
		let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1)
		self.waitCounters += 1
		sprite.run(SKAction.sequence([fadeHold, fadeOut]), completion: {
			self.waitCounters -= 1
		})
		self.stationaryNodes[object] = nil
	}
	
	public func remove(_ object: OrbitalObject) {
		guard let sprite = self.stationaryNodes[object] else {
			fatalError("Collided with a non-existent SpriteNode? (\(object))")
		}
		var altitude = object.altitude
		if object == .debris {
			altitude *= 1.3
		}
		let distance = CGFloat(1.0 - altitude)
		let wait = SKAction.fadeAlpha(to: 1.0, duration: LaunchScene.animationDuration(for: altitude))
		let movement = SKAction.moveBy(x: 0.0, y: distance * CGSize.liveViewSize.height, duration: LaunchScene.animationDuration(for: Double(distance)))
		self.waitCounters += 1
		sprite.run(SKAction.sequence([wait, movement]), completion: {
			self.waitCounters -= 1
		})
		self.stationaryNodes[object] = nil
	}
	
	public func crash(delay: Double = 0.0) {
		let explosion = SKSpriteNode(imageNamed: "crash.png")
		explosion.position.x = CGSize.liveViewSize.width / 2.0
		explosion.position.y = CGSize.liveViewSize.height / 2.0
		explosion.size = self.size
		explosion.alpha = 0.0
		self.addChild(explosion)
		let fadeHold = SKAction.fadeAlpha(to: 0.0, duration: delay)
		let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1)
		self.waitCounters += 1
		explosion.run(SKAction.sequence([fadeHold, fadeIn]), completion: {
			self.waitCounters -= 1
		})
	}
	
	public func collision(at position: Double, altitude: Double, delay: Double) {
		let collision = SKSpriteNode(imageNamed: "collision.png")
		collision.position.x = CGFloat(position) * CGSize.liveViewSize.width
		collision.position.y = CGFloat(altitude) * CGSize.liveViewSize.height
		collision.size = CGSize(width: 100, height: 100)
		collision.alpha = 0.0
		self.addChild(collision)
		let fadeHold = SKAction.fadeAlpha(to: 0.0, duration: delay)
		let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1)
		let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 3)
		self.waitCounters += 1
		collision.run(SKAction.sequence([fadeHold, fadeIn, fadeOut]), completion: {
			self.waitCounters -= 1
		})
	}
	
	public static var empty: LaunchScene {
		let launchScene = LaunchScene(size: CGSize.liveViewSize )
		launchScene.scaleMode = .aspectFit
		launchScene.backgroundColor = .sky
		return launchScene
	}
}


public extension SKView {
	static func viewWrapper(for scene: SKScene) -> SKView {
		let frame = CGRect(x: 0, y: 0, width: scene.size.width, height: scene.size.height)
		let sceneView = SKView(frame: frame)
		sceneView.presentScene(scene)
		sceneView.backgroundColor = .clear
		return sceneView
	}
}

public class LaunchViewController: UIViewController {
	public let launchScene: LaunchScene
	let launchSceneView: SKView
	
	public init(scene: LaunchScene?) {
		self.launchScene = scene ?? LaunchScene.empty
		self.launchSceneView = SKView.viewWrapper(for: self.launchScene)
		super.init(nibName: nil, bundle: nil)
		self.preferredContentSize = CGSize.liveViewSize
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func loadView() {
		super.loadView()
		self.view.backgroundColor = .clear
		view.addSubview(launchSceneView)
	}
	
	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		let frameWidth = view.frame.width
		let frameHeight = view.frame.height
		let difference = frameWidth - frameHeight
		if difference > 0 {
			let origin = CGPoint(x: difference / 2.0, y: 0.0)
			let size = CGSize(width: frameHeight, height: frameHeight)
			launchSceneView.frame = CGRect(origin: origin, size: size)
		} else {
			let origin = CGPoint(x: 0.0, y: -difference / 2.0)
			let size = CGSize(width: frameWidth, height: frameWidth)
			launchSceneView.frame = CGRect(origin: origin, size: size)
		}
	}
}
