//
//  SimplePageSwitchView.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/8.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageSwitchItem.h"

@class SimplePageSwitchView;

@protocol SimplePageSwitchViewDataSource<NSObject>

@required

- (NSArray<PageSwitchItem*> *)pageSwitchItemsInPageSwitchView:(SimplePageSwitchView *)pageSwitchView;

@optional

- (BOOL)adaptTitleWidthInPageSwitchView:(SimplePageSwitchView *)pageSwitchView;


- (CGFloat)titleHeightInPageSwitchView:(SimplePageSwitchView *)pageSwitchView;

@end

@protocol SimplePageSwitchViewDelegate<NSObject>

@optional

- (void)pageSwitchView:(SimplePageSwitchView *)pageSwitchView movedToPageIndex:(NSUInteger)index;

- (void)pageSwitchView:(SimplePageSwitchView *)pageSwitchView movingAtPageIndex:(NSUInteger)index;

- (void)pageSwitchView:(SimplePageSwitchView *)pageSwitchView headerDisplayProgress:(CGFloat)progress;

//topeSpace<0时候才有调用
-(void)pageSwitchView:(SimplePageSwitchView *)pageSwitchView titleBarDisplayProgress:(CGFloat)progress;


@end

@interface SimplePageSwitchView : UIView
@property (nonatomic,weak) id<SimplePageSwitchViewDataSource>dataSource;
@property (nonatomic,weak) id<SimplePageSwitchViewDelegate>delegate;

-(void)layoutWithinserts:(UIEdgeInsets)inserts;

-(void)switchNewPageWithNewIndex:(NSUInteger)newIndex;

-(void)switchNewPageWithTitle:(NSString*)title;

-(void)reloadData;

@end
