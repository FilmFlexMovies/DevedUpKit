//
//  DUModalProgressView.m
//
//  Created by David Casserly on 27/12/2011.
//  Copyright (c) 2011 DevedUp Ltd. All rights reserved.
//

#import "DUModalProgressView.h"
#import "DUAutolayout.h"

@interface DUModalProgressView ()
@property (nonatomic, retain) UIActivityIndicatorView *logoSpinner;
@property (nonatomic, retain) UIView *overlay;
@end

@implementation DUModalProgressView

- (void) dealloc {
    [_logoSpinner stopAnimating];
}

- (void) addSpinner {
    self.logoSpinner = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.logoSpinner.hidesWhenStopped = NO;
    self.logoSpinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.logoSpinner];
    [DUAutolayout centerSubview:self.logoSpinner inView:self];
    
    [self.logoSpinner startAnimating];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.alpha = 1.0;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.autoresizesSubviews = YES;
        
        //Overlay 
        UIView *overlayView = [[UIView alloc] initWithFrame:CGRectZero];
        overlayView.translatesAutoresizingMaskIntoConstraints = NO;
        overlayView.backgroundColor = [UIColor blackColor];
        overlayView.alpha = 0.3;
        self.overlay = overlayView;
        [DUAutolayout addSubviewAndFillBounds:overlayView toView:self];
        
        [self addSpinner];
    }
    return self;
}

- (void) showAnimatedWithOverlay:(BOOL)overlay {
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        if (overlay) {
            self.overlay.alpha = 0.3;
        }
    } completion:^(BOOL finished) {
        [self.logoSpinner startAnimating];
    }];
}

- (void) hideAnimatedWithCompletion:(void (^)(void))completionBlock {
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.overlay.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self.logoSpinner stopAnimating];
        if (completionBlock) {
            completionBlock();
        }
    }];
}

@end
