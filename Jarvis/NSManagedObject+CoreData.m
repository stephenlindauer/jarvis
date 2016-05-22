//
//  NSManagedObject+CoreData.m
//  Awarnys
//
//  Created by Frank on 12/4/13.
//  Copyright (c) 2013 Awarnys, LLC. All rights reserved.
//

#import "NSManagedObject+CoreData.h"
#import "NSManagedObjectContext+Utils.h"

@implementation NSManagedObject (CoreData)

+ (id)createEntity
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self className] inManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (id)findFirstWithPredicate:(NSPredicate *)predicate
{
    NSArray *all = [self findAllWithPredicate:predicate];
    if (all.count >= 1) {
        return all[0];
    }
    
    return nil;
}

+ (id)findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue
{
    NSArray *all = [self findByAttribute:attribute withValue:searchValue];
    if (all.count >= 1) {
        return all[0];
    }
    
    return nil;
}


+ (NSArray *)findAll
{    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self className] inManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
    [fetchRequest setEntity:entity];
    return [[NSManagedObjectContext contextForCurrentThread] executeFetchRequest:fetchRequest error:nil];
}

+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self className] inManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
    [fetchRequest setEntity:entity];

    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:sortTerm ascending:ascending]]];

    return [[NSManagedObjectContext contextForCurrentThread] executeFetchRequest:fetchRequest error:nil];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)searchPredicate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self className] inManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:searchPredicate];
    
    return [[NSManagedObjectContext contextForCurrentThread] executeFetchRequest:fetchRequest error:nil];
}

+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue
{
    NSString *predicateString = [[NSString alloc] initWithFormat:@"%@ = %%@", attribute];
    return [self findAllWithPredicate:[NSPredicate predicateWithFormat:predicateString, searchValue]];
}



- (void)saveManagedObjectContext
{
    [[NSManagedObjectContext contextForCurrentThread] save:nil];
}

- (void)deleteEntity
{
    [[NSManagedObjectContext contextForCurrentThread] deleteObject:self];
}


+ (NSString *)className
{
    NSArray *names = [NSStringFromClass(self.class) componentsSeparatedByString:@"."];
    return [names lastObject];
}


@end
