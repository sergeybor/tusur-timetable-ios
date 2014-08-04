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
#import "T3UpdateManager.h"

#import "SVProgressHUD.h"
#import "T3PlaceholderView.h"

#import "UIView+Resizing.h"
#import "UITableView+CellPosition.h"

NSString *const T3TimetableShortCellReussableIdentifier = @"TimetableShortCell";
NSString *const T3TimetableFullCellReussableIdentifier = @"TimetableFullCell";

const CGFloat T3TimetableHeaderSectionHeight = 35.0;


@interface T3TimetableViewController ()

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIButton *addButton;

@property (nonatomic, strong) NSMutableArray *cellsWithFullInfo;

@end

@implementation T3TimetableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *shortCellNib = [UINib nibWithNibName:NSStringFromClass([T3TimetableShortCell class]) bundle:nil];
    [self.tableView registerNib:shortCellNib forCellReuseIdentifier:T3TimetableShortCellReussableIdentifier];
    
    UINib *fullCellNib = [UINib nibWithNibName:NSStringFromClass([T3TimetableFullCell class]) bundle:nil];
    [self.tableView registerNib:fullCellNib forCellReuseIdentifier:T3TimetableFullCellReussableIdentifier];
    
    [self setupFetchedResultController];
    [self checkIfNeedLoadAndLoad];
    
    
    self.cellsWithFullInfo = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupFavouriteButton];
    self.navigationItem.title = [NSString stringWithFormat:@"Гр. %@", self.group.name];
    
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
    
    T3CellPosition cellPosition = [self.tableView positionForCellAtIndexPath:indexPath];
    T3TimeTable *timetable = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [(T3TimetableCell *)cell configureWithTimetable:timetable cellPosition:cellPosition];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return T3TimetableHeaderSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat labelIndent = 20.0;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, T3TimetableHeaderSectionHeight)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelIndent, 0, view.frame.size.width - labelIndent, view.frame.size.height-5)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:section];
    T3TimeTable *timetable = [self.fetchedResultsController objectAtIndexPath:path];
    
    NSString *day = [T3TimeTable weekDayToNumber:[timetable.dayOfWeek integerValue]];
    
    BOOL isOddWeek = self.segmentedControl.selectedSegmentIndex;
    BOOL isToday = [T3TimeTable isDayToday:[timetable.dayOfWeek integerValue] isOddWeek:isOddWeek];
    
    if (isToday) {
        day = [NSString stringWithFormat:@"%@ (сегодня)", day];
        [self decorateView:view];
    }

    label.text = day;
    
    [view addSubview:label];
    
    return view;
}

- (void)decorateView:(UIView *)view
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor colorWithWhite:0.0f alpha:0.05f].CGColor;
    layer.frame = CGRectMake(10.0, 0, view.frame.size.width - 20.0, view.frame.size.height - 2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:layer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)];
    layer.path = path.CGPath;
    
    [view.layer addSublayer:layer];

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cellsWithFullInfo containsObject:indexPath]) {
        [self.cellsWithFullInfo removeObject:indexPath];
    } else {
        T3TimetableCell *cell = (T3TimetableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
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
    T3TimeTable *timetable = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([self.cellsWithFullInfo containsObject:indexPath]) {
        return [T3TimetableFullCell heightForItem:timetable];
    } else {
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
        message = @"удалена из закладок";
    } else {
        [T3Favourites addGroup:self.group];
        message = @"добавлена в закладки";
    }
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    
    [self setupFavouriteButton];
    
    message = [NSString stringWithFormat:@"Группа %@ %@", self.group.name, message];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Закладки"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Ок"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (IBAction)onAlertButtonTap:(id)sender
{
    [self showAlertWithTitle:@"Ошибка!" message:@"Не удалось загрузить новую версию расписания"];
}

#pragma mark - helpers

- (void)checkIfNeedLoadAndLoad
{
    //check if there is internet connection
    if ([[T3UpdateManager defaultUpdateManager] isNetworkReachable]) {
        [self setupErrorSignInNavigationBar];
        return;
    }
    
    __weak T3TimetableViewController *wself = self;
    
    [self removeErrorSignInNavigationBar];
    [SVProgressHUD show];
    [self.group updateTimetableFromServerWithCompletion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [wself showAlertWithError:error];
            [wself setupErrorSignInNavigationBar];
        }
    }];
}

- (void)setupFavouriteButton
{
    if ([self.group isFavourite]) {
        UIImage *image = [UIImage imageNamed:@"minus"];
        [self.addButton setImage:image forState:UIControlStateNormal];
       // [self.addButton setTitle:@"-" forState:UIControlStateNormal];
    } else {
//        [self.addButton setTitle:@"+" forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:@"plus"];
        [self.addButton setImage:image forState:UIControlStateNormal];

    }
}

- (void)setupErrorSignInNavigationBar
{
    UIImage *image = [UIImage imageNamed:@"emergencyicon"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    
    [button addTarget:self action:@selector(onAlertButtonTap:) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setRightBarButtonItem:barButtonItem];
}

- (void)removeErrorSignInNavigationBar
{
    self.navigationItem.rightBarButtonItem = nil;
}

@end
