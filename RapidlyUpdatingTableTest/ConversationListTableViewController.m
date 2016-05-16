//
//  ConversationListTableViewController.m
//  RapidlyUpdatingTableTest
//
//  Created by Matthew Keable on 15/05/2016.
//  Copyright © 2016 Matthew Keable. All rights reserved.
//

#import "ConversationListTableViewController.h"

@interface ConversationListTableViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
// Declare some collection properties to hold the various updates we might get from the NSFetchedResultsControllerDelegate
@property (nonatomic, strong) NSMutableIndexSet *deletedSectionIndexes;
@property (nonatomic, strong) NSMutableIndexSet *insertedSectionIndexes;
@property (nonatomic, strong) NSMutableArray *deletedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *updatedRowIndexPaths;
@end

@implementation ConversationListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Need to implement the method to get editing to work, but don't need to actually do anything insideß
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


#pragma mark - Editing

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *actions = [NSMutableArray arrayWithCapacity:2];
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                       title:@"Action1"
                                                                     handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                         //Empty Handler as we just need to simulate the swipe open action at the moment
                                                                         NSLog(@"MKTEST - Action1");
                                                                     }];
    [actions addObject:action1];
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                       title:@"Action2"
                                                                     handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                         //Empty Handler as we just need to simulate the swipe open action at the moment
                                                                         NSLog(@"MKTEST - Action2å");
                                                                     }];
    
    
    [actions addObject:action2];
    
    
    return actions;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return UITableViewCellEditingStyleDelete;
    return tableView.isEditing ? UITableViewCellEditingStyleNone: UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"MKTEST - Begin Editing");
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"MKTEST - End Editing");
}

#pragma mark - Core Data

//Lazy Instantiation
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DummyConversation"
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"timeStamp" ascending:NO];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:_managedObjectContext
                                          sectionNameKeyPath:@"sectionId"
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.insertedSectionIndexes addIndex:sectionIndex];
            break;
        case NSFetchedResultsChangeDelete:
            [self.deletedSectionIndexes addIndex:sectionIndex];
            break;
        default:
            // Shouldn't have a default
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    if (type == NSFetchedResultsChangeInsert)
    {
        //NSLog(@"MKTEST - Insert Row at Section %ld, Row %ld", (long)newIndexPath.section, (long)newIndexPath.row);
        if ([self.insertedSectionIndexes containsIndex:newIndexPath.section]) {
            // If we've already been told that we're adding a section for this inserted row we skip it since it will handled by the section insertion.
            return;
        }
        [self.insertedRowIndexPaths addObject:newIndexPath];
    }
    else if (type == NSFetchedResultsChangeDelete)
    {
        //NSLog(@"MKTEST - Delete Row at Section %ld, Row %ld", (long)indexPath.section, (long)indexPath.row);
        if ([self.deletedSectionIndexes containsIndex:indexPath.section]) {
            // If we've already been told that we're deleting a section for this deleted row we skip it since it will handled by the section deletion.
            return;
        }
        
        [self.deletedRowIndexPaths addObject:indexPath];
    }
    else if (type == NSFetchedResultsChangeMove)
    {
        //NSLog(@"MKTEST - Move Row from Section %ld, Row %ld to Section %ld, Row %ld", (long)indexPath.section, (long)indexPath.row, (long)newIndexPath.section, (long)newIndexPath.row);
        if ((![indexPath isEqual:newIndexPath]) || (self.insertedSectionIndexes.count > 0 || self.deletedSectionIndexes.count > 0))
        {
            if ([self.insertedSectionIndexes containsIndex:newIndexPath.section] == NO) {
                [self.insertedRowIndexPaths addObject:newIndexPath];
            }
            
            if ([self.deletedSectionIndexes containsIndex:indexPath.section] == NO) {
                [self.deletedRowIndexPaths addObject:indexPath];
            }
        }
    }
    else if (type == NSFetchedResultsChangeUpdate)
    {
        //NSLog(@"MKTEST - Update/Reload Row at Section %ld, Row %ld", (long)indexPath.section, (long)indexPath.row);
        if ([indexPath isEqual:newIndexPath])
        {
            [self.updatedRowIndexPaths addObject:indexPath];
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView deleteSections:self.deletedSectionIndexes withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertSections:self.insertedSectionIndexes withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView deleteRowsAtIndexPaths:self.deletedRowIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertRowsAtIndexPaths:self.insertedRowIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:self.updatedRowIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
    
    self.insertedSectionIndexes = nil;
    self.deletedSectionIndexes = nil;
    self.deletedRowIndexPaths = nil;
    self.insertedRowIndexPaths = nil;
    self.updatedRowIndexPaths = nil;
}

#pragma mark - Lazy Instantiation

/**
 * Lazily instantiate these collections.
 */

- (NSMutableIndexSet *)deletedSectionIndexes
{
    if (_deletedSectionIndexes == nil) {
        _deletedSectionIndexes = [[NSMutableIndexSet alloc] init];
    }
    
    return _deletedSectionIndexes;
}

- (NSMutableIndexSet *)insertedSectionIndexes
{
    if (_insertedSectionIndexes == nil) {
        _insertedSectionIndexes = [[NSMutableIndexSet alloc] init];
    }
    
    return _insertedSectionIndexes;
}

- (NSMutableArray *)deletedRowIndexPaths
{
    if (_deletedRowIndexPaths == nil) {
        _deletedRowIndexPaths = [[NSMutableArray alloc] init];
    }
    
    return _deletedRowIndexPaths;
}

- (NSMutableArray *)insertedRowIndexPaths
{
    if (_insertedRowIndexPaths == nil) {
        _insertedRowIndexPaths = [[NSMutableArray alloc] init];
    }
    
    return _insertedRowIndexPaths;
}

- (NSMutableArray *)updatedRowIndexPaths
{
    if (_updatedRowIndexPaths == nil) {
        _updatedRowIndexPaths = [[NSMutableArray alloc] init];
    }
    
    return _updatedRowIndexPaths;
}


@end
