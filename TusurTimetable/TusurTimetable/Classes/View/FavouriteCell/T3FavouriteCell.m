//
//  T3FavouriteCell.m
//  TusurTimetable
//
//  Created by Katte on 26.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3FavouriteCell.h"
#import "T3Group.h"
#import "T3Lecturer.h"

@implementation T3FavouriteCell

+ (T3FavouriteCell *)favouriteCell
{
    T3FavouriteCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"T3FavouriteCell" owner:nil options:nil] objectAtIndex:0];
    return cell;
}

- (void)configureWithItem:(NSManagedObject *)item cellPosition:(T3CellPosition)cellPosition
{
    if ([item isKindOfClass:[T3Group class]]) {
        self.nameLabel.text = ((T3Group *)item).name;
        
    } else if ([item isKindOfClass:[T3Lecturer class]]) {
        self.nameLabel.text = ((T3Lecturer *)item).name;
    }
    
    [self updateWithPosition:cellPosition];
}

+ (CGFloat)cellHeight
{
    return 44.0;
}

@end
