//
//  MyViewController.h
//  TableViewBug
//
//  Created by Bob Glass on 3/20/14.
//  Copyright (c) 2014 Workbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

-(id) initWithMOC:(NSManagedObjectContext *)moc;

@end
