//
//  NSManagedObjectContext+Utils.h
//  Awarnys
//
//  Created by Frank on 12/4/13.
//  Copyright (c) 2013 Awarnys, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Utils)

+ (NSManagedObjectContext *)contextForCurrentThread;

@end
