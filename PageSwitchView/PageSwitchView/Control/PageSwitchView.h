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
#import "PageSwitchViewStatic.h"
@class PageSwitchView;

@protocol PageSwitchViewDataSource<NSObject>

@required

- (NSArray<PageSwitchItem*> *)pageSwitchItemsInPageSwitchView:(PageSwitchView *)pageSwitchView;

@optional
-(UIView*)viewForPageTitleViewInPageSwitchView:(PageSwitchView *)pageSwitchView atPageIndex:(NSUInteger)index;

- (UIView *)viewForHeaderInPageSwitchView:(PageSwitchView *)pageSwitchView;

- (void)pageSwitchView:(PageSwitchView *)pageSwitchView emptyPageContentView:(UIContentView*)contentView isReuse:(BOOL)isReuse;


/**
  是否是黏性头部

 @param pageSwitchView <#pageSwitchView description#>
 @return <#return value description#>
 */
- (BOOL)stretchingHeaderInPageSwitchView:(PageSwitchView *)pageSwitchView;

/**
 滑动顶部

 @param pageSwitchView <#pageSwitchView description#>
 @return <#return value description#>
 */
- (CGFloat)topeSpaceInPageSwitchView:(PageSwitchView *)pageSwitchView;

- (CGFloat)titleHeightInPageSwitchView:(PageSwitchView *)pageSwitchView;



-(UITableViewCell *)pageSwitchView:(PageSwitchView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(NSUInteger)numberOfSectionsInTableView:(PageSwitchView *)tableView;

-(NSUInteger)pageSwitchView:(PageSwitchView *)pageSwitchView numberOfRowsInSection:(NSInteger)section;

-(UIView *)pageSwitchView:(PageSwitchView *)pageSwitchView viewForHeaderInSection:(NSInteger)section;

-(CGFloat)pageSwitchView:(PageSwitchView *)pageSwitchView heightForHeaderInSection:(NSInteger)section;

-(CGFloat)pageSwitchView:(PageSwitchView *)pageSwitchView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

-(NSArray*)selectedImageInTitleAtPageSwitchView:(PageSwitchView *)pageSwitchView;

-(UIColor*)bgColorInTitleAtPageSwitchView:(PageSwitchView *)pageSwitchView;


@end

@protocol PageSwitchViewDelegate<NSObject>

@optional

- (void)pageSwitchView:(PageSwitchView *)pageSwitchView movedToPageIndex:(NSUInteger)index;

- (void)pageSwitchView:(PageSwitchView *)pageSwitchView movingAtPageIndex:(NSUInteger)index;

- (void)pageSwitchView:(PageSwitchView *)pageSwitchView headerDisplayProgress:(CGFloat)progress;

- (void)pageSwitchViewDidScroll:(PageSwitchView *)pageSwitchView contentOffset:(CGPoint)contentOffset velocity:(CGPoint)velocity;

-(void)pageSwitchView:(PageSwitchView *)pageSwitchView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;




@end

@interface PageSwitchView : UIView
@property (nonatomic,weak) id<PageSwitchViewDataSource>dataSource;
@property (nonatomic,weak) id<PageSwitchViewDelegate>delegate;
@property (nonatomic,readonly) UITableView *tableView;
@property (nonatomic) UIFont *titleFont;
@property (nonatomic) UIColor *normalTitleColor;
@property (nonatomic) UIColor *selectedTitleColor;
@property (nonatomic) SegmentSelectedStyle titleSelectedStyle;
@property (nonatomic) BOOL titleCellSpace;//是否显示间距 10个点

@property (nonatomic) NSUInteger maxTitleCount;//同时显示最多标题数，0时候不限制
@property (nonatomic) BOOL adaptFull_maxTitleCount;//maxTitleCount不为0的时候设置标题占满标题栏
@property (nonatomic) UIColor* titleCellSelectColor;//选中态样式颜色

@property (nonatomic) BOOL horizontalScrollEnabled;
@property (nonatomic, readonly) UIViewController* currentViewController;

/**
 设置位于父试图的约束
 
 @param inserts 上下左右距离
 */
-(void)layoutWithinserts:(UIEdgeInsets)inserts;

-(void)switchNewPageWithNewIndex:(NSUInteger)newIndex;

-(void)switchNewPageWithTitle:(NSString*)title;

/**
 设置红点（当前页只能取消红点）
 
 @param number 小于0时候显示红点不显示数字，等于0时候不显示红点，大于0时候显示红点和数字
 @param index 下标
 */
-(void)setNumber:(NSInteger)number atIndex:(NSUInteger)index;
/**
 设置红点（当前页只能取消红点）
 
 @param number 小于0时候显示红点不显示数字，等于0时候不显示红点，大于0时候显示红点和数字
 @param title 标题
 */
-(void)setNumber:(NSInteger)number atTitle:(NSString*)title;


-(void)reloadData;

-(void)scrollToTopWithCompletion:(void(^)())completion;

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

@end
