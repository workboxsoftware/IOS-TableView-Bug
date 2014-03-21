IOS-TableView-Bug
=================

Test program recreates bug in tableview.<br><br>
Summary:  Have a tableview backed by a fetchedresultscontroller.  When managed objects are deleted and the tableview needs to scroll up so it no longer fills the screen, the program crashes.

Here's the crash: *** Assertion failure in -[UIViewAnimation initWithView:indexPath:endRect:endAlpha:startFraction:endFraction:curve:animateFromCurrentPosition:shouldDeleteAfterAnimation:editing:], /SourceCache/UIKit_Sim/UIKit-2935.137/UITableViewSupport.m:2666 2014-03-21 08:20:41.920 TableViewBug[4164:60b] CoreData: error: Serious application error. An exception was caught from the delegate of NSFetchedResultsController during a call to -controllerDidChangeContent:. Cell animation stop fraction must be greater than start fraction with userInfo (null)

Here are the steps needed to recreate the crash: 

1. have tableview that fills more than a screen. 
2. Delete objects in core data until there's less than a screen's worth of data - and the bottom row scrolls up.
3. Tableview is Plain. This bug doesn't happen on Grouped tableview.
4. Need to have section footers.

Here's what the test program does: 

1. populates Core Data entity called "City" with a bunch of cities (e.g., NY, Rome, Moscow).
2. displays the table.
3. scrolls the table down.
4. deletes a few objects from City.


