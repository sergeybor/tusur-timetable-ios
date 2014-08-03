//
//  T3GroupItemSelectionView.m
//  TusurTimetable
//
//  Created by Katte on 31.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3GroupItemSelectionView.h"

@implementation T3GroupItemSelectionView

- (void)setupWithViewColor:(UIColor *)selColor cornerRadiuses:(CGSize)radiuses
{
    [super setupWithViewColor:selColor cornerRadiuses:radiuses];
    
    self.viewLayer.opacity = 0.0f;
}

- (void)changeSelectedState:(BOOL)isSelected animated:(BOOL)animated
{
	[self.viewLayer removeAllAnimations];
	
	if (isSelected) {
		self.viewLayer.opacity = 1.0f;
	}
	else {
		CGFloat newOpacityVal = 0.0f;
		
		if (animated) {
			CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			animation.fromValue = @(self.viewLayer.opacity);
			animation.toValue = @(newOpacityVal);
			animation.duration = 0.6f;
			animation.autoreverses = NO;
			self.viewLayer.opacity = newOpacityVal;
		    [self.viewLayer addAnimation:animation forKey:@"opacity"];
		}
		else {
			self.viewLayer.opacity = newOpacityVal;
		}
	}
}

@end
