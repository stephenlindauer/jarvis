//
//  NSManagedObjectContext+Utils.m
//  Awarnys
//
//  Created by Frank on 12/4/13.
//  Copyright (c) 2013 Awarnys, LLC. All rights reserved.
//

#import "NSManagedObjectContext+Utils.h"
#import "Jarvis-Swift.h"

@implementation NSManagedObjectContext (Utils)

+ (NSManagedObjectContext *)contextForCurrentThread
{
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

@end
