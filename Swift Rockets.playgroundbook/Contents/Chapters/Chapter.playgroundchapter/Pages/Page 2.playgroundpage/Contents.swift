//#-hidden-code
import PlaygroundSupport
import SpriteKit
import UIKit
//#-end-hidden-code
/*:
# Up, Up and Away!

So obviously if we expended effort to make a whole rocket we don't just want it to sit there; we want it to launch into space, that's what rockets are for 🚀

So let's have another go at making a `Rocket` type but this time with some behaviour. To give a type behaviours we give it **functions**. Before we can give some functions to our `Rocket` type, let's look at what functions are in general.

Functions are a way to save writing code. You can bundle up a series of steps you'll need to do more than once, give them a name, and use that instead. And they're great because if you can *genericise* them (a fancy word for making them general enough to be applicable for more than one use) then you can write even less.

For example, say we want to print's today's date. We could do this:
*/
let todaysDate = Date() // make a new date (today by default)
print(todaysDate)
//: Well that's not a very useful output. The information is there but it's not formatted nicely or anything. Maybe we should write a function to format it nicely?
// functions that don't need any new information and just do something only need a name
func printTodaysDate() {
	let todaysDate = Date()
	let dateFormatter = DateFormatter() // make a new formatter that will say how to print the date
	dateFormatter.dateFormat = "dd MMMM yyyy" // set the date format to print as <day number> <month name> <year>
	let todaysDateString = dateFormatter.string(from: todaysDate) // make a string from the date, in the desired format
	print(todaysDateString) // print the nicely formatted string
}

// you then call it (actually do the thing) with just the name you gave it
printTodaysDate()
//: That was a lot of things to do in one function. And it only works for one date! Maybe we should make one that would work for any date?
// functions that need information describe the information they need as "parameters" within the brackets
func printFormattedDate(date: Date) {
	// now we have access to a variable called "date" that will be of type "Date" but it could be for any day
	let dateFormatter = DateFormatter() // make a new formatter
	dateFormatter.dateFormat = "dd MMMM yyyy" // set the date format
	let dateString = dateFormatter.string(from: date) // make a string
	print(dateString) // print it
}

// call it with its name and giving it the parameters it wants (the date we made before)
// note the "date:" part in the brackets hs to stay
printFormattedDate(date: todaysDate)
//: Except what if we wanted to do anything else with the date? Like use it in a sentence? Maybe we should make it just give back the string it formatted so we can do whatever with it?
// functions that give some information back have a "return type" with an arrow
func getFormattedDate(for date: Date) -> String {
	// because the parameter has two names, the first ("for") is what we have to use when we call it
	// and the second ("date") is what the variable is called when we use it in the function
	// we do this so that when we call it it makes a nice readable sentence about what it's going to do
	// e.g. getFormattedDate(for: todaysDate) = "get formatted date for today's date"
	let dateFormatter = DateFormatter() // make a new formatter
	dateFormatter.dateFormat = "dd MMMM yyyy" // set the date format
	return dateFormatter.string(from: date) // "return"/send back the result
}

// call it with its name and parameters, but then give it a variable to store the result in
let formattedTodaysDate = getFormattedDate(for: todaysDate)
print("Today's date is \(formattedTodaysDate).")
/*:
Okay, now we've shown some simple examples for the different ways functions can work, let's make a new `Rocket` type with what we've learned.

To make our rocket launch we need to tell it to move upward. But first, to move at all, it has to know where it is. And to do something continually, we need a way to *keep doing something* while some condition is met. For example: "while we still have fuel, keep launching upwards".
*/
struct Rocket {
	let name: String
	var fuelLevel: Double
	var altitude: Double
	var position: Double
	var speed: Double
	
	// because a rocket always starts on the ground we can make it so that that's the only
	// height a rocket can ever start at when it's made
	// to do this we override the default initialisation function we used before so that
	// some attributes always start with the same values
	init(name: String) {
		self.name = name
		// fuel always starts full
		self.fuelLevel = 100.0
		// rocket always starts on the ground,
		self.altitude = 0.0
		// in the middle,
		self.position = 0.5
		// standing still
		self.speed = 0.0
	}
	
	// to do something that changes something about the rocket
	// (like change its altitude or fuel level)
	// we have to use the 'mutating' keyword
	mutating func launch() {
		// we are moving now
		self.speed = 1.0
		// to keep doing something we can use a 'while' keyword
		// SO while we still have fuel
		while fuelLevel > 0.0 {
			// keep moving upwards
			self.altitude = self.altitude + 0.1
			// but expend fuel while you do
			self.fuelLevel = self.fuelLevel - 1.0
		}
		// if we get here we have no fuel left
		// so we aren't moving any more
		self.speed = 0.0
	}
}
/*:
This `while` statement is our first use of the second piece of the puzzle: **logic**. Logic is the way we can respond dynamically depending on different circumstances, and this will be what we focus on for the rest of our activities.

Back to our new fandangled `Rocket` type, initialisation will now look like this:
*/
// this time, because things about it will change we have to use the 'var' keyword
var rocket = Rocket(name: "My Rocket")
//: This looks much simpler but ends up providing more information than we had before, by way of those default values. And now 🎉 we can use our new launch capabilities! 🎉
rocket.launch()
/*:
Look at it go! 🚀

So now we know everything there is to know about how to store information.

Data sorted ✓
Launched rocket ✓
Hard bits covered ✓

But that's not the whole story, for programming nor for space exploration...

[Previous](@previous) | Page 2/6 | [Next](@next)
*/
//#-hidden-code
extension Rocket: Trackable {}
LiveView.track(rocket, type: .rocketlaunch)
LiveView.display()
//#-end-hidden-code
