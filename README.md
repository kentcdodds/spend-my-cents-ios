#Spend My Cents iOS

This is a school project for IS 543 Mobile Platform Development taught by Dr. Stephen Liddle.

#Proposal:

Here is my initial proposal with an indication of what was not completed.

##Clear description of what the app will do:

The app will do pretty much everything that the website does: You can search for amazon products by price and category. You will have a search bar, and some kind of selection mechanism to choose the category.

##Clear list of iOS features you will use:

 - ✓ UITextField for search bar.
 - ✓ UITableView for category picker. <-- Used UIPickerView
 - ✓ UICollectionView to show results (similar to our Rook game)
 - ✓ A modal to show result details when the result is touched.
 - ✓ Animation to animate the result flipping around and turning into a modal (if this is possible). <-- Animated from bottom not a flip
 - ✗ Possibly a tab bar... Not certain on this one, but I want to have something that will allow them to go to settings/submit feedback/etc...

##Tell me clearly what new feature you'll use:

 - ✓ I'll use the social media and activity view features to allow users to share what they find.
 - ✓ I'll use an activity indicator while things load
 - ✓ I'll use the network activity indicator in the status bar while requests are being made to the server.

##Indicate the platform (phone vs. tablet vs. universal):

 - ✓/✗ I expect to do this on both platforms. If I decide to drop one, I will drop the iPad. <-- I did in fact drop the iPad

#Extra features completed

I used a library called TSMessages (https://github.com/toursprung/TSMessages) to display activity indicators to provide feedback to the user when the app is doing something or when there is an error.

#Project Requirements

 1. ✓ Scope of the project should be about two homeworks.
 2. ✓ I'm primarily interested in iOS code, not server-side stuff you might want to write.  So focus your time and energy on writing your app, not network-based services to support your app. If you need server-side support, use something like Parse, StackMob, or a similar service that will generate the API from high-level models you provide.
 3. ✓ I will grade you on proper use of the iOS SDK.  Don't hack your code together; use good object-oriented design.
 4. ✓ You must use at least one feature that I didn't cover in class in with a homework assignment.
 5. ✓ Aesthetics matter -- do a good, clean UI.  You can use graphics from the web since this is a class assignment.  Make it look good.  I know you're not graphics designers.
 6. ✓ Send me a proposal...

#Personal Grade

 1. 100% - Definitely more than two homeworks worth of effort went into this project.
 2. 90% - Although this project depends heavily on server-side stuff, most of the work on the server was done prior to this project. Most of the work done was in iOS.
 3. 95% - I feel like I use many of the design practices encouraged for iOS developers including the delegate method.
 4. 100% - I used multiple features not discussed in class. One was the use of `UIActivityViewController` for sharing products.
 5. 80% - I think it looks pretty good, but it definitely could use a designer's eye. I don't have a designer's eye.
 6. 100% - I sent you the proposal early on.