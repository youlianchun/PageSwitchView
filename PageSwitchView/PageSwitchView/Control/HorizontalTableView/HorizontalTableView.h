//
//  PagingTableView.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/9.
//  Copyright © 2016年 ylchun. All rights reserved.
//  内部有一个水平滚动table

#import <UIKit/UIKit.h>
#import "UIContentView.h"
NS_ASSUME_NONNULL_BEGIN

@class HorizontalTableView;
@protocol HorizontalTableViewDataSource<NSObject>

-(NSUInteger)numberOfRowInTableView:(HorizontalTableView*)tableView;

- (void)tableView:(HorizontalTableView*)tableView cellContentView:(UIContentView*)contentView atRowIndex:(NSUInteger )rowIndex isReuse:(BOOL)isReuse;

@optional
-(CGFloat)cellSpaceInTableView:(HorizontalTableView*)tableView;
@end

@protocol HorizontalTableViewDelegate<NSObject>

@optional
-(void)tableView:(HorizontalTableView *)tableView willDisplayCellView:(UIContentView *)contentView atRowIndex:(NSUInteger )rowIndex;

-(void)tableView:(HorizontalTableView *)tableView didEndDisplayingCellView:(UIContentView *)contentView atRowIndex:(NSUInteger )rowIndex;

-(void)tableView:(HorizontalTableView *)tableView didScrollWithLeftPageIndex:(NSUInteger)leftPageIndex leftScale:(CGFloat)leftScale rightPageIndex:(NSUInteger)rightPageIndex rightScale:(CGFloat)rightScale;

-(void)tableView:(HorizontalTableView *)tableView didScrollToPageIndex:(NSUInteger)index;

@end


@interface HorizontalTableView : UIView

@property (nonatomic, readonly) UITableView *tableView;

@property (nonatomic, readonly) NSUInteger currentPageIndex;

@property (nonatomic, weak) id <HorizontalTableViewDataSource> dataSource;
@property (nonatomic, weak) id <HorizontalTableViewDelegate> delegate;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (void)reloadData;

- (void)scrollToRowAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
