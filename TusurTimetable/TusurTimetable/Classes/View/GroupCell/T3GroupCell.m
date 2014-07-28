//
//  T3GroupTableViewCell.m
//  TusurTimetable
//
//  Created by Katte on 11.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3GroupCell.h"

@implementation T3GroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
