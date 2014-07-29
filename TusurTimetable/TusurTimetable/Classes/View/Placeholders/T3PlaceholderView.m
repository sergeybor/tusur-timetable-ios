//
//  T3Placeholder.m
//  TusurTimetable
//
//  Created by Katte on 27.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3PlaceholderView.h"
#import "UIView+Resizing.h"

NSString * const T3PlaceholderMessage = @"PHMessage";
NSString * const T3PlaceholderDescription = @"PHDescription";
NSString * const T3PlaceholderButtonTitle = @"PHButtonTitle";
NSString * const T3PlaceholderButtonIcon = @"PHButtonIcon";


const CGFloat T3PVDescriptionTopMargin = 15.0f;
const CGFloat T3PVButtonTopMargin = 30.0f;

const CGFloat T3MinIconAndTextButtonWidth = 244.0f;
const CGFloat T3MaxIconAndTextButtonWidth = 244.0f;

const CGFloat T3PVButtonHorizInsets = 5.0f;
const CGFloat T3PVButtonIconTextSpace = 4.0f;
const CGFloat T3PVButtonTitleBottomInsetCorrection = 3.0f;

@interface T3PlaceholderView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation T3PlaceholderView

+ (T3PlaceholderView *)placeholderWithParams:(NSDictionary *)params
{
    return [self placeholderWithParams:params buttonTapBlock:nil];
}

+ (T3PlaceholderView *)placeholderWithParams:(NSDictionary *)params
                               buttonTapBlock:(T3PlaceholderButtonTapBlock)buttonTapBlock
{
	T3PlaceholderView *placeholder = [[NSBundle mainBundle] loadNibNamed:@"T3PlaceholderView" owner:nil options:nil][0];
	placeholder.buttonTapBlock = buttonTapBlock;
	
	[placeholder setupWithParams:params];
    
	return placeholder;
}

+ (T3PlaceholderView *)placeholderWithFrame:(CGRect)frameRect
                                      params:(NSDictionary *)params
                              buttonTapBlock:(T3PlaceholderButtonTapBlock)buttonTapBlock
{
	T3PlaceholderView *placeholder = [[NSBundle mainBundle] loadNibNamed:@"T3PlaceholderView" owner:nil options:nil][0];
	placeholder.frame = frameRect;
	placeholder.buttonTapBlock = buttonTapBlock;
	
	[placeholder setupWithParams:params];
    
	return placeholder;
}

+ (void)showError:(NSError *)error inView:(UIView *)hostView buttonTapBlock:(T3PlaceholderButtonTapBlock)buttonTapBlock
{
    NSDictionary *params = @{T3PlaceholderMessage  :@"Ошибка",
                             T3PlaceholderDescription:error.localizedDescription,
                             T3PlaceholderButtonTitle:NSLocalizedStringFromTable(@"Try again", @"Errors", nil)
                             };
    
    return [T3PlaceholderView showInView:hostView withParams:params buttonTapBlock:buttonTapBlock];
}

+ (void)showInView:(UIView *)hostView withParams:(NSDictionary *)params
{
	[T3PlaceholderView showInView:hostView withParams:params buttonTapBlock:nil];
}

+ (void)showInView:(UIView *)hostView withParams:(NSDictionary *)params buttonTapBlock:(T3PlaceholderButtonTapBlock)buttonTapBlock
{
    CGRect rect = CGRectMake(0, 0, hostView.frame.size.width, hostView.frame.size.height);
	T3PlaceholderView *placeholder = [T3PlaceholderView placeholderWithFrame:rect
                                                                        params:params
                                                                buttonTapBlock:buttonTapBlock];
	
	[hostView addSubview:placeholder];
}

+ (void)hideFromView:(UIView *)hostView
{
	UIView *placeholderToHide = nil;
	
	for (UIView *view in hostView.subviews) {
		if ([view isKindOfClass:[T3PlaceholderView class]]) {
			placeholderToHide = view;
			break;
		}
	}
	
	[placeholderToHide removeFromSuperview];
}

+ (void)hideAllFromView:(UIView *)hostView
{
	NSMutableArray *placeholdersToHide = [NSMutableArray array];
	for (UIView *view in hostView.subviews) {
		if ([view isKindOfClass:[T3PlaceholderView class]]) {
			[placeholdersToHide addObject:view];
		}
	}
	
	[placeholdersToHide makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

+ (BOOL)isAlreadyShownInView:(UIView *)hostView {
    
	for (UIView *view in hostView.subviews) {
		if ([view isKindOfClass:[T3PlaceholderView class]]) {
			return YES;
		}
	}
    return NO;
}

- (void)setupWithParams:(NSDictionary *)params
{
    
	[self setupLabel:self.titleLabel withText:params[T3PlaceholderMessage]];
	[self setupLabel:self.descriptionLabel withText:params[T3PlaceholderDescription]];
//	[self setupButton:self.button
//            withTitle:params[T3PlaceholderButtonTitle]
//                 icon:params[T3PlaceholderButtonIcon]];
	
	[self performLayout];
}

- (void)setupLabel:(UILabel *)label withText:(NSString *)text
{
	BOOL textExists = (text != nil);
	label.hidden = !textExists;
	if (textExists) {
		label.text = text;
	}
}

- (void)setupButton:(UIButton *)button withTitle:(NSString *)title icon:(UIImage *)icon
{
	BOOL buttonExists = NO;
	
	if (title != nil) {
		buttonExists = YES;
		[button setTitle:title forState:UIControlStateNormal];
	}
	
	if (icon != nil) {
		buttonExists = YES;
		[button setImage:icon forState:UIControlStateNormal];
	}
	
	button.hidden = !buttonExists;
	
	if (buttonExists) {
		if (title != nil && icon != nil) {
			
			CGFloat inset = T3PVButtonIconTextSpace / 2.0f;
			
			button.titleEdgeInsets = UIEdgeInsetsMake(0, inset, T3PVButtonTitleBottomInsetCorrection, 0);
			button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, inset);
		}
		else {
			button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, T3PVButtonTitleBottomInsetCorrection, 0);
			button.imageEdgeInsets = UIEdgeInsetsZero;
		}
	}
}


- (void)performLayout
{
    //  [self.titleLabel sizeToFit];
    //	[self.descriptionLabel sizeToFit];
	[self correctButtonWidth];
	
	CGFloat contentHeight = [self centerPartHeight];
	CGFloat totalWidth = self.frame.size.width;
	CGFloat totalHeight = self.frame.size.height;
	
	// placing titleLabel
	CGRect titleRect = self.titleLabel.frame;
	titleRect.origin.x = floorf((totalWidth - titleRect.size.width)/2);
	titleRect.origin.y = floorf((totalHeight - contentHeight)/2);
	self.titleLabel.frame = titleRect;
	
	// placing descriptionLabel if it is visible
	CGFloat yOrigin = titleRect.origin.y + titleRect.size.height;
	if (!self.descriptionLabel.hidden) {
		yOrigin += T3PVDescriptionTopMargin;
		CGRect descRect = self.descriptionLabel.frame;
		descRect.origin.x = floorf((totalWidth - descRect.size.width)/2);
		descRect.origin.y = floorf(yOrigin);
		self.descriptionLabel.frame = descRect;
		yOrigin += descRect.size.height;
	}
	
	// placing button if it is visible
	if (!self.button.hidden) {
		yOrigin += T3PVButtonTopMargin;
		CGRect buttonRect = self.button.frame;
		buttonRect.origin.x = floorf((totalWidth - buttonRect.size.width)/2);
		buttonRect.origin.y = floorf(yOrigin);
		self.button.frame = buttonRect;
	}
}

- (void)correctButtonWidth
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};

    CGRect rect = [self.button.titleLabel.text boundingRectWithSize:CGSizeMake(200.0, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    
	CGFloat textWidth = rect.size.width;
	CGFloat iconWidth = self.button.imageView.frame.size.width;
	CGFloat newWidth = MAX(iconWidth + textWidth + 2 * T3PVButtonHorizInsets
                           + T3PVButtonIconTextSpace, T3MinIconAndTextButtonWidth);
	newWidth = MIN(newWidth, T3MaxIconAndTextButtonWidth);
    
	[self.button setWidth:newWidth];
}

- (CGFloat)centerPartHeight
{
	CGFloat totalHeight = self.titleLabel.frame.size.height;
	
	if (!self.descriptionLabel.hidden) {
		totalHeight += T3PVDescriptionTopMargin + self.descriptionLabel.frame.size.height;
	}
	
	if (!self.button.hidden) {
		totalHeight += T3PVButtonTopMargin + self.button.frame.size.height;
	}
	
	return totalHeight;
}

- (IBAction)onButtonClick:(id)sender
{
    if (self.buttonTapBlock) {
		self.buttonTapBlock(sender);
	}
}


@end
