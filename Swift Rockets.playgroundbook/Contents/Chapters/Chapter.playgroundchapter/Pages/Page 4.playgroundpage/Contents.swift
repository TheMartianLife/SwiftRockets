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
	let obstructions = LiveView.obstructionsWithObjects(Array(satellites.keys), at: missile.position).filter { !dodged.contains($0)}
	let obstruction = obstructions.first
	if let firstObstruction = obstruction, firstObstruction.altitude <= altitude {
		return firstObstruction
	}
	return nil
}
var dodged: [OrbitalObject] = []
func deflect(_ object: OrbitalObject) {
	dodged.append(object)
}
var crashed: Bool = false
func crash(_ rocket: Rocket) {
	crashed = true
}
//#-end-hidden-code
/*:
# The Race to Space

By the early 1960s, humans had gone **nuts** for space.

We launched things to do all sorts of things. Some were big satellite reflectors, to make it easier to get radio and television signals around the world; some were devices covered with cameras, to take our first pictures of Earth from a distance that we had never seen before; and for the first time, we sent capsules with **people in them** up into orbit and back down again. Across the globe, people were bonkers about the opportunities that could be found by sending things and people into space. This period of time in the 1950s-1970s where countries were head-to-head in their advances towards finally performing crewed space missions beyond Earth's orbit (with the ultimate goal of landing a human somewhere else) was called "*The Space Race*".

The part of the race that everyone remembers is the Apollo 11 Mission, where in July of 1969 a crew of three U.S. astronauts successfully undertook the multi-day trip to land on Earth's moon and two of them came out and walked around on it. That was a historical day for all of humankind, for sure. But back on Earth, by that time more than 100 satellites were being launched each year into orbit for various purposes. They had limited battery life or fuel, but most either came down and burned up, or drifted outward into space (called "graveyard orbit") once they ran out of power to keep themselves adjusted in orbit. Some, though, just *stayed there*; orbiting around, a dead gadget in space who couldn't be recharged or refueled.

In the decades leading up to the new millenium (the year 2000), more and more countries--and very quickly, also private companies--produced and launched satellites. Dozens of countries could build them, ten countries could launch them, everyone wanted in on the fun (and profit) of the growing space industry. This got especially cool with some of the more large and ambitious space devices such as [space telescopes](https://en.wikipedia.org/wiki/Space_telescope) (telescopes put in outer space so they can see stuff without worrying about trying to see through Earth's atmosphere) and [space stations](https://en.wikipedia.org/wiki/Space_station) (satellites that contain habitats that humans can enter and exist in for some period of time). Still the record-holder for the largest and heaviest device in orbit is the [International Space Station](https://en.wikipedia.org/wiki/International_Space_Station) that was launched by collaboration between five leading space agencies in 1998.

It has now been continuously occupied by human astronauts and scientists on a rotating roster for nearly 20 years up there, hundres of kilometres above our head, and orbiting at tens of thousands of kilometres an hour. It's about the size of a football field and, if it were on the ground, it would weigh as much as around 400 cars.

![International Space Station](iss.jpg)
*The International Space Station*

But as you can imagine, this meant more and bigger things to dodge...
*/
// so here we have some more satellites for the mix
let compton = OrbitalObject.compton.image
let hubble = OrbitalObject.hubble.image
let iss = OrbitalObject.iss.image
let landsat = OrbitalObject.landsat.image
let tiros = OrbitalObject.tiros.image
/*:
Given these additional obstacles, it is virtually impossible to avoid all of the satellites at once.

So we're going to do something a bit cheaty that they very much did not have in real life at this time: we're going to give our Rocket a shield.
*/
struct Shield {
	// this set of keywords mean it's still a 'var' that you can change,
	// but once you've made a shield you can't directly set its health
	// anymore. That would be _real_ cheating, of course 😆
	private(set) var health = 3
	var isDepleted: Bool {
		return health < 1
	}
	
	mutating func takeHit() {
		self.health -= 1
	}
}
/*:
This is a great time to bring up a slightly difficult concept in Swift: `inout`	parameters. So it was already mentioned that if you have to mutate (change) the object whose function it is, you
write `mutating`, but if you have to mutate (change) one of the
parameters you will now instead mark it as 'inout'.

This is for a complicated reason that relates to the fact that in programming everything happens very fast, and sometimes your computer tries to do multiple things at once.

If you can have two jobs where you start the first one, then start the second one, but finish the second one first, we can have a problem where all the steps we carefully wrote out for the computer to do will get muddled and not work. Like if you said:
*/
var a = 5.0
var b = a
a = 15
print(b)
//: versus
var c = 5.0
c = 15
var d = c
print(d)
/*:
Right? The order matters. Even with simple instructions, because the values they are working with can change.

So back to our `inout`s: this means that the parameter is passed *into* this function, it does its thing and it spits it back *out* again, and that because the function is going to change something about it, nothing else should use that
same object in between because it's attributes can't be trusted to
not be just about to change. So instead, it gets locked in that function like a lockbox until that function is done with it.
*/
extension Rocket {
	mutating func launch(with shield: inout Shield) {
		self.speed = 1.0
		while fuelLevel > 0.0 {
			self.altitude += 0.1
			self.fuelLevel -= 1.0
			// check if we have it something, using a function that
			// has been made for you
			if let collision = hasCollided(self, at: altitude) {
				// if we hit something and we still have shield, we're okay
				if !shield.isDepleted {
					print("Deflecting \(collision) near miss")
					deflect(collision)
					shield.takeHit()
				} else {
					// otherwise, we're out of luck 😕
					crash(self)
				}
			}
		}
		self.speed = 0.0
	}
}
//: So now we're suited up and we can go a-launching again!
var rocket = Rocket(name: "My Rocket")
rocket.adjustPosition(.right, by: 0.15)
var shield = Shield()
// because our shield is an inout, we pass a reference to the shield instead
// of the shiel itself (which is easy, becaue you jusy put a '&' at the front)
rocket.launch(with: &shield)
/*:
Huzzah!

If only this worked! Except that back then when these satellites were actually being launched our rocket tech was nowhere near this advanced 😕 In actual fact, we were only just in the Space Shuttle era and manoeuvrability was poor enough. Let alone some kind of futuristic shields? No chance 🙅‍♀️

And yet, the problem got worse...

[Previous](@previous) | Page 4/6 | [Next](@next)
*/
//#-hidden-code
LiveView.add(.sputnik, alive: false)
LiveView.add(.explorer, alive: false)
LiveView.add(.vanguard, alive: false)
LiveView.add(.tiros)
LiveView.add(.landsat)
LiveView.add(.hubble)
LiveView.add(.compton)
LiveView.add(.iss)
LiveView.track(rocket, type: .rocketshield, ignoring: dodged, shield: true)
LiveView.display()
//#-end-hidden-code
