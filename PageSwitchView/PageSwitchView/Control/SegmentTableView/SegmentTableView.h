//
//  SegmentTableView.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/14.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageSwitchViewStatic.h"
@class SegmentTableView;

@protocol SegmentTableViewDataSource <NSObject>

-(NSArray<NSString*>*)titlesOfRowInTableView:(SegmentTableView*)tableView;

//@optional
//-(NSInteger)numberOfMarkWithTitle:(NSString*)title andIndex:(NSUInteger)index;
@end
@protocol SegmentTableViewDelegate <NSObject>
@optional

-(BOOL)segmentTableView:(SegmentTableView*)tableView willSelectAtIndex:(NSUInteger)index;
-(void)segmentTableView:(SegmentTableView*)tableView didSelectAtIndex:(NSUInteger)index;

@required

@end

@interface SegmentTableView : UIView

@property (nonatomic) UIFont *titleFont;
@property (nonatomic) UIColor *normalTitleColor;
@property (nonatomic) UIColor *selectedTitleColor;
@property (nonatomic) id<SegmentTableViewDelegate> delegate;
@property (nonatomic) id<SegmentTableViewDataSource> dataSource;
@property (nonatomic) SegmentSelectedStyle selectedStyle;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic,readonly) UITableView *tableView;
@property (nonatomic) BOOL allowCellSpace;//是否显示间距 10个点
@property (nonatomic) NSUInteger maxTitleCount;//同时显示最多标题数，0时候不限制
@property (nonatomic) BOOL adaptFull_maxTitleCount;//maxTitleCount不为0的时候设置标题占满标题栏

@property (nonatomic) NSArray *selectedBgImage;
@property (nonatomic) UIColor *bgColor;


@property (nonatomic) UIColor* selectColor;//选中态样式颜色

-(void)setNumber:(NSInteger)number atIndex:(NSUInteger)index;

-(void)adjustCurrentIndex:(NSUInteger)currentIndex;

-(void)handoverWithLeftPageIndex:(NSUInteger)leftPageIndex leftScale:(CGFloat)leftScale rightPageIndex:(NSUInteger)rightPageIndex rightScale:(CGFloat)rightScale;

-(void)reloadData;

@end
