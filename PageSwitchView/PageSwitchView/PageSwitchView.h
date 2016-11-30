//
//  PageSwitchView.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/11/30.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageSwitchItem.h"
@class PageSwitchView;



@protocol PageSwitchViewDataSource<NSObject>

@required


//- (UIView *)viewForSegmentInPageSwitchView:(PageSwitchView *)pageSwitchView;

//- (UIView *)pageSwitchView:(PageSwitchView *)pageSwitchView pageAtIndex:(NSUInteger)index;
//
//- (NSInteger)numberOfSectionsInPageSwitchView:(PageSwitchView *)pageSwitchView;

- (NSArray<PageSwitchItem*> *)pageSwitchItemsInPageSwitchView:(PageSwitchView *)pageSwitchView;


@optional

- (UIView *)viewForHeaderInPageSwitchView:(PageSwitchView *)pageSwitchView;

@end

@protocol PageSwitchViewDelegate<NSObject>

@optional
- (void)pageSwitchView:(PageSwitchView *)pageSwitchView movedToPageIndex:(NSUInteger)index;

- (void)pageSwitchView:(PageSwitchView *)pageSwitchView movingAtPageIndex:(NSUInteger)index;
@end

@interface PageSwitchView : UIView
@property (nonatomic,weak) id<PageSwitchViewDataSource>dataSource;
@property (nonatomic,weak) id<PageSwitchViewDelegate>delegate;
-(void)switchNewPageWithNewIndex:(NSUInteger)newIndex;
-(void)reloadData;

@end
