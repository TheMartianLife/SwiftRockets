//#-hidden-code
import PlaygroundSupport
import SpriteKit
import UIKit
//#-end-hidden-code
/*:
 # Swift Rockets 🚀

Welcome to Swift Rockets and I hope you're having a fantastic National Science Week 2020 so far! Today we're going to go on a tour of how to create fantastic things with simple concepts from the Swift Programming Language. Playgrounds is a great platform for combining learning and play, and this activity will walk you through a story of Earth, humans and our dealings in space as the setting for experimentation with programming concepts as you learn.

This activity was crafted for beginner to intermediate programmers who have tried other languages before, but only assumes some passing familiarity with basic programming concepts such as values and functions. And if you have any trouble or you want to know more, you can reach out to me (the author) via [Email](mailto:hello@mail.themartianlife.com) or [Twitter](https://twitter.com/TheMartianLife).

Happy coding!

![Playground thumbnail](preview.png)

Let's jump right in. The first thing every programmer should do is write a piece of code that says "Hello World". This is a long-standing tradition from back when computers where huge and slow and that was a hard thing to do, but in Swift it's easy!
*/
print("Hello World")
// see what it does by looking at the results over there ->
//: `print` is really handy because you can tell it what to say or you can tell it how to *work out* what to say or you can mix these things together.
print("2 + 2") // quotation marks mean it will print exactly what's in the brackets
print(2 + 2) // by putting some code in the brackets it will work out the answer and then print that
print("2 + 2 = \(2 + 2)") // or you can give it some quoted text with "" that will print exactly and some bracketed text with \() that will print the result
// and you can these 'comment' bits we're using, which is text in the file that is ignored when the code runs
// by putting these two slashes at the start, Playgrounds will ignore these bits and we can use them to explain things
/*:
Now, to write a program we will need two things: **data** and **logic**. **Data** is the information we use to make decisions or derive new information, the values we store or send around. **Logic** dictates what is done with that information, what and how decisions are made and what results come from those decisions. First, let's start with the data.

Data is stored by giving a value a name it's assigned to. Like a label on a bucket, where you can change what's in the bucket but you can never change the label. This is called a **variable** and you declare one using the `var` keyword.
*/
var variable = "some value"
//: And with this variable name we can check what its value is, change its value by assigning a new one, or copy its value to other things.
print("The value of the variable is: \(variable)") // this will show what the value is
variable = "new value" // this will change the value
var secondVariable = variable // this will copy its value to a new variable
/*:
So it's like a nickname for a piece of information.

But sometimes what we do with a piece of information depends what it is. So each variable has a **data type** where different types can do different things.
*/
var number: Int = 1 // whole numbers are "Int", which means Integer
var words: String = "words and such" // sequences of characters or mixed values are "String"
var decimal: Double = 2.5 // non-whole numbers are "Double", which is short for a long silly name that means decimal number
var flag: Bool = true // true or false values are "Boolean", which is a type that can only be one of those two things
//: You may have noticed in our first examples we didn't say what type each thing was. That's because Swift can *guess* based on the value you give something at first.
var testVariable1 = 1 // this is an Int
var testVariable2 = 1.0 // this is a Double
//: But once a variable has a type, whether you gave it or Swift guessed, this can't change. And its type will change things about how it behaves, whether you're manipulating it using traditional mathematical oprations (+ for addition, - for subtraction, * for multiplication, / for division, etc.), moving the value around with assignments, or doing something more complex.
print(2 + 2) // two lone numbers will be treated as integers, and add up to a new whole number (4)
print(2.0 + 2.0) // two decimal numbers will be treated as doubles, and add up to a new decimal number (4.0)
print(2.0 + 2) // mixing the two will make them both doubles, and will still add up to a decimal (4.0)
print("2" + "2") // putting quotes around numbers means they will be treated as strings, append them together and produce a nonsensical answer (22)
//: Likewise, the variable itself has a type which changes how it behaves. But it's more simple: it can either be changeable (called *mutable*) or *immutable*. Up until now we have been declaring mutable variables with our `var` keyword. But if you want a value that can't change, we can use `let`. Trying to change an immutable variable will result in an error and your program wil crash.
var thisYear = 2020 // next year we can change this like below
// thisYear = 2021
let moonLandingYear = 1969 // this will never change, because it's already happened
// moonLandingYear = 1970 // this would cause a big red error (go ahead, remove the slashes and give it a go!)
/*:
So you can see why we'll have to be careful about making things the right types that make sense for what they represent.

But of course we often don't want just one thing or one value. And so the concept of data *structures* comes in, giving different ways to group related information together. This is handy for reducing the amound of variables you have to remember to keep around or to send to different places. There are a few options that each make sense for representing different information. Let's start with collections.

A collection type is a series or list of values of the same type, where the list can either be empty or have one or more of that type of value in it. You can add and remove values from the list and you can access individual elements within the list by referrring to their numbered place. But just to be confusing, the first place is number 0.
*/
var listOfNumbers = [100, 36000, 8, 734, 59] // this is inferred to be a list of integers, so you can only ever add integers to it
listOfNumbers.append(34) // appends a new number to the end of the list
print("List of numbers is \(listOfNumbers) and has \(listOfNumbers.count) elements.")
print("The first element in the list of numbers is \(listOfNumbers[0]), the second is \(listOfNumbers[1])")
var thirdNumber = listOfNumbers[2]
//: But for things where you know how many you're going to have, it's easier to use a tuple. That's because tuples let you give each value a name.
var gridPosition = (row: 1, column: 2) // can only ever have two values, one named "row" and one named "column"
print("Position on grid is \(gridPosition) where row is \(gridPosition.row) and column is \(gridPosition.column)")
/*:
For things with lots of values, where values are different types but are all related, we can make these kind of meta-types that hold multiple variables together. These are often what we use when representing a real-world object's various attributes. These come in two types: a **structure** and a **class**.

In practice, most of the time you won't notice the difference between these things but the easiest way to describe them is like the different between a book and a website. If there is a book it is a physical thing. There can be multiple copies but each is a separate object. If you destroy one, the others still exist. If you change one, the others remain the same. You can give someone a book but that means you lose it, you can't both have the *same object* at once. You can only have copies and they wil vary based on when they were made and who they were given to and what has happened to them since.

With a website there is only one. Many people may be reading it at once but it's not *theirs* and if it gets changed it's changed for everyone. People can access it, read it, enter information or propose changes but it is still a shared central thing. Likewise you can download a copy of it but once you do it ceases to be representative; it is no longer a website, simple a snapshot of information from within it at the time you downloaded it.

So when you want to represent an object, use a struct. If you want to represent a non-physical shared resource, use a class. If you have no idea, use a struct and if that breaks then later you can change it 😂

Which is easy to do, because basically the only thing that changes is whether you use the `struct` or `class` keyword when you declare it.
*/
struct Rocket {
	let name: String
	var fuelLevel: Double
	var altitude: Double
	var position: Double
	var speed: Double
}
/*:
You may think this looks a little strange as it describes what attributes some hypothetical rocket has and what data type each attribute is but holds no actual values. That's because this definition is not a Rocket object in itself, but is instead used as a *blueprint* to make Rocket objects *from*. To make an actual Rocket object we can use, we have to make an "instance" (the name given to each individual object made from a blueprint).

Instantiation (the creation of an instance) is done using an "initialiser", which is a fancy way for saying "a function that takes the attribute values you want your instance to have and then makes it". They look like this:
*/
let rocketInstance = Rocket(name: "My Rocket", fuelLevel: 100.0, altitude: 0.0, position: 0.5, speed: 0.0)
/*:
Now if you run this page you will see you can make a rocket. How exciting! 😯 ...except that it doesn't do anything. It just sits there ☹️

That's because `Rocket` struct type we made holds some values that dictate its composition and abilities, but it doesn't *have* any abilities yet. We haven't given it any; it's all information and no behaviour. So how do we give things behaviour...?

Page 1/6 | [Next](@next)
*/
//#-hidden-code
extension Rocket: Trackable {}
LiveView.track(rocketInstance, type: .rocket)
LiveView.display()
//#-end-hidden-code
