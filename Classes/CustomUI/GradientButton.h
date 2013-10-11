#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface GradientButton : UIButton  {
	@private
	
	UIColor	*gradient1TopColour;
	UIColor *gradient1BottomColour;
	UIColor *gradient2TopColour;
	UIColor *gradient2BottomColour;
    CGFloat _alphaWhenEnabled;
    CGFloat _alphaWhenDisabled;
}

@property (nonatomic, strong) UIColor *gradient1TopColour;
@property (nonatomic, strong) UIColor *gradient1BottomColour;
@property (nonatomic, strong) UIColor *gradient2TopColour;
@property (nonatomic, strong) UIColor *gradient2BottomColour;
@property (nonatomic, assign) CGFloat alphaWhenEnabled;
@property (nonatomic, assign) CGFloat alphaWhenDisabled;

- (void)colorWithHexEncodedColorsString:(NSString*)hexString;

+ (UIButton *) gradientButtonWithTitle:(NSString*)title width:(CGFloat)width;

@end
