# SwiftUIBug
Shows a potential bug with ForEach and Form

I've been growing frustrated with SwiftUI. I have some (limited) background with React and React-Native and the redux framework,
so I was thrilled to read about SwiftUI. But after going through Apple's "Landmarks" introduction, reading articles about
SwiftUI, and trying things out for myself, I'm left feeling disappointed.

I'm about to start writing a new app for my company - no legacy code here - and it seems like a perfect opportunity to
use SwiftUI. At this point it looks like I will turn to my old friend, UIKit.

I believe that Apple is 100% behind this, but they have to step it up. I do not think SwiftUI is ready for large scale app
development. It needs polish.

This repository shows two issues I have encountered and from what I've read on Stackoverflow and the Apple Developer site,
others have run into these issues.

My biggest one is with `Picker` and perhaps `ForEach`. This small app uses both a `Picker` and a `List` (both use `ForEach`).
The data source is a view model (`ObservableObject`) with an array. The idea is that a `TextField` is used to add more items 
to this array and that should be reflected in the UI. This works perfectly for `List` but fails for `Picker`.

There is also another issue with `Form` and `Section` where you have an `HStack` with two `Buttons`. Clicking on either
button or the form field itself triggers the actions on both buttons. Someone suggested using a tap gesture handler but 
that seems like a temporary work-around to me.

Maybe I am completely misunderstanding how to do this, so I welcome any insights.
