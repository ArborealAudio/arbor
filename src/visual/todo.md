# TODO

## Improve

* Don't refer to string id as 'display' if it won't be displayed
    * WHich components require a string (i.e. state) but won't display it?

* Log-range sliders

* More widgets

    * Small console window
    * Text input
    * Scrollable views

* Improve internal spacing of widgets like toggle button

* How can we center a box vertically within its parent?
    * Is there something we can do with pushing a vertical gap which is based off the parent size?

* Can growable sizes feel better?

* Use cbase more fully

* Make a test app, maybe just like one of those other imgui examples that doens't really do
anything but showcases all the available features of the library

* Make popup menu go away when clicking away

* Write your own hash table you wuss

* Make timing/memory info a series of expandable displays, can also drag the window around

* Namespacing is all over the place, certain types are kind of liminal and don't seem named properly

## Fix

* Popup is now passing mouse events to stuff behind it

