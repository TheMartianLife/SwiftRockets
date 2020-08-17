//#-hidden-code
import PlaygroundSupport
import SpriteKit
import UIKit

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

let satellites: [OrbitalObject: Bool] = [.sputnik : false, .explorer : false, .vanguard : false, .tiros : false, .landsat: false, .hubble: true, .compton : false, .iss: true, .chandra: true, .noaa15: true, .spitzer: true]
func hasCollided<T: Trackable>(_ missile: T, at altitude: Double) -> OrbitalObject? {
	let obstructions = LiveView.obstructionsWithObjects(Array(satellites.keys), at: missile.position)
	let destructions = queuedDestructions.map { $0.target }
	let obstruction = obstructions.first(where: { !destructions.contains($0) })
	if let firstObstruction = obstruction, firstObstruction.altitude <= altitude {
		return firstObstruction
	}
	return nil
}
var queuedDestructions: [(projectile: Trackable, target: OrbitalObject)] = []
func destroy(_ object: OrbitalObject, with missile: Trackable) {
	queuedDestructions.append((missile, object))
	if (satellites[object] ?? false) == true {
		print("Hit functioning satellite! 💥😧")
	}
}
//#-end-hidden-code
/*:
# The Swarming Junkyard

So the turn of the millenium came and went, and down on Earth we continued to launch things into orbit as we had for more than 40 years at that point.

Even though a forward-thinking NASA scientist named Donald Kessler had written a paper way back in 1978 trying to show how this would become a problem. Kessler warned that if we kept launching thing--bigger and more things--eventually some would hit each other; those devices would then veer off course and hit more things, and those would veer off, and so on, until everything in orbit was smashed into a big cloud of debris that nothing could be launched through anymore. This hypothetical worst-case scenario was later called "Kessler Syndrome". NASA formed a program to support research into methods to prevent this in 1979, but for the most part the scientific community ignored poor Kessler and others like him for a long time.

Fast forward to 2002, when a U.S. government department in charge of commmunications agreed that the increasing amounts of inoperable devices in orbit posed a risk to the entire space industry, and put into law that any new devices put in orbit **must** have plans and the ability to be retired appropriately as a condition for launch. Other departments agreed and by 2007 some really concrete international guidelines had been written for launch and manufacture agencies to follow so that at least the *new things* being launched into orbit wouldn't hang around after they stopped functioning. Problem solved maybe?

Guess again.

By that point there were estimates of about 20,000 objects in orbit already, so the problem wasn't going to go away even if it stopped getting worse right then. Even worse, the European Space Agency conducted a study that found people still weren't doing the right thing. When companies and institutions who were operating these satellites were given the choice between a) moving a device into graveyard orbit when it neared the end of its battery life or b) using the same amount of power to keep the device operating in place for another 2-3 months even though it would remain in orbit once its battery died, they were still choosing the second one. Investigation showed about a third of devices were knowingly being left in orbit by their operators, and up to another third were given insufficient power to reach graveyard orbit so they'd just slowly drift back in.

Since 2000 there have been a handful of major incidents where live devices have been destroyed when they collided with debris hanging around in orbit, and many more that resulted in minor damage or very narrow misses. Then, in 2009, two whole communications satellites managed to hit each other and both be completely destroyed. This collision--between one Russian device that weighed almost one tonne and one privately-owned U.S. device that weighed more than half a tonne--happened despite our best tracking calculations thinking they would miss each other by half a kilometre. Soon thousands of broken glass, plastic and metal shards had scattered across the globe, orbiting at altitudes ranging hundreds of kilometres above and below where the collision occured.

Each time this happens, we worsen the problem. All of a sudden there are hundreds more tiny objects for our computers to track 24/7, and thousands more that are too small to detect at all but that could still pose enormous threat due to their orbital speed.

Fast forward to now. The year is 2020. And there is junk *everywhere* in orbit.

![A computer-generated image of objects in Earth orbit that were being tracked by NASA by 2005](junk.jpg)
*A computer-generated image of objects in Earth orbit that were being tracked by NASA by 2005*

Back to our little simulated rocketship. This time we aren't going to add to the `Rocket` type, because we already have all the behaviours we need from our rocket. However, because there are too many satellites to get past with just dodging or weak shields, we will make some other objects that can help us on our way.
*/
// more satellites!
let chandra = OrbitalObject.chandra.image
let noaa15 = OrbitalObject.noaa15.image
let spitzer = OrbitalObject.spitzer.image
/*:
How about a missile? Lots of tiny rockets could blow some of our dead satellites away so we can get through. But we'd better be *very* careful not to hit any of the live ones 😐

**NOTE:** we don't do this in real life. Except those couple times someone did, just to see if we could. Woops 😬 In actual launches, if too much stuff was in the way, the most likely outcome is that we wouldn't be able to launch at all. Instead, a whole mission would have to be scrubbed until it was clear again, like they do when there's bad weather. This costs hundreds of thousands, sometimes a million or more dollars to do, each time it happens.

So we need a type with some similar things to our `Rocket` type--altitude, position, etc. so we know where it is and where it goes--but we also need it to be able to clear things. This gives us a perfect opportunity to work with *optional* types in Swift. That's something we use when someone could have a value or it could have no value at all (not zero, not "None", **nothing**). This nothing value is called `nil` and you can assign it to things like any other value as long as the variable that holds it has been made optional. It's great for things that sometimes don't exist.
*/
struct Person {
	var givenName: String // you require a given name
	var familyName: String // you don't technically require a family name by law, but for the sake of this exercise let's assume you do
	var middleName: String? // you may have a middle name, or you may not
}
/*:
We can use this because to make a missile useful, we have to be able to use it to remove things. And to remove something it hit we have to know *what it hit* but also it may not have hit anything.

Just to shake things up, this time we're going to make this a class. This means we can compare some of the things that are different, such as it's easier to write functions that change something about the object.

One of the best things, though, is that you can *inherit* from a class. This means you can make a class that has some attributes or behaviours you want, and then make a new class that just gets all that stuff for free.

So if we're sick of writing code to initialise speeds and positions....
*/
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

// now we just change 'struct' to 'class'
// and we say the class we want to get all this stuff from
class Missile: Projectile {

	// now we don't have to say 'mutating' on functions that change things
	func fire() {
		self.speed = 1.0
		// we will use a provided function to check whether something is at
		// the missile's position and return its current collision
		// this collision can either be a satellite or it can be nil
		var collision = hasCollided(self, at: altitude)
		// while there's still fuel and it's still not hit anything, keep going
		while fuelLevel > 0.0 && collision == nil {
			self.fuelLevel -= 1.0 // means the same as "fuelLevel = fuelLevel - 1"
			self.altitude += 0.1 // these shorthand operators are super handy
			collision = hasCollided(self, at: altitude) // now check again
		}
		self.speed = 0.0
		// now let's check if we stopped because we hit something by
		// 'unwrapping' the optional value into a non-optional one
		// with a 'if let' check
		if let collidedObject = collision {
			// this means the value wasn't nil
			// so we can use a premade function to destroy the object we hit
			destroy(collidedObject, with: self)
		} else {
			// this means the value was nil so we missed
			print("Missile missed at \(position)! ❌")
		}
	}
}
//: Now let's make a whole bunch of them!
var arsenal: [Missile] = [
	Missile(position: 0.12),
	Missile(position: 0.15),
	Missile(position: 0.23),
	Missile(position: 0.48),
	Missile(position: 0.88),
	Missile(position: 0.85)
]
//: And now we can go through and fire each one!
for missile in arsenal {
	missile.fire()
}
//: And now the coast is (hopefully) clear, we can launch our rocket!
var rocket = Rocket(name: "My Rocket")
rocket.adjustPosition(.left, by: 0.4)
rocket.launch()
/*:
So if we consider that our missiles were a fake solution to a very real problem that is still going on today, it would be a pretty bummer of an ending if we stopped here. Instead, we shall look to the future...

[Previous](@previous) | Page 5/6 | [Next](@next)
*/
//#-hidden-code
extension Missile: Hashable {
    public func hash(into hasher: inout Hasher) { return hasher.combine(ObjectIdentifier(self))
	}
	
	public static func == (lhs: Missile, rhs: Missile) -> Bool {
		return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
	}
}
LiveView.add(.sputnik, alive: false)
LiveView.add(.explorer, alive: false)
LiveView.add(.vanguard, alive: false)
LiveView.add(.tiros, alive: false)
LiveView.add(.landsat, alive: false)
LiveView.add(.hubble)
LiveView.add(.compton, alive: false)
LiveView.add(.iss)
LiveView.add(.chandra)
LiveView.add(.noaa15)
LiveView.add(.spitzer)
for missile in arsenal {
	if let target = queuedDestructions.filter({ ($0.projectile as! Missile) == missile }).first?.target {
		missile.altitude = target.altitude
		LiveView.remove(target, by: .missile)
		LiveView.track(missile, type: .missile, to: target.altitude)
	} else {
		LiveView.track(missile, type: .missile)
	}
}
LiveView.queueActions {
	let theoreticallyDestroyed = queuedDestructions.map { $0.target }
	LiveView.track(rocket, type: .rocketlaunch, ignoring: theoreticallyDestroyed)
}
LiveView.display()
//#-end-hidden-code
