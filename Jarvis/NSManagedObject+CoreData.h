//
//  NSManagedObject+CoreData.h
//  Awarnys
//
//  Created by Frank on 12/4/13.
//  Copyright (c) 2013 Awarnys, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (CoreData)

#pragma mark - Magic Record replacement helper methods

+ (id)createEntity;
+ (id)findFirstWithPredicate:(NSPredicate *)predicate;
+ (id)findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;

+ (NSArray *)findAll;
+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSArray *)findAllWithPredicate:(NSPredicate *)searchTerm;
+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue;


- (void)saveManagedObjectContext;
- (void)deleteEntity;

@end
