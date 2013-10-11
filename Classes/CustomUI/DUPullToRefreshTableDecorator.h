//
//  DUPullToRefreshTableDecorator.h
//  DevedUp
//
//  Created by David Casserly on 26/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
    Usage:
 
 
 _dragToRefreshTableDecorator = [[DragToRefreshTableDecorator alloc] initWithTableView:table twoStageDrag:YES];
 _dragToRefreshTableDecorator.delegate = self;
 
 
 #pragma mark - DragToRefresh
 
 - (void) dragToRefreshTableViewShouldQuickRefresh:(DragToRefreshTableDecorator *)dragTable {
 if ([_usageController isSyncInProgress]) {
 (@"NOT SYNCING WHILST IN PROGRESS***************************** ");
 return;
 }
 [_usageController synchronizeWithFlurryForceFullSync:NO];
 }
 
 - (void) dragToRefreshTableViewShouldFullRefresh:(DragToRefreshTableDecorator *)dragTable {
 if ([_usageController isSyncInProgress]) {
 (@"NOT SYNCING WHILST IN PROGRESS***************************** ");
 return;
 }
 [_usageController synchronizeWithFlurryForceFullSync:YES];
 }
 
 
 #pragma mark - ScrollViewDelegate (part of the TableViewDelegate)
 
 - (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
 [_dragToRefreshTableDecorator scrollViewWillBeginDragging:scrollView];
 }
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 [_dragToRefreshTableDecorator scrollViewDidScroll:scrollView];
 }
 
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
 [_dragToRefreshTableDecorator scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
 }
 
 
 */

//#import <Foundation/Foundation.h>
//#import "RefreshArrowView.h"
//#import <QuartzCore/QuartzCore.h>
//
//#define REFRESH_HEADER_HEIGHT 52.0f
//
//@protocol DUPulltoRefreshTableDelegate;
//
//
//@interface DUPullToRefreshTableDecorator : NSObject <UIScrollViewDelegate> {
//    
//    BOOL isTwoStageDrag;
//    BOOL isLoading;
//    BOOL isDragging;
//    BOOL hasUserScrolled;
//    
//}
//
//@property (nonatomic, strong) UIScrollView *tableView;
//
//@property (nonatomic, copy) NSString *textPull;
//@property (nonatomic, copy) NSString *textRelease;
//@property (nonatomic, copy) NSString *textFullRelease;
//@property (nonatomic, copy) NSString *textLoading;
//
//@property (nonatomic, weak) id<DUPulltoRefreshTableDelegate> delegate;
//@property (nonatomic, strong, readonly) UILabel *refreshLabel;
//@property (nonatomic, strong) RefreshArrowView *refreshArrow;
//@property (nonatomic, strong) UIView *refreshHeaderView;
//
//- (id) initWithTableView:(UIScrollView *)tableView delegate:(id<DUPulltoRefreshTableDelegate>)delegate;
//- (void) refreshComplete;
//- (void) startLoadingWithQuickRefresh:(BOOL)quickRefresh;
//
//- (void)addPullToRefreshHeader;
//
//
//@end
//
//
//@protocol DUPulltoRefreshTableDelegate <NSObject>
//
//@optional
//- (void) pullToRefreshTableViewShouldRefresh:(DUPullToRefreshTableDecorator *)dragTable;
//- (void) pullToReloadTableViewShouldReload:(DUPullToRefreshTableDecorator *)dragTable;
//- (NSDate *) dragToRefreshLastSyncDate;
//- (void) pullToRefreshTableViewShouldFullRefresh:(DUPullToRefreshTableDecorator *)dragTable;
//@end
