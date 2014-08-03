//
//  T3SearchGroupViewController.m
//  TusurTimetable
//
//  Created by Katte on 27.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3SearchGroupViewController.h"

#import "T3Group.h"

#import "T3TimetableViewController.h"

#import "T3SearchGroupCell.h"
#import "UITableView+CellPosition.h"

NSString *const T3SearchGroupCellReussableIdentifier = @"SearchGroupCell";
NSString *const T3SearchGroupToTimetableSegue = @"SearchGroupToTimetableSegue";

@interface T3SearchGroupViewController () <UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end

@implementation T3SearchGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Поиск группы";
    [self setupFetchedResultController];
}

#pragma mark - Model Helpers

- (void)setupFetchedResultController
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([T3Group class])];
    request.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", self.searchBar.text];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"year" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:[NSManagedObjectContext defaultContext]
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    T3SearchGroupCell *cell = (T3SearchGroupCell *)[tableView dequeueReusableCellWithIdentifier:T3SearchGroupCellReussableIdentifier];
    
    T3CellPosition cellPosition = [self.tableView positionForCellAtIndexPath:indexPath];
    T3Group *group = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureWithGroup:group cellPosition:cellPosition];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:T3SearchGroupToTimetableSegue]){
        T3TimetableViewController *timetableViewController = (id)segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        T3Group *group = [self.fetchedResultsController objectAtIndexPath:indexPath];
        timetableViewController.group = group;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self setupFetchedResultController];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

@end
