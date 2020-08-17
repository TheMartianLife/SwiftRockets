import PlaygroundSupport
import SpriteKit
import UIKit

public protocol Trackable {
	var altitude: Double { get }
	var position: Double { get }
	var speed: Double { get }
}

public class Projectile: Trackable {
	public var fuelLevel: Double = 100.0
	public var altitude: Double = 0.0
	public var position: Double = 0.5
	public var speed: Double = 0.0
}

public final class LiveView {
	private static let shared = LiveView()
	private let scene = LaunchScene.empty
	private(set) var objects: [OrbitalObject] = []
	public var queuedActions: () -> () = {}
	
	private init() {}
	
	public static func queueActions(_ block: @escaping () -> ()) {
		LiveView.shared.queuedActions = block
	}
	
	public static func clearQueuedActions() {
		LiveView.shared.queuedActions()
		LiveView.shared.queuedActions = {}
	}
	
	public static func add(_ object: OrbitalObject, alive: Bool = true) {
		LiveView.shared.scene.add(object: object, alive: alive, at: object.position, at: object.altitude)
		LiveView.shared.objects.append(object)
	}
	
	public static func track(_ object: Trackable, type: OrbitalObject, to altitude: Double? = nil, ignoring: [OrbitalObject] = [], shield: Bool = false) {
		if object.altitude == 0.0 {
			LiveView.shared.scene.add(object: type, alive: true, at: object.position, at: 0.0)
			return
		}
		let possibleCollision = LiveView.obstructionsOnPath(at: object.position).first(where: { !ignoring.contains($0) })
		var newAltitude = object.altitude
		var lifetime: Double? = nil
		switch type {
			case .drone: lifetime = LaunchScene.animationDuration(for: newAltitude)
				print("Drone launched! 🤖")
			case .missile: print("Missile launched! 💣")
			case .rocketlaunch, .rocketshield: print("Rocket launched! 🚀")
			default: break
		}
		if let collision = possibleCollision {
			if type == .rocketlaunch || type == .rocketshield {
				newAltitude = collision.altitude - 0.15
					print("Collided with \(collision) and crashed 💥")
				lifetime = LaunchScene.animationDuration(for: newAltitude)
				LiveView.shared.scene.crash(delay: lifetime!)
			} else if type == .missile {
				newAltitude = altitude ?? collision.altitude
				print("Hit and removed \(collision)")
				lifetime = LaunchScene.animationDuration(for: newAltitude)
				LiveView.shared.scene.collision(at: object.position, altitude: newAltitude + 0.1, delay: lifetime!)
			}
		}
		
		LiveView.shared.scene.addMoving(object: type, at: object.position, at: 0.0, to: newAltitude, expiring: lifetime, shield: shield)
	}
	
	public static func remove(_ object: OrbitalObject, by cause: OrbitalObject) {
		if cause == .missile {
			LiveView.shared.scene.disappear(object)
		}
		
		if cause == .drone {
			LiveView.shared.scene.remove(object)
		}
	}
	
	public static func obstructionsOnPath(at x: Double, objectWidth: Double = 0.05) -> [OrbitalObject] {
		if x > 1.0 || x < 0.0 { return [] }
		var obstructions: [OrbitalObject] = []
		let minx = x - objectWidth
		let maxx = x + objectWidth
		
		for object in LiveView.shared.objects {
			let objectWidth = (object.size / 5.0) / Double(CGSize.liveViewSize.width)
			let objminx = object.position - (objectWidth / 2.0)
			let objmaxx = object.position + (objectWidth / 2.0)
			if objminx...objmaxx ~= minx || objminx...objmaxx ~= maxx {
				// traditional overlap
				obstructions.append(object)
			} else if minx < objminx && maxx > objmaxx {
				// rocket entirely spans tiny object
				obstructions.append(object)
			}
		}
		return obstructions.sorted { $0.altitude < $1.altitude }
	}
	
	public static func obstructionsWithObjects(_ objects: [OrbitalObject], at x: Double, objectWidth: Double = 0.05) -> [OrbitalObject] {
		if x > 1.0 || x < 0.0 { return [] }
		var obstructions: [OrbitalObject] = []
		let minx = x - objectWidth
		let maxx = x + objectWidth
		
		for object in objects {
			let objectWidth = (object.size / 5.0) / Double(CGSize.liveViewSize.width)
			let objminx = object.position - (objectWidth / 2.0)
			let objmaxx = object.position + (objectWidth / 2.0)
			if objminx...objmaxx ~= minx || objminx...objmaxx ~= maxx {
				// traditional overlap
				obstructions.append(object)
			} else if minx < objminx && maxx > objmaxx {
				// rocket entirely spans tiny object
				obstructions.append(object)
			}
		}
		return obstructions.sorted { $0.altitude < $1.altitude }
	}
	
	public static func display() {
		PlaygroundPage.current.liveView = LaunchViewController(scene: LiveView.shared.scene)
	}
}
