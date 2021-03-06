# Swift-FlexibleHeightBar
Expandable implementation of a navigation bar-like view that expands and contracts similar to the Facebook and SquareCash iOS apps. This is a Swift translation from [Brian Keller's BLKFlexibleHeightBar](https://github.com/bryankeller/BLKFlexibleHeightBar/tree/master/BLKFlexibleHeightBar%20Demo).

## Create condensing header bars like those seen in the Facebook, Square Cash, and Safari iOS apps.

![Facebook Style Bar](media/FacebookFlexibleHeightBarDemo.gif?raw=true "Facebook Style Bar")
![Square Cash Style Bar](media/SquareCashFlexibleHeightBarDemo.gif?raw=true "Square Cash Style Bar")

`FlexibleHeightBar` allows you to create header bars with flexible heights. Often, this sort of UI paradigm is used to hide "chrome" and make room for more content as a user is scrolling. This is seen in third party apps like Facebook and Square Cash, as well as first party apps like Safari.

`FlexibleHeightBar` can create bars that look and act any way you'd like:

* Immediate subviews of a flexible height bar define how they want to look and where they want to be depending on the height of the bar. Properties like frame, transform, and alpha can all vary depending on the current height of the bar.
* A bar's behavior can be defined using a behavior definer instance. A behavior definer can be created to emulate Safari's header behavior, Facebook's header behavior, or something entirely new. Behaviors are completely modular and aren't coupled with the appearence of the bar.

Due to this library's modular, extensible nature, you are not limited to any one look or any one feel. *What UICollectionView does for presenting collections of data, `FlexibleHeightBar` does for creating header bars.*

## Installation

### [Carthage]

[Carthage]: https://github.com/Carthage/Carthage

Add the following to your Cartfile

```ruby
github "vicentesuarez/Swift-FlexibleHeightBar"
```

Then run `carthage update`.

Follow the instructions at [Carthage's README](https://github.com/Carthage/Carthage/blob/master/README.md)
for up to date installation instructions.

### Manual

1. Clone this repo or click "Download ZIP" on the side.
2. Copy all of the Swift files in the "FlexibleHeightBar/FlexibleHeightBar" folder into your project. You probably want to check the box that says "Copy items if needed" as well as make sure that the target you want to add the files to is checked.

## Usage

###Before we get started, understand this:
The height of the bar is not set directy by adjusting the bar's frame. Rather, height adjustments are made by setting the `progress` property of the bar. The progress property represents how much the bar has shrunk from its maximum height to its minimum height

* `progress == 0.0` means the bar is at its maximum height.
* `progress == 0.5` means the bar is halfway between its maximum height and minimum height.
* `progress == 1.0` means the bar is at its minimum height.


### Basic Setup
A good starting place is to have a project with some kind of scrolling view (i.e. UITableView, UICollectionView, UIWebView, UIScrollView, etc). Make sure you've set up a property to access your scrolling view since we'll need to set its delegate property later on.

NOTE: Because `UITableViewController`'s `view` property is the same as its `tableView` property, adding a `FlexibleHeightBar` instance as a subview of a `UITableViewController`'s `view` results in the bar being a subview of the `tableView`. I personally recommend just using a plain old `UIViewController` so you can fully control its view's subviews. Alternatively, see [this stackoverflow post](http://stackoverflow.com/questions/4641879/how-to-add-a-uiview-above-the-current-uitableviewcontroller).

First, create an instance of `FlexibleHeightBar` and configure it. When we `initWithFrame()`, the bar's `maximumBarHeight` property is autmatically set to the frame's height. We can manually set the `minimumBarHeight` from its default value of 20.0. Lastly, we can give it a color and add our bar to the view hierarchy.

```swift
let myBar = FlexibleHeightBar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 100.0))
myBar.minimumBarHeight = 50.0
        
myBar.backgroundColor = UIColor(red:0.86, green:0.25, blue:0.23, alpha:1)
self.view.addSubview(myBar)
```

and position your scrollview content view below the bar.
```swift
tableView.contentInset = UIEdgeInsetsMake(100.0, 0.0, 0.0, 0.0)
```

### Configuring bar behavior
Now we've got a bar with no subviews and no behavior, but a defined maximum height and minimum height.

To give the bar a behavior, we can use one of the included behaviors. Square Cash's bar behavior is simple to understand. When scrolled to the top, the bar is at its maximum height. As the user scrolls down, the bar begins to hide. The only way to make the bar visible again is by scrolling to the top.

The `SquareCashBarBehaviorDefiner` (inherits from `FlexibleHeightBarBehaviorDefiner`) contains all of the logic that controls how and when the height of the bar changes.

Set `myBar`'s `behaviorDefiner` property to an instance of `SquareCashBarBehaviorDefiner`.

```swift
myBar.behaviorDefiner = SquareCashBarBehaviorDefiner()
```

The behavior of a `SquareCashBarBehaviorDefiner` is directly dependent on what's going on with our scrolling view. Therefore, `SquareCashBarBehaviorDefiner` (and of course, all of its subclasses) conform to `UIScrollViewDelegate`.

Set your scrolling view's `UIScrollView` delegate property to `myBar`'s `behaviorDefiner` property. This gives our behavior definer the information it needs from our scrolling view to properly control the height of our bar.

```swift
self.scrollview.delegate = myBar.behaviorDefiner
```

### Snapping behavior (optional)
Snapping forces your bar to animate to a final position when the user stops scrolling. Any subclass of `FlexibleHeightBarBehaviorDefiner` automatically gets snapping functionality for free. Snapping works by defining a final bar `progress` to which the bar will animate whenever the user stops scrolling and the bar is between some range of progress values.

```swift
myBar.behaviorDefiner?.addSnappingPositionProgress(0.0, _forProgressRangeStart: 0.0, end: 0.5)
myBar.behaviorDefiner?.addSnappingPositionProgress(0.0, _forProgressRangeStart: 0.5, end: 1.0)
```
The above code simply causes the bar to snap to the maxmium height (`progress == 0.0`) or minimum height (`progress == 1.0`) depending on which is closer. Additional snapping positions can be defined and don't necessarily have to follow the "whichever is closer" rule.

### Configuring subviews
Subviews of a `FlexibleHeightBar` instance define layout attribtes (`frame`, `alpha`, `transform`, etc.) for key `progress` values.

At `progress == 0.0` (maximum bar height), your subview can have `alpha == 1.0`.

At `progress == 1.0` (minimum bar height), your subview can have `alpha == 0.0` and `transform == CGAffineTransformMakeScale(0.2, 0.2)`

As the bar condenses from its maximum height to its minimum height, your subview will smoothly shrink and fade away.

Start by creating and adding a subview to your bar. Don't bother giving it a frame - the layout attributes it defines in the next step will determine how it looks and where it appears.
```swift
let label = UILabel();
label.text = "TrendyStartup.io"
label.font = UIFont.systemFont(ofSize: 25.0)
label.textColor = UIColor.white
label.sizeToFit()
myBar.addSubview(label)
```

Next, we'll configure layout attributes for all of the discrete layout states of the subview. For this example, we want our label to fade, shrink, and slide up as the bar shrinks, disappearing entirely when the bar is fully condensed. We'll need to define 2 discrete states for our subview - the initial state, where the subview is entirely visible and full size, and the final state, where the subview is faded away and no longer visible. *All of the in-between states will be automatically filled in and with a smooth transition.*

We define these discrete layout states by defining layout attributes for a subview using the `FlexibleHeightBarSubviewLayoutAttributes` class.

```swift
let initialLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes()
initialLayoutAttributes.size = label.frame.size
initialLayoutAttributes.center = CGPoint(x: myBar.bounds.midX, y: myBar.bounds.midY + 10.0)
        
// This is what we want the bar to look like at its maximum height (progress == 0.0)
myBar.addLayoutAttributes(initialLayoutAttributes, forSubview: label, forProgress: 0.0)
```
and then
```swift
// This is what we want the bar to look like at its maximum height (progress == 0.0)
myBar.addLayoutAttributes(initialLayoutAttributes, forSubview: label, forProgress: 0.0)
        
// Create a final set of layout attributes based on the same values as the initial layout attributes
let finalLayoutAttributes = FlexibleHeightBarSubviewLayoutAttributes(layoutAttributes: initialLayoutAttributes)
finalLayoutAttributes.alpha = 0.0
let translation = CGAffineTransform(translationX: 0.0, y: -30.0)
let scale = CGAffineTransform(scaleX: 0.2, y: 0.2)
finalLayoutAttributes.transform = scale.concatenating(translation)
        
// This is what we want the bar to look like at its minimum height (progress == 1.0)
myBar.addLayoutAttributes(finalLayoutAttributes, forSubview: label, forProgress: 1.0)
```
*More layout attributes and more subviews can be added in exactly the same way, allowing you to create just about any flexible bar design imaginable.*

#### Congrats! You should now have something that looks and behaves like this:

![Example](media/example.gif?raw=true "Example")


## Creating custom behavior definers
If one of the included behavior definers isn't what you're looking for in your app, creating your own custom behavior definer might be the way to go.

In order to support any kind of behavior, `FlexibleHeightBar` was designed to feature a plug-n-play architecure for bar behaviors. By subclassing `FlexibleHeightBarBehaviorDefiner`, developers can have complete control over how and when a bar's `progress` property (and therefore, height) is updated. 

* In most scenarios, `FlexibleHeightBarBehaviorDefiner` isn't useful until subclassed. By itself, it only provides snapping functionality and a property that controls whether or not the bar bounces when it reaches its maximum height. It makes no attempt to adjust the height of the bar during scrolling.

### Subclassing guidelines
Start by creating a subclass `FlexibleHeightBarBehaviorDefiner`.

The basic pattern for the definer is as follows:

1. Implement `UIScrollViewDelegate` protocol methods. `scrollViewDidScroll()` is generally a useful starting point.
2. Based on the current scroll position in `scrollViewDidScroll()`, calculate a new progress value for the behavior definer's `flexibleHeightBar` property. It will be useful to ask the `flexibleHeightBar` for its `maximumBarHeight` and `minimumBarHeight` properties.
3. Set `self.flexibleHeightBar.progress` to the calculated value from step 2.
4. Notify the behavior definer's `flexibleHeightBar` that it needs to re-layout using `self.flexibleHeightBar.setNeedsLayout()`

It may be useful to make other calculations outside of `scrollViewDidScroll()`. For example, the included `FacebookBarBehaviorDefiner` needs to apply scrolling thresholds before the bar should hide or reveal itself. This calculation is done inside of `scrollViewWillBeginDragging()`.

### Autolayout

The FlexibleHeightBar supports autolayout in the same way that it supports other properties through the following methods:

```swift
public func addLayoutConstraintConstant(_ constant: CGFloat, forContraint constraint: NSLayoutConstraint, forProgress barProgress: CGFloat)
public func removeLayoutConstraintConstantforConstraint(constraint: NSLayoutConstraint, forProgress barProgress: CGFloat)
```