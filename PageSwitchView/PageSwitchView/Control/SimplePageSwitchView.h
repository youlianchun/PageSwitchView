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

- (BOOL)adaptTitleWidthInPageSwitchView:(SimplePageSwitchView *)pageSwitchView;


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

-(void)layoutWithinserts:(UIEdgeInsets)inserts;

-(void)switchNewPageWithNewIndex:(NSUInteger)newIndex;

-(void)switchNewPageWithTitle:(NSString*)title;

-(void)reloadData;

@end
