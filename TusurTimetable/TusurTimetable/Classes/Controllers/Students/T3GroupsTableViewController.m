//
//  T3GroupsTableViewController.m
//  TusurTimetable
//
//  Created by Katte on 11.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3GroupsTableViewController.h"

#import "T3Group.h"

#import "T3GroupCell+T3Group.h"

#import "T3TimetableViewController.h"

#import "UITableView+CellPosition.h"


NSString *const T3GroupCellReussableIdentifier = @"GroupCell";
NSString *const T3GroupToTimetableSegue = @"GroupToTimetableSegue";

const CGFloat T3GroupHeaderSectionHeight = 40.0;

@interface T3GroupsTableViewController ()

@end

@implementation T3GroupsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchedResultController];
    self.navigationItem.title = @"Группы";
}

#pragma mark - Model Helpers

- (void)setupFetchedResultController
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([T3Group class])];
    request.predicate = [NSPredicate predicateWithFormat:@"department == %@", self.department];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"year" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:[NSManagedObjectContext defaultContext]
                                     sectionNameKeyPath:@"year"
                                     cacheName:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    T3GroupCell *cell = (T3GroupCell *)[tableView dequeueReusableCellWithIdentifier:T3GroupCellReussableIdentifier];
    
    T3Group *group = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    T3CellPosition cellPosition = [self.tableView positionForCellAtIndexPath:indexPath];
    
    [cell configureForGroup:group cellPosition:cellPosition];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return T3GroupHeaderSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat labelIndent = 20.0;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, T3GroupHeaderSectionHeight)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelIndent, 0, view.frame.size.width - labelIndent, view.frame.size.height)];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:section];
    T3Group *group = [self.fetchedResultsController objectAtIndexPath:path];
    
    label.text = [NSString stringWithFormat:@"%i-й курс", [group.year integerValue]];
    
    [view addSubview:label];
    
    return view;
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:T3GroupToTimetableSegue]){
        T3TimetableViewController *timetableViewController = (id)segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        T3Group *group = [self.fetchedResultsController objectAtIndexPath:indexPath];
        timetableViewController.group = group;
    }
}

#pragma mark - helpers


@end
