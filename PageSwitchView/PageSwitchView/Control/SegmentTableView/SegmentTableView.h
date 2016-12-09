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

@end
@protocol SegmentTableViewDelegate <NSObject>
@optional

-(BOOL)segmentTableView:(SegmentTableView*)tableView willSelectAtIndex:(NSUInteger)index;
-(void)segmentTableView:(SegmentTableView*)tableView didSelectAtIndex:(NSUInteger)index;
-(NSUInteger)maxTitleCountInSegmentTableView:(SegmentTableView*)tableView cellSpace:(CGFloat)cellSpace;
@required

@end

@interface SegmentTableView : UIView

@property (nonatomic) UIFont *titleFont;
@property (nonatomic) CGFloat titleLabelWidth;
@property (nonatomic) UIColor *normalTitleColor;
@property (nonatomic) UIColor *selectedTitleColor;
@property (nonatomic) id<SegmentTableViewDelegate> delegate;
@property (nonatomic) id<SegmentTableViewDataSource> dataSource;
@property (nonatomic) SegmentSelectedStyle selectedStyle;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic,readonly) UITableView   *tableView;

-(void)adjustCurrentIndex:(NSUInteger)currentIndex;

-(void)handoverWithLeftPageIndex:(NSUInteger)leftPageIndex leftScale:(CGFloat)leftScale rightPageIndex:(NSUInteger)rightPageIndex rightScale:(CGFloat)rightScale;

-(void)reloadData;

@end
