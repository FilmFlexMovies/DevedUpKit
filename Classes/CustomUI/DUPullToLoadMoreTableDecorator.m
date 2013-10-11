//
//  DUPullToLoadMoreTableDecorator.m
//  DevedUp
//
//  Created by David Casserly on 29/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//#import "DUPullToLoadMoreTableDecorator.h"
//#import "InternetConnectionController.h"
//#import "DULocalisation.h"
//
//@implementation DUPullToLoadMoreTableDecorator
//
//- (void) configureLabelText {
//    if ([InternetConnectionController sharedInstance].isConnected) {
//        self.textPull = DULocalizedString(@"Pull up to load more ...", @"");
//        
//        NSString *releaseString = DULocalizedString(@"Release now to load more ...", @"");
//        
//        if (isTwoStageDrag) {
//            releaseString = [releaseString stringByAppendingString:DULocalizedString(@"\nPull up to full load ...", @"")];
//        } else {
//            releaseString = DULocalizedString(@"Release now to load more ...", @"");
//        }
//        self.textRelease = releaseString;
//        self.textFullRelease = DULocalizedString(@"Release now to full load ...", @"");
//        self.textLoading = DULocalizedString(@"Loading more ...", @"");
//    } else {
//        self.textPull = DULocalizedString(@"No Active Internet Connection", @"");
//        self.textRelease = DULocalizedString(@"Connect to a network to load more", @"");
//        self.textFullRelease = DULocalizedString(@"Connect to a network to load more", @"");
//        self.textLoading = @"";
//    }
//    
//}
//
//- (CGRect) refreshHeaderFrame {
//    CGFloat tableHeight = self.tableView.contentSize.height;
//    CGFloat width = self.tableView.frame.size.width;
//    return CGRectMake(0, tableHeight, width, REFRESH_HEADER_HEIGHT);
//}
//
//- (UIEdgeInsets) loadingEdgeInsets {
//    return UIEdgeInsetsMake(0, 0, REFRESH_HEADER_HEIGHT, 0);
//}
//
//- (void) resetPositionFooter {
//    isLoading = NO;
//    [self addPullToRefreshHeader];
//}
//
//#pragma mark - The dragging is the other way around
//
//- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
//    hasUserScrolled = YES;
//    
//    CGFloat yContentOffset = scrollView.contentOffset.y;
//    CGFloat contentHeight = scrollView.contentSize.height - self.tableView.bounds.size.height;
//    CGFloat yOffset = yContentOffset - contentHeight;
//    
//    if (isLoading) {
//        
//        
//    } else if (isDragging && yContentOffset > contentHeight) {
//        //The user has scrolled up - making the footer visible
//        //DULog(@"%f", yContentOffset);
//        [UIView beginAnimations:nil context:NULL];
//        if (yOffset > REFRESH_HEADER_HEIGHT) {
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
//    if (isLoading) {
//        return;
//    }
//    isDragging = NO;
//    
//    CGFloat yContentOffset = scrollView.contentOffset.y;
//    CGFloat contentHeight = scrollView.contentSize.height - self.tableView.bounds.size.height;  
//    CGFloat yOffset = yContentOffset - contentHeight;
//    
//    if (yOffset > REFRESH_HEADER_HEIGHT) {
//        [self startLoadingWithQuickRefresh:YES];
//    } 
//    
//}
//
//- (void) informDelegate {
//    // Refresh action!
//    
//    if ([self.delegate respondsToSelector:@selector(pullToReloadTableViewShouldReload:)]) {
//        [self.delegate pullToReloadTableViewShouldReload:self];
//    }
//    
//}
//
//- (void) noMoreToLoad {
//    isLoading = NO;
//    [self.refreshHeaderView removeFromSuperview];
//    self.refreshHeaderView = nil;
//}
//
//- (void) repositionTableScrollAfterLoad {
//    //Load more photos, then it will scroll the table grid up a bit
//    [UIView animateWithDuration:0.5 
//                          delay:0 
//                        options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGPoint currentOffset = self.tableView.contentOffset;
//                         currentOffset.y += self.tableView.bounds.size.height / 2;
//                         [self.tableView setContentOffset:currentOffset animated:NO];                         
//                     } 
//                     completion:nil];
//}
//
//@end
