//#-hidden-code
import PlaygroundSupport
import SpriteKit
import UIKit

class Projectile: Trackable {
	var fuelLevel: Double = 100.0
	var altitude: Double = 0.0
	var position: Double
	var speed: Double = 0.0

	// structs get default initialisers, but for classes you have to write one no matter what
	init(position: Double = 0.5) {
		self.position = position
	}
}

let satellites: [OrbitalObject: Bool] = [.debris: false, .sputnik : false, .explorer : false, .vanguard : false, .tiros : false, .landsat: false, .hubble: true, .compton : false, .iss: true, .chandra: true, .noaa15: false, .spitzer: true]

var queuedRemovals: [OrbitalObject] = []
func remove(_ object: OrbitalObject) {
	queuedRemovals.append(object)
}

func nextObjectAbove(_ drone: Trackable) -> OrbitalObject? {
	let obstructions = LiveView.obstructionsWithObjects(Array(satellites.keys), at: drone.position).filter({ !queuedRemovals.contains($0) })
	if let firstObstruction = obstructions.first {
		if firstObstruction == .debris {
			let otherOptions = obstructions.filter({ isDead($0)})
			if let secondOption = otherOptions.first {
				return secondOption
			}
		}
		return firstObstruction
	}
	return nil
}

func isDead(_ object: OrbitalObject) -> Bool {
	return !(satellites[object] ?? true)
}

enum Direction {
	case left, right
}

struct Rocket: Trackable {
	let name: String
	var fuelLevel: Double
	var altitude: Double
	var position: Double
	var speed: Double
	
	init(name: String) {
		self.name = name
		self.fuelLevel = 100.0
		self.altitude = 0.0
		self.position = 0.5
		self.speed = 0.0
	}

	mutating func launch() {
		self.speed = 1.0
		while fuelLevel > 0.0 {
			self.altitude = self.altitude + 0.1
			self.fuelLevel = self.fuelLevel - 1.0
		}
		self.speed = 0.0
	}
	
	mutating func adjustPosition(_ direction: Direction, by amount: Double) {
		if direction == .left {
			self.position = max(self.position - amount, 0.0)
		} else {
			self.position = min(self.position + amount, 1.0)
		}
	}
}
//#-end-hidden-code
/*:
# The Look Ahead

Nobody knows what the future will hold, but there are many ongoing efforts researching how to deal with our space junk problem. People designing small drone-like solutions to grab, move or repair devices; small rockets to attach to and push away devices; new satellites that spread out with nets between them to catch debris like fish in orbit; all sorts of wacky ideas. It's what scientists are best at, and it's where our greatest innovative solutions come from, but it's not solved yet.

So we'll try one more time with our poor little `Rocket` that can never catch a break, and leave you to think for yourself about what whacky solution could solve our space garbage problem in the future 🛰👉🗑👍

![Rendering of DARPA's Phoenix "harvesting and repurposing" concept device](phoenix.jpg)
*Rendering of DARPA's Phoenix "harvesting and repurposing" concept device*

You may notice now that many of the satellites launched in recent decades are dead and there is a large cloud of debris hanging amongst them. It's just abig mess up there. Shooting individual pieces out of the way without harming critical infrastructure would be a virtually impossible task, and a new solution is required.
*/
let debrisCloud = OrbitalObject.debris.image
/*:
This time we are going to implement this aspirational technology scientists are working on now: something that can identify non-functioning devices and move them safely out of orbit without harming or compromising the operation of devices nearby.

Don't worry, we'll make this one easy for you.
*/
class CleanupDrone:  Projectile {
	// it can grab a satellite but it doesn't start with one
	var satellite: OrbitalObject? = nil
	// then it gets the stuff our rockets and missiles had
	// from the Projectile class for free
	
	func deploy() {
		// if there is an object somewhere above the drone that it can target
		if let targetedObject = nextObjectAbove(self) {
			// and that target is dead
			if isDead(targetedObject) {
				self.grabSatellite(targetedObject)
			}
		}
	}
	
	func grabSatellite(_ satellite: OrbitalObject) {
		self.altitude = satellite.altitude
		self.satellite = satellite
		print("Grabbed \(satellite) 🦾")
		remove(satellite)
	}
}
//: Now to make sure we get everything, we can assemble a small army of drones. A really easy way to do that is to first assemble a list of all the starting positions we want:
let positions = Array(stride(from: 0.05, through: 0.96, by: 0.08)) // this will give us 10 starting positions from left to right
//: And then we can use one of the most powerful parts of the Swift language: a **closure**. More specifically, this is referred to as a "higher order function" as it is a function that takes a function as a parameter. Confusing, I know, but i's handy when there's a particular set of steps you want to do but occasionally want to change some in the middle. For example, here we want to take the list of positions and initialise a `CleanupDrone` for each one. We can do that by *mapping* the positions to drones that contain them by giving a function to the `map()` function like this:
// we make a dummy function that takes a position and gives a drone
func constructDrone(with position: Double) -> CleanupDrone {
	return CleanupDrone(position: position)
}
// then we use the map function to take a list of positions, call the function on each one
// and store the results as a list of drones
let droneArmy = positions.map { position in constructDrone(with: position) }
//: And now we can deploy our 🎉✨DRONE ARMY🤖💪
for drone in droneArmy {
	drone.deploy()
}
/*:
... that was way easier than missiles, I think 😆

And we can make our rocket, who has a clearer path than ever before 🚀
*/
var rocket = Rocket(name: "My Rocket")
rocket.adjustPosition(.left, by: 0.4)
rocket.launch()
/*:
So you made it this far and I hope you had fun learning about Swift programming and space junk at once.

If you enjoyed this kind of go-at-your-own and self-directed mode of learning (I know I do!), make sure you check out some of the other activities on offer for you to do at home this science week at [scienceweek.net.au/diy-science](https://www.scienceweek.net.au/diy-science/)

Bye for now 👋

## About the Author

Swift and Space Junk might seem a weird combination to pick for a Science Week activity, but it's not as unusual as you may think. In fact, it's what I do.

I'm Mars (yes, really) and I am a PhD Candidate at the University of Tasmania, studying how we can use technologies like we use in self-driving cars to detect and manoeuvre around pedestrians to better detect and track junk in space. My primary tool is Machine Learning/Artificial Intelligence technologies and one of the few ways we can make such things is with... (you guessed it) Swift! I use Swift all the time for everything from prototyping to making apps, and I love it so much I wrote a book about it (and am now writing a second one) 📚👍

So if you have any more questions to ask, want more ideas for things to do with Swift, or just want to chat about junk in space, then get in touch!
 
--Mars Buttfield-Addison 👩‍💻
[Twitter](https://twitter.com/TheMartianLife) | [Email](mailto:hello@mail.themartianlife.com) | [LinkedIn](https://www.linkedin.com/in/themartianlife/)

[Previous](@previous) | Page 6/6
*/
//#-hidden-code
for (satellite, status) in satellites {
	LiveView.add(satellite, alive: status)
	
	if queuedRemovals.contains(satellite) {
		LiveView.remove(satellite, by: .drone)
	}
}
for drone in droneArmy {
	drone.altitude = 1.1
	LiveView.track(drone, type: .drone)
}
LiveView.queueActions {
	LiveView.track(rocket, type: .rocketlaunch, ignoring: queuedRemovals)
}
LiveView.display()
//#-end-hidden-code
