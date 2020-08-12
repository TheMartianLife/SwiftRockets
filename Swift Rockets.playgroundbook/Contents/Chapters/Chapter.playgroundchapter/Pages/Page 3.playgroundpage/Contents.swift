//#-hidden-code
import PlaygroundSupport
import SpriteKit
import UIKit

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
}
//#-end-hidden-code
/*:
 # The Trouble with Launching
 
 Aside from the difficulty of building a vehicle that can withstand space and the sheer force required to get it up there, there are a few more challenges to consider when it comes to spaceflight. Among them is that anything we launch is not alone in space. That doesn't mean "watch out for moons" or that there are a few comets moving around out there. In fact, these vehicles are not even alone as far as **human-built** things in space.
 
 That's because before we started putting people in space, we put devices: uncrewed little computer boxes covered in sensors to tell us what to expect up there before we'd ever been. This includes [space probes](https://en.wikipedia.org/wiki/Space_probe) like the Luna probes we sent to the moon to photograph it and scope it out before we sent people, or the various probes that have been sent to or near other planets in our Solar System that humans have yet to reach, or even the "deep space" probes we just launch in a random direction to see how far they go--sending back images and measurements of what they see and feel, for as long as they have the battery or fuel power for, as they fly past the outer planets and leave our system forever.
 
 But before all that, we sent devices to scout out a little closer to home: Earth's own orbit. Higher than an airplane, this was still farther away than any human had been at the time, and we really had very little idea of what to expect up there. Telescopes and radio recievers and guessing wouldn't cut it when we planned to send people up there soon, instead we needed [satellites](https://en.wikipedia.org/wiki/Satellite) 🛰
 
 ## The First Satellites
 
 When the Soviet Union (a kind of meta-country that no longer exists, having now been broken up into Russia and a bunch of smaller countries) launched the first successful human-made satellite into low earth orbit in 1957, it only stayed up there for two months. It was a shiny little sphere named [Sputnik](https://en.wikipedia.org/wiki/Sputnik_1) and even though its battery only lasted for three weeks of that--and it burned up before it ever made it back down to Earth--it was the start of something great.
 
  ![Sputnik I satellite](Sputnik-516.jpg)
 *A picture of the Sputnik I satellite*.
 
 Soon after, the United States of America caught up and launched their own satellite for the first time: the Explorer. The Soviet Union and the U.S.A. had failed for a few years and crashed lots of expensive prototypes by that point, so they were both pretty excited about this new ability and so it was not long before each launched more. Spheres and cubes and missile-looking devices, all sorts.
 
 **But back to the trouble with launching:** this means there are things we have to dodge when planning our ascent up through Earth's atmosphere. And worse than that, sometimes devices aren't big enough or moving predictably enough or transmitting enough that we can properly see or track them from the ground. So it can be like dodging while wearing a blindfold... 😬
 */
// so here we have an OrbitalObject type that was prepared earlier, and this includes some early satellites like those spoken about above
// open the viewer to see what each looks like ->
let sputnik = OrbitalObject.sputnik.image
let explorer = OrbitalObject.explorer.image
let vanguard = OrbitalObject.vanguard.image
/*:
 Note that the declaration for the `OrbitalObject` type and the code that launches these satellites has been hidden from you. So there's nothing you can do about these satellites to move them out of your way. Sorry.*
 
 *\*Not sorry.*

So I guess we'll have to give our `Rocket` type some new abilities.

**NOTE:** because we have a `Rocket` type definition, instead of making a new one from scratch we can add new bits in an *extension* to the type. Each extension just increases the abilities of the original type.

We are going to give our rocket the ability to change its position on the ground, so it can launch from a spot where its path will be clear of satellites. We will do this by giving it an option to move left or right. The 0 position is as left as is allowed and the 1 position is as right as is allowed, with decimals in between (that's why 0.5 has been the middle where we started before).

For this we'll use a tiny type called an `enum`, that is just a type that holds a set number of options you can chose from.
*/
enum Direction {
	case left, right
}
/*:
Now for our repositioning code we will need a new kind of logic statement unlike the `while` we have used to repeat an action. Instead, we need to do something *depending on* the value of something. We can do this with the `if` keyword, that only runs if its condition is true. If we want to do something else if it isn't true, we can add an `else` bit as well. That can look something like this:
*/
extension Rocket {
	mutating func adjustPosition(_ direction: Direction, by amount: Double) {
		if direction == .left {
			// move left
			var newPosition = self.position - amount
			// check we won't go off the side if we move there
			if newPosition < 0.0 {
				newPosition = 0.0
			}
			self.position = newPosition
		} else {
			// move right
			var newPosition = self.position + amount
			// check we won't go off the side if we move there
			if newPosition > 1.0 {
				newPosition = 1.0
			}
			self.position = newPosition
		}
	}
}
//: Now our `Rocket` should be able to position itself so that it doesn't collide with satellites on its way into space! (Make sure you give those satellites a wide margin, as they might be important)
var rocket = Rocket(name: "My Rocket")
rocket.adjustPosition(.right, by: 0.1)
rocket.launch()
/*:
 So we've learned about logic and how we can make decisions, and managed to dodge some pesky satellites. If you've made it this far you've **kicked butt** at being a rocket launching genius even with pesky satellites in your way.

But the bad news is, it didn't stop there...

[Previous](@previous) | Page 3/6 | [Next](@next)
 */
//#-hidden-code
LiveView.add(.sputnik)
LiveView.add(.explorer)
LiveView.add(.vanguard)
LiveView.track(rocket, type: .rocketlaunch)
LiveView.display()
//#-end-hidden-code
