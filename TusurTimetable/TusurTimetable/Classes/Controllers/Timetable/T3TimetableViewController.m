//
//  T3TimetableViewController.m
//  TusurTimetable
//
//  Created by Katte on 23.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3TimetableViewController.h"

#import "T3TimetableShortCell.h"
#import "T3TimetableFullCell.h"

#import "T3TimeTable.h"
#import "T3Group+Server.h"
#import "T3Group+Extension.h"
#import "T3TimeTable+Extension.h"
#import "T3Favourites+Extension.h"

#import "SVProgressHUD.h"

NSString *const T3TimetableShortCellReussableIdentifier = @"TimetableShortCell";
NSString *const T3TimetableFullCellReussableIdentifier = @"TimetableFullCell";

@interface T3TimetableViewController ()

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIButton *addButton;

@property (nonatomic, strong) NSMutableArray *cellsWithFullInfo;

@end

@implementation T3TimetableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchedResultController];
    [self checkIfNeedLoadAndLoad];
    
    self.cellsWithFullInfo = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupFavouriteButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    
    [self.group cancelLoadFromServer];
    
}

#pragma mark - Model Helpers

- (void)setupFetchedResultController
{
    BOOL isOddWeek = self.segmentedControl.selectedSegmentIndex == 1;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([T3TimeTable class])];
    request.predicate = [NSPredicate predicateWithFormat:@"self.group == %@ AND self.isOdd == %@ AND hide == %@", self.group, @(isOddWeek), @(NO)];

    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"dayOfWeek" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"lessonNumber" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:[NSManagedObjectContext defaultContext]
                                     sectionNameKeyPath:@"dayOfWeek"
                                     cacheName:nil];
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if ([self.cellsWithFullInfo containsObject:indexPath]) {
        cell = (T3TimetableFullCell *)[tableView dequeueReusableCellWithIdentifier:T3TimetableFullCellReussableIdentifier];
    } else {
        cell = (T3TimetableShortCell *)[tableView dequeueReusableCellWithIdentifier:T3TimetableShortCellReussableIdentifier];
    }
    
    T3TimeTable *timetable = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [(id<IT3TimetableCell>)cell configureWithTimetable:timetable];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:section];
    T3TimeTable *timetable = [self.fetchedResultsController objectAtIndexPath:path];
    
    return [T3TimeTable stringToDayNumber:[timetable.dayOfWeek integerValue] isOddWeek:self.segmentedControl.selectedSegmentIndex];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cellsWithFullInfo containsObject:indexPath]) {
        [self.cellsWithFullInfo removeObject:indexPath];
    } else {
        UITableViewCell<IT3TimetableCell> *cell = (UITableViewCell<IT3TimetableCell> *)[self.tableView cellForRowAtIndexPath:indexPath];
        T3TimeTable *timetable = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if ([[cell class] shouldExpandForItem:timetable])
            [self.cellsWithFullInfo addObject:indexPath];
    }
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cellsWithFullInfo containsObject:indexPath]) {
        return 188.0;
    } else {
        T3TimeTable *timetable = [self.fetchedResultsController objectAtIndexPath:indexPath];
        return [T3TimetableShortCell heightForItem:timetable];
    }
}

#pragma mark - Actions

- (IBAction)onSegmentedControlValueChanged:(id)sender
{
    [self setupFetchedResultController];
}

- (IBAction)onAddButtonTap:(id)sender
{
    // TODO : check if groups or lecturers
    NSString *message = nil;
    if ([self.group isFavourite]) {
        [T3Favourites removeGroup:self.group];
        message = @"Removed";
    } else {
        [T3Favourites addGroup:self.group];
        message = @"Added";
    }
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    
    [self setupFavouriteButton];
        // show message;
}

#pragma mark - helpers

- (void)checkIfNeedLoadAndLoad
{
    __weak T3TimetableViewController *wself = self;
    
    //TODO: add check if need load
    [SVProgressHUD show];
    [self.group updateTimetableFromServerWithCompletion:^(NSError *error) {
        if (error) {
            [wself showPlaceholderWithError:error];
        }
        [SVProgressHUD dismiss];
    }];
}

- (void)setupFavouriteButton
{
    if ([self.group isFavourite]) {
        [self.addButton setTitle:@"-" forState:UIControlStateNormal];
    } else {
        [self.addButton setTitle:@"+" forState:UIControlStateNormal];
    }
}

@end
