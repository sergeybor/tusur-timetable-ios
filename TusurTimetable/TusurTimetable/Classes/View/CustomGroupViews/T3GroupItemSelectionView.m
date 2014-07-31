//
//  T3GroupItemSelectionView.m
//  TusurTimetable
//
//  Created by Katte on 31.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3GroupItemSelectionView.h"

@implementation T3GroupItemSelectionView

- (void)setupWithSelectionColor:(UIColor *)selColor cornerRadiuses:(CGSize)radiuses
{
	self.selectionColor = selColor;
	self.cornerRadiuses = radiuses;
	
	[self.selectionLayer removeFromSuperlayer];
	
	CAShapeLayer *selLayer = [CAShapeLayer layer];
	self.selectionLayer = selLayer;
	self.selectionLayer.fillColor = selColor.CGColor;
	self.selectionLayer.opacity = 0.0f;
	self.selectionLayer.frame = self.bounds;
	[self.layer addSublayer:self.selectionLayer];
	
	// Setting default cell position
	[self changeCellPosition:T3CellPosition_Middle];
}

- (void)changeSelectedState:(BOOL)isSelected animated:(BOOL)animated
{
	[self.selectionLayer removeAllAnimations];
	
	if (isSelected) {
		self.selectionLayer.opacity = 1.0f;
	}
	else {
		CGFloat newOpacityVal = 0.0f;
		
		if (animated) {
			CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			animation.fromValue = @(self.selectionLayer.opacity);
			animation.toValue = @(newOpacityVal);
			animation.duration = 0.6f;
			animation.autoreverses = NO;
			self.selectionLayer.opacity = newOpacityVal;
		    [self.selectionLayer addAnimation:animation forKey:@"opacity"];
		}
		else {
			self.selectionLayer.opacity = newOpacityVal;
		}
	}
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
    
	self.selectionLayer.path = path.CGPath;
}

@end
