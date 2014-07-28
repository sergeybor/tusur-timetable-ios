//
//  UIView+Resizing.m
//
//

#import "UIView+Resizing.h"

@implementation UIView (UIView_Resizing)

- (void)setPos:(CGPoint)pos {
    
    CGRect r = self.frame;
    r.origin = pos;
    self.frame = r;
}

- (void)setHeight:(float)newHeight {
    
    CGRect r = self.frame;
    r.size.height = newHeight;
    self.frame = r;
}
- (void)setWidth:(float)newWidth {
    
    CGRect r = self.frame;
    r.size.width = newWidth;
    self.frame = r;
}

- (void)setSize:(CGSize)size {
    
    CGRect r = self.frame;
    r.size = size;
    self.frame = r;
}

- (void)setX:(float)newX {
    
    CGRect r = self.frame;
    r.origin.x = newX;
    self.frame = r;
}

- (void)setY:(float)newY {
    
    CGRect r = self.frame;
    r.origin.y = newY;
    self.frame = r;
}

- (void)changeHeight:(float)dHeight {

    CGRect r = self.frame;
    r.size.height += dHeight;
    self.frame = r;
}

- (void)changeWidth:(float)dWidth {

    CGRect r = self.frame;
    r.size.width += dWidth;
    self.frame = r;
}

- (void)changeX:(float)dX {
    
    CGRect r = self.frame;
    r.origin.x += dX;
    self.frame = r;
}

- (void)changeY:(float)dY {

    CGRect r = self.frame;
    r.origin.y += dY;
    self.frame = r;
}

- (void)changeXWithFixedRight:(float)dx {
    
    CGRect r = self.frame;
    r.origin.x += dx;
    r.size.width -= dx;
    self.frame = r;
}

- (void)setRightBottomY:(float)y {
    
    CGRect r = self.frame;
    r.origin.y = y - r.size.height;
    self.frame = r;
}

@end
