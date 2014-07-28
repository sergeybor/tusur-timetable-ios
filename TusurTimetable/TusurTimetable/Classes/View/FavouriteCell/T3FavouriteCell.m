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

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
    
    }
    return self;
}

- (void)configureWithItem:(NSManagedObject *)item
{
    if ([item isKindOfClass:[T3Group class]]) {
        self.textLabel.text = ((T3Group *)item).name;
        
    } else if ([item isKindOfClass:[T3Lecturer class]]) {
        self.textLabel.text = ((T3Lecturer *)item).name;
    }
    
}

@end
