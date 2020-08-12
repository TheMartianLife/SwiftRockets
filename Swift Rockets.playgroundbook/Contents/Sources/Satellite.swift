import SpriteKit
import UIKit


public enum OrbitalObject: Trackable {
	
	case chandra, compton, debris, drone, explorer, hubble, iss, landsat
	case missile, noaa15, rocket, rocketlaunch, rocketshield, spitzer, sputnik, tiros, vanguard

	public var image: UIImage {
		return UIImage(named: self.filename)!
	}
	
	public var sprite: SKSpriteNode {
		return SKSpriteNode(imageNamed: self.filename)
	}
	
	public var filename: String {
		switch self {
			case .chandra: return "chandra.png"
			case .compton: return "compton.png"
			case .debris: return "debris.png"
			case .drone: return "drone.png"
			case .explorer: return "explorer.png"
			case .hubble: return "hubble.png"
			case .iss: return "iss.png"
			case .landsat: return "landsat.png"
			case .noaa15: return "noaa15.png"
			case .missile: return "missile.png"
			case .rocket: return "rocket.png"
			case .rocketlaunch: return "rocket-launch.png"
			case .rocketshield: return "rocket-shield.png"
			case .spitzer: return "spitzer.png"
			case .sputnik: return "sputnik.png"
			case .tiros: return "tiros.png"
			case .vanguard: return "vanguard.png"
		}
	}
	
	public var size: Double {
		switch self {
			case .missile, .drone: return 300
			case .explorer, .sputnik, .tiros, .vanguard: return 400
			case .landsat, .noaa15: return 500
			case .rocket, .rocketlaunch, .rocketshield: return 800
			case .chandra, .compton, .hubble, .spitzer: return 800
			case .iss: return 1200
			case .debris: return 2000
		}
	}
	
	public var position: Double {
		switch self {
			case .chandra: return 0.5
			case .compton: return 0.1
			case .debris: return 0.5
			case .explorer: return 0.45
			case .hubble: return 0.85
			case .iss: return 0.4
			case .landsat: return 0.9
			case .noaa15: return 0.7
			case .spitzer: return 0.65
			case .sputnik: return 0.15
			case .tiros: return 0.8
			case .vanguard: return 0.25
			default: return 0.5
		}
	}
	
	public var altitude: Double {
		switch self {
			case .chandra: return 0.5
			case .compton: return 0.45
			case .debris: return 0.4
			case .explorer: return 0.4
			case .hubble: return 0.7
			case .iss: return 0.65
			case .landsat: return 0.45
			case .noaa15: return 0.4
			case .spitzer: return 0.75
			case .sputnik: return 0.3
			case .tiros: return 0.6
			case .vanguard: return 0.5
			default: return 0.0
		}
	}
	
	public var speed: Double { return 0.0 }
}
