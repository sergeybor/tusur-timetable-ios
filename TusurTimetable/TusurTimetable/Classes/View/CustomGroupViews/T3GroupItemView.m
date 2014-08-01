//
//  T3GroupItemView.m
//  TusurTimetable
//
//  Created by Katte on 01.08.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3GroupItemView.h"

@implementation T3GroupItemView

- (void)setupWithViewColor:(UIColor *)selColor cornerRadiuses:(CGSize)radiuses
{
	self.viewColor = selColor;
	self.cornerRadiuses = radiuses;
	
	[self.viewLayer removeFromSuperlayer];
	
	CAShapeLayer *layer = [CAShapeLayer layer];
	self.viewLayer = layer;
	self.viewLayer.fillColor = selColor.CGColor;
	self.viewLayer.opacity = 1.0f;
	self.viewLayer.frame = self.bounds;
	[self.layer addSublayer:self.viewLayer];
	
	// Setting default cell position
	[self changeCellPosition:T3CellPosition_Middle];
}

- (void)changeCellPosition:(T3CellPosition)curCellPos
{
	UIBezierPath *path = nil;
	
	switch (curCellPos) {
		case T3CellPosition_Top:
			path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:self.cornerRadiuses];
			break;
			
		case T3CellPosition_Middle:
			path = [UIBezierPath bezierPathWithRect:self.bounds];
			break;
			
		case T3CellPosition_Bottom:
			path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:self.cornerRadiuses];
			break;
			
		case T3CellPosition_SingleCell:
			path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.cornerRadiuses];
			break;
		default:
			NSAssert(NO, @"Unexpected cell position");
			break;
	}
    
	self.viewLayer.path = path.CGPath;
}

- (void)setViewColor:(UIColor *)color
{
    self.viewLayer.fillColor = color.CGColor;
}

@end
