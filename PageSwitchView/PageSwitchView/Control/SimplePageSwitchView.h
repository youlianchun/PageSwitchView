//
//  SimplePageSwitchView.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/8.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageSwitchItem.h"
#import "PageSwitchViewStatic.h"

@class SimplePageSwitchView;

@protocol SimplePageSwitchViewDataSource<NSObject>

@required

- (NSArray<PageSwitchItem*> *)pageSwitchItemsInPageSwitchView:(SimplePageSwitchView *)pageSwitchView;

@optional


- (CGFloat)titleHeightInPageSwitchView:(SimplePageSwitchView *)pageSwitchView;

@end

@protocol SimplePageSwitchViewDelegate<NSObject>

@optional

- (void)pageSwitchView:(SimplePageSwitchView *)pageSwitchView movedToPageIndex:(NSUInteger)index;

- (void)pageSwitchView:(SimplePageSwitchView *)pageSwitchView movingAtPageIndex:(NSUInteger)index;

@end

@interface SimplePageSwitchView : UIView
@property (nonatomic, assign) BOOL hoverTitleBar;
@property (nonatomic,weak) id<SimplePageSwitchViewDataSource>dataSource;
@property (nonatomic,weak) id<SimplePageSwitchViewDelegate>delegate;
@property (nonatomic) UIFont *titleFont;
@property (nonatomic) UIColor *normalTitleColor;
@property (nonatomic) UIColor *selectedTitleColor;
@property (nonatomic) SegmentSelectedStyle titleSelectedStyle;
@property (nonatomic) BOOL titleCellSpace;//是否显示间距 10个点
@property (nonatomic) UIColor* titleCellSelectColor;//选中态样式颜色

@property (nonatomic) NSUInteger maxTitleCount;//同时显示最多标题数，0时候不限制
@property (nonatomic) BOOL adaptFull_maxTitleCount;//maxTitleCount不为0的时候设置标题占满标题栏

@property (nonatomic, readonly) UIViewController* currentViewController;
@property (nonatomic, readonly) id pageContentView;

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

@end
