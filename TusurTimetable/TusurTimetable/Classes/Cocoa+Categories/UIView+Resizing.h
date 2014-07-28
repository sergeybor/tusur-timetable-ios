//
//  UIView+Resizing.h
//  
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_Resizing)

- (void)setHeight:(float)newHeight;
- (void)setWidth:(float)newWidth;
- (void)setX:(float)newX;
- (void)setY:(float)newY;
- (void)changeHeight:(float)dHeight;
- (void)changeWidth:(float)dWidth;
- (void)changeX:(float)dX;
- (void)changeY:(float)dY;
- (void)setPos:(CGPoint)pos;
- (void)setSize:(CGSize)size;
- (void)changeXWithFixedRight:(float)dx;
- (void)setRightBottomY:(float)y;

@end
