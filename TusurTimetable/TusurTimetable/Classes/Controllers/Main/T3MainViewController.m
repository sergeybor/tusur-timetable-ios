//
//  T3MainViewController.m
//  TusurTimetable
//
//  Created by Katte on 10.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3MainViewController.h"
#import "T3UpdateManager.h"
#import "T3FavouriteCell.h"

#import "T3Favourites+Extension.h"
#import "T3Lecturer.h"
#import "T3Group.h"

#import "T3TimetableViewController.h"

#import "UITableView+CellPosition.h"

NSString *const T3FavouriteCellReussableIdentifier = @"FavouriteCell";

@interface T3MainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, weak) IBOutlet UIButton *studentsButton;
@property (nonatomic, weak) IBOutlet UIButton *teachersButton;

@end

@implementation T3MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupButtons];
    
    UINib *userCellNib = [UINib nibWithNibName:NSStringFromClass([T3FavouriteCell class]) bundle:nil];
    [self.tableView registerNib:userCellNib forCellReuseIdentifier:T3FavouriteCellReussableIdentifier];
    self.tableView.rowHeight = [T3FavouriteCell cellHeight];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self loadItems];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *item = [self.items objectAtIndex:indexPath.row];
    [self showTimetableForItem:item];
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    T3FavouriteCell *favouriteCell = [self.tableView dequeueReusableCellWithIdentifier:T3FavouriteCellReussableIdentifier];
    
    NSManagedObject *item = [self.items objectAtIndex:indexPath.row];
    T3CellPosition cellPosition = [self.tableView positionForCellAtIndexPath:indexPath];
    [favouriteCell configureWithItem:item cellPosition:cellPosition];
    
    return favouriteCell;
}

#pragma mark - helpers

- (void)loadItems
{
    NSArray *groupsIds = [T3Favourites findByAttribute:@"objectType" withValue:@(T3FavouriteGroup)];
    NSArray *lecturersIds = [T3Favourites findByAttribute:@"objectType" withValue:@(T3FavouriteLecturer)];
    
    self.items = [NSMutableArray array];
    
    if ([groupsIds count] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.serverID IN %@", [self getArrayIdsFromFavouriteItems:groupsIds]];
        NSArray *groups = [T3Group findAllSortedBy:@"name" ascending:YES withPredicate:predicate];
        [self.items addObjectsFromArray:groups];
    }
    
    if ([lecturersIds count] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.serverID IN %@", [self getArrayIdsFromFavouriteItems:lecturersIds]];
        NSArray *lecturers = [T3Lecturer findAllSortedBy:@"name" ascending:YES withPredicate:predicate];
        [self.items addObjectsFromArray:lecturers];
    }
    
}

- (NSArray *)getArrayIdsFromFavouriteItems:(NSArray *)favouriteItems
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[favouriteItems count]];
    for (T3Favourites *item in favouriteItems) {
        [result addObject:item.serverID];
    }
    return result;
}

- (void)showTimetableForItem:(NSManagedObject *)item
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    T3TimetableViewController *timetableViewController = [storyboard instantiateViewControllerWithIdentifier:
                                                                NSStringFromClass([T3TimetableViewController class])];
    
    if ([item isKindOfClass:[T3Group class]]) {
        timetableViewController.group = (T3Group *)item;
    } else if ([item isKindOfClass:[T3Lecturer class]]) {
        timetableViewController.lecturer = (T3Lecturer *)item;
    }
    
    [self.navigationController pushViewController:timetableViewController animated:YES];
}

#pragma mark - UI helpers

- (void)setupButtons
{
    self.studentsButton.layer.cornerRadius = 10;
    self.teachersButton.layer.cornerRadius = 10;
}

@end
