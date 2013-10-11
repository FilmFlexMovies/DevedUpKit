//
//  DUGestureFactory.m
//  DevedUp
//
//  Created by David Casserly on 13/12/2011.
//  Copyright (c) 2011 DevedUp Ltd. All rights reserved.
//

#import "DUGestureFactory.h"

@implementation DUGestureFactory

#pragma mark - Swipes

+ (UISwipeGestureRecognizer *) addRightSwipeToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture {
    UISwipeGestureRecognizer *rightSwipeRecogniser = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:selector];
    [rightSwipeRecogniser setDelegate:target];
    rightSwipeRecogniser.numberOfTouchesRequired = 1;
    rightSwipeRecogniser.direction = UISwipeGestureRecognizerDirectionRight;
    if (gesture) {
        [rightSwipeRecogniser requireGestureRecognizerToFail:gesture];
    }
    [view addGestureRecognizer:rightSwipeRecogniser];
    return rightSwipeRecogniser;
}

+ (UISwipeGestureRecognizer *) addRightSwipeToView:(UIView *)view target:(id)target action:(SEL)selector  {
    return [self addRightSwipeToView:view target:target action:selector requireGestureToFail:nil];
}

+ (UISwipeGestureRecognizer *) addLeftSwipeToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture {
    UISwipeGestureRecognizer *leftSwipeRecogniser = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:selector];
    [leftSwipeRecogniser setDelegate:target];
    leftSwipeRecogniser.numberOfTouchesRequired = 1;
    leftSwipeRecogniser.direction = UISwipeGestureRecognizerDirectionLeft;
    if (gesture) {
        [leftSwipeRecogniser requireGestureRecognizerToFail:gesture];
    }
    [view addGestureRecognizer:leftSwipeRecogniser];
    return leftSwipeRecogniser;
}

+ (UISwipeGestureRecognizer *) addLeftSwipeToView:(UIView *)view target:(id)target action:(SEL)selector {
    return [self addLeftSwipeToView:view target:target action:selector requireGestureToFail:nil];
}

+ (UISwipeGestureRecognizer *) addTwoFingerSwipeDownToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:selector];
    [swipeGesture setDelegate:target];
    swipeGesture.numberOfTouchesRequired = 2;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    if (gesture) {
        [swipeGesture requireGestureRecognizerToFail:gesture];
    }
    [view addGestureRecognizer:swipeGesture];
    return swipeGesture;
}

+ (UISwipeGestureRecognizer *) addSwipeDownToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture {
    UISwipeGestureRecognizer *rightSwipeRecogniser = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:selector];
    [rightSwipeRecogniser setDelegate:target];
    rightSwipeRecogniser.numberOfTouchesRequired = 1;
    rightSwipeRecogniser.direction = UISwipeGestureRecognizerDirectionDown;
    if (gesture) {
        [rightSwipeRecogniser requireGestureRecognizerToFail:gesture];
    }
    [view addGestureRecognizer:rightSwipeRecogniser];
    return rightSwipeRecogniser;
}

+ (UISwipeGestureRecognizer *) addSwipeUpToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture {
    UISwipeGestureRecognizer *rightSwipeRecogniser = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:selector];
    [rightSwipeRecogniser setDelegate:target];
    rightSwipeRecogniser.numberOfTouchesRequired = 1;
    rightSwipeRecogniser.direction = UISwipeGestureRecognizerDirectionUp;
    if (gesture) {
        [rightSwipeRecogniser requireGestureRecognizerToFail:gesture];
    }
    [view addGestureRecognizer:rightSwipeRecogniser];
    return rightSwipeRecogniser;
}

#pragma mark - Taps

+ (UITapGestureRecognizer *) addFiveTapToView:(UIView *)view target:(id)target action:(SEL)selector {
	UITapGestureRecognizer *doubleTapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [doubleTapRecogniser setDelegate:target];
    doubleTapRecogniser.numberOfTouchesRequired = 1;
    doubleTapRecogniser.numberOfTapsRequired = 5;
    [view addGestureRecognizer:doubleTapRecogniser];
    return doubleTapRecogniser;
}

+ (UITapGestureRecognizer *) addDoubleTapToView:(UIView *)view target:(id)target action:(SEL)selector {
    UITapGestureRecognizer *doubleTapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [doubleTapRecogniser setDelegate:target];
    doubleTapRecogniser.numberOfTouchesRequired = 1;
    doubleTapRecogniser.numberOfTapsRequired = 2;
    [view addGestureRecognizer:doubleTapRecogniser];
    return doubleTapRecogniser;
}

+ (UITapGestureRecognizer *) addSingleTapToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture {
    UITapGestureRecognizer *singleTapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [singleTapRecogniser setDelegate:target];
    singleTapRecogniser.numberOfTouchesRequired = 1;
    singleTapRecogniser.numberOfTapsRequired = 1;
    if (gesture) {
        [singleTapRecogniser requireGestureRecognizerToFail:gesture];
    }
    [view addGestureRecognizer:singleTapRecogniser];
    return singleTapRecogniser;
}

+ (UITapGestureRecognizer *) addSingleTapToView:(UIView *)view target:(id)target action:(SEL)selector {
    return [self addSingleTapToView:view target:target action:selector requireGestureToFail:nil];
}

+ (DUTouchDownGestureRecogniser *) addTouchDownToView:(UIView *)view target:(id)target action:(SEL)selector {
    DUTouchDownGestureRecogniser *singleTapRecogniser = [[DUTouchDownGestureRecogniser alloc] initWithTarget:target action:selector];
    [singleTapRecogniser setDelegate:target];
    [view addGestureRecognizer:singleTapRecogniser];
    return singleTapRecogniser;
}

#pragma mark - Pan

+ (UIPanGestureRecognizer *) addPanToView:(UIView *)view target:(id)target action:(SEL)selector fingers:(NSUInteger)fingers requireGestureToFail:(UIGestureRecognizer *)gesture {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:selector];
    panGestureRecognizer.maximumNumberOfTouches = fingers;
    panGestureRecognizer.delegate = target;
    [view addGestureRecognizer:panGestureRecognizer];
    if (gesture) {
        [panGestureRecognizer requireGestureRecognizerToFail:gesture];
    }
    return panGestureRecognizer;
}

+ (UIPanGestureRecognizer *) addPanToView:(UIView *)view target:(id)target action:(SEL)selector fingers:(NSUInteger)fingers {
    return [self addPanToView:view target:target action:selector fingers:fingers requireGestureToFail:nil];
}

+ (UIPanGestureRecognizer *) addPanToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture {
    return [self addPanToView:view target:target action:selector fingers:1 requireGestureToFail:gesture];
}

+ (UIPanGestureRecognizer *) addPanToView:(UIView *)view target:(id)target action:(SEL)selector {
    return [self addPanToView:view target:target action:selector fingers:1];
}

+ (UIPanGestureRecognizer *) addPanTwoFingersToView:(UIView *)view target:(id)target action:(SEL)selector {
    return [self addPanToView:view target:target action:selector fingers:2];
}


#pragma mark - Pinch

+ (UIPinchGestureRecognizer *) addPinchToView:(UIView *)view target:(id)target action:(SEL)selector {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:target action:selector];
    [pinchGesture setDelegate:target];
    [view addGestureRecognizer:pinchGesture];
    return pinchGesture;
}



@end
