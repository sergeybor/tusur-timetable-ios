//
//  T3LecturersViewController.m
//  TusurTimetable
//
//  Created by Katte on 27.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3LecturersViewController.h"

#import "T3LecturerCell.h"

#import "T3Lecturer+Server.h"
#import "T3SystemInfo+Extension.h"

#import "T3TimetableViewController.h"

#import "SVProgressHUD.h"
#import "UITableView+CellPosition.h"


NSString *const T3LecturerCellReussableIdentifier = @"LecturerCell";
NSString *const T3LecturerToTimetableSegue = @"LecturerToTimetableSegue";

@interface T3LecturersViewController () <UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end

@implementation T3LecturersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([T3LecturerCell class]) bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:T3LecturerCellReussableIdentifier];
    self.tableView.rowHeight = [T3LecturerCell cellHeight];
    
    self.navigationItem.title = @"Преподователи";
    
    [self setupFetchedResultController];
    [self checkIfNeedLoadAndLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    
    [T3Lecturer cancelLoadFromServer];
    
}

#pragma mark - Model Helpers

- (void)setupFetchedResultController
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([T3Lecturer class])];
    if ([self.searchBar.text length] > 0) {
        request.predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", self.searchBar.text];
    }
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:[NSManagedObjectContext defaultContext]
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    T3LecturerCell *cell = (T3LecturerCell *)[tableView dequeueReusableCellWithIdentifier:T3LecturerCellReussableIdentifier];
    
    T3CellPosition cellPosition = [self.tableView positionForCellAtIndexPath:indexPath];
    T3Lecturer *lecturer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureWithLecturer:lecturer cellPosition:cellPosition];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:T3LecturerToTimetableSegue]){
        T3TimetableViewController *timetableViewController = (id)segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        T3Lecturer *lecturer = [self.fetchedResultsController objectAtIndexPath:indexPath];
        timetableViewController.lecturer = lecturer;
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

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
    [self setupFetchedResultController];
}

#pragma mark - helpers

- (void)checkIfNeedLoadAndLoad
{
    if ([T3SystemInfo lecturersTimestamp] == nil) {
        [SVProgressHUD show];
        
        __weak T3LecturersViewController *wself = self;
        
        [T3Lecturer updateLecturersFromServerWithCompletion:^(NSError *error) {
            if (error) {
                [wself showPlaceholderWithError:error];
            }
            [SVProgressHUD dismiss];
        }];
    }
}

@end
