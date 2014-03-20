//
//  MyViewController.m
//  TableViewBug
//
//  Created by Bob Glass on 3/20/14.
//  Copyright (c) 2014 Workbox. All rights reserved.
//

#import "MyViewController.h"
#import "City.h"

#define CITY @"City"

@interface MyViewController () {
    NSManagedObjectContext *moc;
    NSArray *cities;
    UITableView *tv;
    NSFetchedResultsController *frc;
}

@end

@implementation MyViewController

//
//  DatabaseSelectionController.m
//  WorkBox
//
//  Created by Glass Bob on 10/18/12.
//  Copyright (c) 2012 com.workbox. All rights reserved.
//



-(id) initWithMOC:(NSManagedObjectContext *)inMoc {
    self = [super init];
    if (self) {
        moc = inMoc;
        [self housekeeping];
    }
    return self;
}

-(void) housekeeping {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CITY inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [moc executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
    	[moc deleteObject:managedObject];
    }
    if (![moc save:&error]) {
    	NSLog(@"Delete error");
    }
    cities = [NSArray arrayWithObjects:@"US/New York", @"US/San Francisco", @"US/Austin", @"US/Albany", @"US/Teaneck", @"US/LA", @"US/Phoenix", @"US/Toledo", @"US/Troy", @"Italy/Rome", @"Switzerland/Geneva", @"France/Paris", @"Japan/Tokyo", @"Russia/Moscow", nil];
    
    for (NSString *name in cities) {
        City *city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:moc];
        NSArray *array = [name componentsSeparatedByString: @"/"];
    
        city.country = [array objectAtIndex:0];
        city.name = [array objectAtIndex:1];
    }
    
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"country" ascending:NO];
    NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sd1, sd2, nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                              managedObjectContext:moc
                                                sectionNameKeyPath:@"country"
                                                         cacheName:nil];
    
    frc.delegate = self;

    if (![frc performFetch:&error]) {
        NSLog(@"Couldn't fetch results: %@", [error localizedDescription]);
    }
    
}
    

-(void) loadView {
    [super loadView];
    self.view = [[UIView alloc] init];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tv.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    tv.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tv.delegate=self;
    tv.dataSource=self;
    [self.view addSubview:tv];
    tv.rowHeight = 60;

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    tv.frame = self.view.frame;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:5];
//    [tv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(NSString *) title {
    return @"Test Core Data Delete with tableview";
}

#pragma mark -
#pragma mark Table view delegate/datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[frc sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return frc.sections.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[frc sections] objectAtIndex:section];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 44)];
    v.backgroundColor = [UIColor yellowColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 44)];
    label.font = [UIFont systemFontOfSize:25];
    label.text = [sectionInfo name];
    [v addSubview:label];
    return v;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 44)];
    v.backgroundColor = [UIColor yellowColor];
    return v;
                                                        
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    City *city = [frc objectAtIndexPath:indexPath];
    [moc deleteObject:city];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
	return cell;
}

-(void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    City *city = [frc objectAtIndexPath:indexPath];
    cell.textLabel.text = city.name;

}

#pragma mark -
#pragma mark FRC delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [tv beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tv insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                   withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tv deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                   withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = tv;
    
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:newIndexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
    
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [tv endUpdates];
}

@end
