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

static const CGFloat cellSpace_2 = 5;

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
@property (nonatomic) BOOL allowCellSpace;
@property (nonatomic) NSUInteger maxTitleCount;
@property (nonatomic) BOOL adaptFull_maxTitleCount;

@property (nonatomic) UIColor* selectColor;

-(void)setNumber:(NSInteger)number atIndex:(NSUInteger)index;

-(void)adjustCurrentIndex:(NSUInteger)currentIndex;

-(void)handoverWithLeftPageIndex:(NSUInteger)leftPageIndex leftScale:(CGFloat)leftScale rightPageIndex:(NSUInteger)rightPageIndex rightScale:(CGFloat)rightScale;

-(void)reloadData;

@end
