//
//  DUPullToRefreshTableDecorator.m
//  DevedUp
//
//  Created by David Casserly on 26/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//#import "DUPullToRefreshTableDecorator.h"
//#import "InternetConnectionController.h"
//#import "DULocalisation.h"
//
//@interface DUPullToRefreshTableDecorator ()  {
//    
//    
//}
//
//
//
//@property (nonatomic, strong) UILabel *refreshLabel;
//
//@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
//@end
//
//@implementation DUPullToRefreshTableDecorator
//
//@synthesize tableView = _tableView;
//@synthesize delegate = _delegate;
//@synthesize textPull = _textPull;
//@synthesize textLoading = _textLoading;
//@synthesize textRelease = _textRelease;
//@synthesize textFullRelease = _textFullRelease;
//@synthesize refreshArrow = _refreshArrow;
//@synthesize refreshLabel = _refreshLabel;
//@synthesize refreshHeaderView = _refreshHeaderView;
//@synthesize refreshSpinner = _refreshSpinner;
//
//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//- (id) initWithTableView:(UIScrollView *)tableView delegate:(id<DUPulltoRefreshTableDelegate>)delegate {
//    self = [super init];
//    if (self) {
//        self.delegate = delegate;
//        self.tableView = tableView;
//        isTwoStageDrag = NO;
//        
//        [self configureLabelText];        
//        [self addPullToRefreshHeader];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureLabelText) name:NoInternetConnectionNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureLabelText) name:InternetConnectionActiveNotification object:nil];
//    }
//    return self;
//}
//
//#pragma mark - Setup Table
//
//- (void) configureLabelText {
//    if ([InternetConnectionController sharedInstance].isConnected) {
//        self.textPull = DULocalizedString(@"Pull down to reload ...", @"");
//        
//        NSString *releaseString = DULocalizedString(@"Release now to reload ...", @"");
//        
//        if (isTwoStageDrag) {
//            releaseString = [releaseString stringByAppendingString:DULocalizedString(@"\nPull down to full reload ...", @"")];
//        } else {
//            releaseString = DULocalizedString(@"Release now to reload ...", @"");
//        }
//        self.textRelease = releaseString;
//        self.textFullRelease = DULocalizedString(@"Release now to full reload ...", @"");
//        self.textLoading = DULocalizedString(@"Reloading ...", @"");
//    } else {
//        self.textPull = DULocalizedString(@"No Active Internet Connection", @"");
//        self.textRelease = DULocalizedString(@"Connect to a network to reload", @"");
//        self.textFullRelease = DULocalizedString(@"Connect to a network to reload", @"");
//        self.textLoading = @"";
//    }
//    
//}
//
//- (void)addPullToRefreshHeader {
//    
//    CGFloat width = self.tableView.frame.size.width;
//    
//    [self.refreshHeaderView removeFromSuperview];
//    self.refreshHeaderView = [[UIView alloc] initWithFrame:[self refreshHeaderFrame]];
//    self.refreshHeaderView.backgroundColor = [UIColor clearColor];
//    self.refreshHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    
//    [self.refreshLabel removeFromSuperview];
//    self.refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, REFRESH_HEADER_HEIGHT)];
//    self.refreshLabel.backgroundColor = [UIColor clearColor];
//    self.refreshLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:12.0f];
//    self.refreshLabel.textAlignment = NSTextAlignmentCenter;
//    self.refreshLabel.numberOfLines = 0;
//    self.refreshLabel.lineBreakMode = UILineBreakModeWordWrap;
//    self.refreshLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    
//    UIColor *color = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
//    //UIColor *color = [UIColor colorWithRed:211.0f/255.0f green:211.0f/255.0f blue:211.0f/255.0f alpha:1.0f];
//    CGFloat arrowWidth = 20;
//    CGFloat arrowHeight = 30;
//    [self.refreshArrow removeFromSuperview];
//    self.refreshArrow = [[RefreshArrowView alloc] initWithFrame:CGRectMake(floorf((REFRESH_HEADER_HEIGHT - arrowWidth) / 2),
//                                                                      (floorf(REFRESH_HEADER_HEIGHT - arrowHeight) / 2),
//                                                                            arrowWidth, arrowHeight) startColor:color];
//    
//    [self.refreshSpinner removeFromSuperview];
//    self.refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    self.refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
//    self.refreshSpinner.hidesWhenStopped = YES;
//    
//    [self.refreshHeaderView removeFromSuperview];
//    [self.refreshHeaderView addSubview:self.refreshLabel];
//    [self.refreshHeaderView addSubview:self.refreshArrow];
//    [self.refreshHeaderView addSubview:self.refreshSpinner];
//    [self.tableView addSubview:self.refreshHeaderView];
//    
//    LogCGRect(self.tableView.frame);
//}
//
//
//- (CGRect) refreshHeaderFrame {
//    CGFloat width = self.tableView.frame.size.width;
//    return CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, width, REFRESH_HEADER_HEIGHT);
//}
//
//- (UIEdgeInsets) loadingEdgeInsets {
//    return UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
//}
//
//#pragma mark - ScrollView Drag
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if (isLoading) {
//        return;
//    }
//    isDragging = YES;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    hasUserScrolled = YES;
//    if (isLoading) {
//        // Update the content inset, good for section headers
//        if (scrollView.contentOffset.y > 0)
//            self.tableView.contentInset = UIEdgeInsetsZero;
//        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
//            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (isDragging && scrollView.contentOffset.y < 0) {
//        // Update the arrow direction and label
//        [UIView beginAnimations:nil context:NULL];
//        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT * 1.75) {
//            if (isTwoStageDrag) {
//                self.refreshLabel.text = self.textFullRelease;
//                [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
//            }
//        } else if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
//            // User is scrolling above the header
//            self.refreshLabel.text = self.textRelease;
//            [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
//        } else { // User is scrolling somewhere within the header
//            self.refreshLabel.text = self.textPull;
//            [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * -2, 0, 0, 1);
//        }
//        [UIView commitAnimations];
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (isLoading) return;
//    isDragging = NO;
//    if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT * 1.75) {
//        if (isTwoStageDrag) {
//            [self startLoadingWithQuickRefresh:NO];
//        } else {
//            [self startLoadingWithQuickRefresh:YES];
//        }
//    } else if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
//        // Released above the header
//        [self startLoadingWithQuickRefresh:YES];
//    }
//    
//}
//
//#pragma mark - UI Changes to Drag Events
//
//- (void) startLoadingWithQuickRefresh:(BOOL)quickRefresh {
//    
//    if (![InternetConnectionController sharedInstance].isConnected) {
//        //If not connection to internet - then don't activate the drag to refresh!
//        return;
//    }
//    
//    isLoading = YES;
//    
//    // Show the header
//    [UIView animateWithDuration:0.3 
//                          delay:0 
//                        options:UIViewAnimationCurveLinear 
//                     animations:^{
//                         self.tableView.contentInset = [self loadingEdgeInsets];
//                         self.refreshLabel.text = self.textLoading;
//                         self.refreshArrow.hidden = YES;
//                         [self.refreshSpinner startAnimating];
//                     } 
//                     completion:nil];
//    
//    [self informDelegate];
//    
//    
//}
//
//- (void) informDelegate {
//    // Refresh action!
// 
//        if ([self.delegate respondsToSelector:@selector(pullToRefreshTableViewShouldRefresh:)]) {
//            [self.delegate pullToRefreshTableViewShouldRefresh:self];
//        }
//
//}
//
//- (void) refreshComplete {
//    isLoading = NO;
//    [UIView animateWithDuration:0.3 
//                          delay:0 
//                        options:UIViewAnimationCurveLinear 
//                     animations:^{
//                         self.tableView.contentInset = UIEdgeInsetsZero;
//                         [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * -2, 0, 0, 1);
//                     } 
//                     completion:^(BOOL finished) {
//                         // Reset the header
//                         self.refreshLabel.text = self.textPull;
//                         self.refreshArrow.hidden = NO;
//                         [self.refreshSpinner stopAnimating];
//                     }];
//    
//}
//
//
//
//@end
