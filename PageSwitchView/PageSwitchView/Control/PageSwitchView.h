//
//  PageSwitchView.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/11/30.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageSwitchItem.h"
#import "UIContentView.h"
@class PageSwitchView;

@protocol PageSwitchViewDataSource<NSObject>

@required

- (NSArray<PageSwitchItem*> *)pageSwitchItemsInPageSwitchView:(PageSwitchView *)pageSwitchView;

@optional

- (UIView *)viewForHeaderInPageSwitchView:(PageSwitchView *)pageSwitchView;

- (BOOL)stretchingHeaderInPageSwitchView:(PageSwitchView *)pageSwitchView;
- (BOOL)adaptTitleWidthInPageSwitchView:(PageSwitchView *)pageSwitchView;

/**
 滑动顶部

 @param pageSwitchView <#pageSwitchView description#>
 @return <#return value description#>
 */
- (CGFloat)topeSpaceInPageSwitchView:(PageSwitchView *)pageSwitchView;

- (CGFloat)titleHeightInPageSwitchView:(PageSwitchView *)pageSwitchView;



- (void)pageSwitchView:(PageSwitchView *)pageSwitchView cellContentView:(UIContentView*)contentView atIndexPath:(NSIndexPath*)indexPath isReuse:(BOOL)isReuse;

-(NSUInteger)numberOfSectionsInTableView:(PageSwitchView *)tableView;

-(NSUInteger)pageSwitchView:(PageSwitchView *)pageSwitchView numberOfRowsInSection:(NSInteger)section;

-(UIView *)pageSwitchView:(PageSwitchView *)pageSwitchView viewForHeaderInSection:(NSInteger)section;

-(CGFloat)pageSwitchView:(PageSwitchView *)pageSwitchView heightForHeaderInSection:(NSInteger)section;

-(CGFloat)pageSwitchView:(PageSwitchView *)pageSwitchView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol PageSwitchViewDelegate<NSObject>

@optional

- (void)pageSwitchView:(PageSwitchView *)pageSwitchView movedToPageIndex:(NSUInteger)index;

- (void)pageSwitchView:(PageSwitchView *)pageSwitchView movingAtPageIndex:(NSUInteger)index;

- (void)pageSwitchView:(PageSwitchView *)pageSwitchView headerDisplayProgress:(CGFloat)progress;

//topeSpace<0时候才有调用
-(void)pageSwitchView:(PageSwitchView *)pageSwitchView titleBarDisplayProgress:(CGFloat)progress;

- (void)pageSwitchViewDidScroll:(PageSwitchView *)pageSwitchView;


@end

@interface PageSwitchView : UIView
@property (nonatomic,weak) id<PageSwitchViewDataSource>dataSource;
@property (nonatomic,weak) id<PageSwitchViewDelegate>delegate;
@property (nonatomic,readonly) UITableView *tableView;
-(void)layoutWithinserts:(UIEdgeInsets)inserts;

-(void)switchNewPageWithNewIndex:(NSUInteger)newIndex;

-(void)switchNewPageWithTitle:(NSString*)title;

-(void)reloadData;

@end
