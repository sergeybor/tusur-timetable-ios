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
const CGFloat kPTCSelViewBottomInset = 3.0f;
const CGFloat kPTCSelViewCornerRadius = 3.0f;


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
    [_bgView changePosition:pos];
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
//    self.backgroundView = _bgView;
    //[self addSubview:_bgView];
    
    _bgView.topItemBgImage = [self cellGreyBackgroundImageForPosition:T3CellPosition_Top];
	_bgView.middleItemBgImage = [self cellGreyBackgroundImageForPosition:T3CellPosition_Middle];
	_bgView.bottomItemBgImage = [self cellGreyBackgroundImageForPosition:T3CellPosition_Bottom];
	_bgView.fullItemBgImage = [self cellGreyBackgroundImageForPosition:T3CellPosition_SingleCell];

    if (!_selectionView) {
        _selectionView = [[T3GroupItemSelectionView alloc] initWithFrame:CGRectMake(kPTCSelViewHorizInset, kPTCSelViewTopInset, self.frame.size.width - kPTCSelViewHorizInset * 2, self.frame.size.height - (kPTCSelViewBottomInset + kPTCSelViewTopInset))];
   //     [self.contentView addSubview:_selectionView];
    }
 
    [_selectionView setupWithSelectionColor:[UIColor colorWithWhite:1.0f alpha:0.75f] cornerRadiuses:CGSizeMake(kPTCSelViewCornerRadius, kPTCSelViewCornerRadius)];
    
//    self.selectedBackgroundView = _selectionView;
	
}

- (UIImage *)cellGreyBackgroundImageForPosition:(T3CellPosition)position
{
    NSString *bgImagePath;
    UIEdgeInsets edgeInsets;
    
    switch (position) {
        case T3CellPosition_Top:
			bgImagePath = @"gray_top_backgr_item.png";
			edgeInsets = UIEdgeInsetsMake(4, 4, 0, 5);
            break;
            
        case T3CellPosition_Middle:
			bgImagePath = @"gray_centre_backgr_item.png";
			edgeInsets = UIEdgeInsetsMake(0, 1, 0, 2);
            break;
            
        case T3CellPosition_Bottom:
			bgImagePath = @"gray_down_backgr_item.png";
			edgeInsets = UIEdgeInsetsMake(0, 4, 5, 5);
            break;
			
		case T3CellPosition_SingleCell:
			bgImagePath = @"gray_backitem_full.png";
			edgeInsets = UIEdgeInsetsMake(4, 4, 5, 5);
            break;
            
        default:
			return nil;
            break;
    }
    
	return [[UIImage imageNamed:bgImagePath] resizableImageWithCapInsets:edgeInsets];
}

- (UIImage *)cellWhiteBackgroundImageForPosition:(T3CellPosition)position
{
	NSString *bgImagePath;
	UIEdgeInsets edgeInsets;
    
	switch (position) {
		case T3CellPosition_Top:
			bgImagePath = @"white_top_backgr_item.png";
			edgeInsets = UIEdgeInsetsMake(4, 4, 0, 5);
			break;
			
		case T3CellPosition_Middle:
			bgImagePath = @"white_centre_backgr_item.png";
			edgeInsets = UIEdgeInsetsMake(0, 1, 0, 2);
			break;
			
		case T3CellPosition_Bottom:
			bgImagePath = @"white_down_backgr_item.png";
			edgeInsets = UIEdgeInsetsMake(0, 4, 5, 5);
			break;
            
        case T3CellPosition_SingleCell:
            bgImagePath = @"white_backitem_full.png";
            edgeInsets = UIEdgeInsetsMake(4, 4, 5, 5);
            break;
			
		default:
			return nil;
			break;
	}
	
	return [[UIImage imageNamed:bgImagePath] resizableImageWithCapInsets:edgeInsets];
}

@end
