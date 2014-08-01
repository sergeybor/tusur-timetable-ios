//
//  T3DepartmentsTableViewController.m
//  TusurTimetable
//
//  Created by Katte on 13.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3DepartmentsTableViewController.h"

#import "T3Department.h"
#import "T3Department+Server.h"

#import "T3DepartmentCell+T3Department.h"
#import "T3SystemInfo+Extension.h"

#import "T3GroupsTableViewController.h"

#import "SVProgressHUD.h"
#import "T3PlaceholderView.h"


NSString *const T3DepartmentCellReussableIdentifier = @"DepartmentCell";
NSString *const T3DepartmentToGroupsSegue = @"DepartmentToGroups";

@interface T3DepartmentsTableViewController ()

@end

@implementation T3DepartmentsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Факультеты";
    [self setupFetchedResultController];
    [self checkIfNeedLoadAndLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    
    [T3Department cancelLoadFromServer];
    
}

#pragma mark - Model Helpers

- (void)setupFetchedResultController
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([T3Department class])];
    //    request.predicate = [NSPredicate predicateWithFormat:@"name == %@", @"183"];
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:[NSManagedObjectContext defaultContext]
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    T3DepartmentCell *cell = (T3DepartmentCell *)[tableView dequeueReusableCellWithIdentifier:T3DepartmentCellReussableIdentifier];
    
    T3Department *department = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell configureForDepartment:department];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:T3DepartmentToGroupsSegue]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        T3Department *department = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
        T3GroupsTableViewController *groupsViewController = (id)segue.destinationViewController;
        groupsViewController.department = department;
    }
}

#pragma mark - helpers

- (void)checkIfNeedLoadAndLoad
{
    __weak T3DepartmentsTableViewController *wself = self;
    if ([T3SystemInfo groupsTimestamp] == nil) {
        [SVProgressHUD show];
        [T3Department updateDepartmentsFromServerWithCompletion:^(NSError *error) {
            if (error) {
                [wself showPlaceholderWithError:error];
            }
            [SVProgressHUD dismiss];
        }];
    }
}


@end
