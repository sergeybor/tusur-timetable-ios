//
//  T3PositionedTableCell.m
//  TusurTimetable
//
//  Created by Katte on 31.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3PositionedTableCell.h"
#import "UIView+Resizing.h"

#import "T3GroupItemBackgroundView.h"
#import "T3GroupItemSelectionView.h"

const CGFloat kPTCBgViewHorizInset = 4.0f;

const CGFloat kPTCSelViewHorizInset = 6.0f;
const CGFloat kPTCSelViewTopInset = 2.0f;
const CGFloat kPTCSelViewBottomInset = 8.0f;
const CGFloat kPTCSelViewCornerRadius = 8.0f;


@implementation T3PositionedTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createBGAndSelectionView];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self createBGAndSelectionView];
}

- (void)updateWithPosition:(T3CellPosition)pos
{
    [_bgView changeCellPosition:pos];
    [_selectionView changeCellPosition:pos];
    
    self.curCellPosition = pos;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	[_selectionView changeSelectedState:highlighted animated:animated];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [_selectionView changeSelectedState:selected animated:animated];
}

-(void)setSelected:(BOOL)selected
{
    [_selectionView changeSelectedState:selected animated:NO];
}

- (void)createBGAndSelectionView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!_bgView) {
        _bgView = [[T3GroupItemBackgroundView alloc] initWithFrame:CGRectMake(kPTCBgViewHorizInset, 0, self.frame.size.width - kPTCBgViewHorizInset * 2, self.frame.size.height)];
 //       [self.contentView insertSubview:_bgView atIndex:0];
    }
    [_bgView setupWithViewColor:[UIColor colorWithWhite:0.0f alpha:0.05f] cornerRadiuses:CGSizeMake(kPTCSelViewCornerRadius, kPTCSelViewCornerRadius)];

    if (!_selectionView) {
        _selectionView = [[T3GroupItemSelectionView alloc] initWithFrame:CGRectMake(kPTCSelViewHorizInset, kPTCSelViewTopInset, self.frame.size.width - kPTCSelViewHorizInset * 2, self.frame.size.height - (kPTCSelViewBottomInset + kPTCSelViewTopInset))];
   //     [self.contentView addSubview:_selectionView];
    }
    [_selectionView setupWithViewColor:[UIColor colorWithWhite:1.0f alpha:0.75f] cornerRadiuses:CGSizeMake(kPTCSelViewCornerRadius, kPTCSelViewCornerRadius)];
    
}

- (void)setBackgroundViewColor:(UIColor *)color
{
    [_bgView setViewColor:color];
}

@end
