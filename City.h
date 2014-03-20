//
//  City.h
//  TableViewBug
//
//  Created by Bob Glass on 3/20/14.
//  Copyright (c) 2014 Workbox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface City : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * country;

@end
