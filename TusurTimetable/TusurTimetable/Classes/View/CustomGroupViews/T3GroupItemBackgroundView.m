//
//  T3GroupItemBackgroundView.m
//  TusurTimetable
//
//  Created by Katte on 31.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3GroupItemBackgroundView.h"
#import "UIColor+CreateMethods.h"

const CGFloat kGBVDefaultSeparatorHeight = 1.0f;
const CGFloat kGBVDefaultSeparatorInset = 1.0f;

@interface T3GroupItemBackgroundView ()

@property (weak, nonatomic) UIImageView *bgImageView;
@property (assign, nonatomic) T3CellPosition curPosition;

- (void)commonInit;
- (void)placeSeparator;
- (BOOL)isNeedSeparatorInPosition:(T3CellPosition)position;

@end

@implementation T3GroupItemBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	
	return self;
}

- (void)commonInit
{
	self.backgroundColor = [UIColor clearColor];
	
	// setup bgImageView
	UIImageView *imageView = [UIImageView new];
	imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self addSubview:imageView];
	self.bgImageView = imageView;
	
	// setup separator view
	self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 2*kGBVDefaultSeparatorInset, kGBVDefaultSeparatorHeight)];
	self.separatorView.backgroundColor = [UIColor colorWithHex:0xdfe9ed alpha:1.0f];
	self.separatorView.hidden = NO;
	self->_showsSeparator = YES;
	
	
	// Setting default cell position
	[self changePosition:T3CellPosition_Middle];
}

- (void)setSeparatorView:(UIView *)separatorView
{
	separatorView.hidden = self->_separatorView.hidden;
	[self->_separatorView removeFromSuperview];
	self->_separatorView = separatorView;
	self->_separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	[self addSubview:self->_separatorView];
	[self placeSeparator];
}

- (void)setShowsSeparator:(BOOL)showsSeparator
{
	self->_showsSeparator = showsSeparator;
	if (!showsSeparator) {
		self.separatorView.hidden = YES;
	}
	else {
		if ([self isNeedSeparatorInPosition:self.curPosition]) {
			self.separatorView.hidden = NO;
		}
	}
}

- (void)placeSeparator
{
	CGFloat separatorWidth = self.separatorView.frame.size.width;
	CGFloat separatorHeight = self.separatorView.frame.size.height;
	CGFloat deltaWidth = self.frame.size.width - separatorWidth;
	
	self.separatorView.frame = CGRectMake(floorf(deltaWidth/2.0f), self.frame.size.height - separatorHeight, separatorWidth, separatorHeight);
}

- (void)changePosition:(T3CellPosition)position
{
	self.curPosition = position;
	if (self.showsSeparator) {
		self.separatorView.hidden = ![self isNeedSeparatorInPosition:position];
	}
	
	switch (position) {
		case T3CellPosition_Top:
			self.bgImageView.image = self.topItemBgImage;
			break;
			
		case T3CellPosition_Middle:
			self.bgImageView.image = self.middleItemBgImage;
			break;
			
		case T3CellPosition_Bottom:
			self.bgImageView.image = self.bottomItemBgImage;
			break;
			
		case T3CellPosition_SingleCell:
			self.bgImageView.image = self.fullItemBgImage;
			break;
			
		default:
			NSAssert(NO, @"Unexpected position");
			break;
	}
}

- (BOOL)isNeedSeparatorInPosition:(T3CellPosition)position
{
    return (position != T3CellPosition_Bottom && position != T3CellPosition_SingleCell && position != T3CellPosition_None);
}

@end
