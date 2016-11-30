//
//  SegmentTableView.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/14.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SegmentTableView;

@protocol SegmentTableViewDataSource <NSObject>

-(NSArray<NSString*>*)titlesOfRowInTableView:(SegmentTableView*)tableView;

@end
@protocol SegmentTableViewDelegate <NSObject>
@optional

-(BOOL)segmentTableView:(SegmentTableView*)tableView willSelectAtIndex:(NSUInteger)index;
-(void)segmentTableView:(SegmentTableView*)tableView didSelectAtIndex:(NSUInteger)index;
@required

@end

@interface SegmentTableView : UIView

@property (nonatomic) UIFont *titleFont;
@property (nonatomic) CGFloat titleLabelWidth;
@property (nonatomic) UIColor *normalTitleColor;
@property (nonatomic) UIColor *selectedTitleColor;
@property (nonatomic) UIColor *normalBgColor;
@property (nonatomic) UIColor *selectedBgColor;
@property (nonatomic) id<SegmentTableViewDelegate> delegate;
@property (nonatomic) id<SegmentTableViewDataSource> dataSource;

@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic,readonly) UITableView   *tableView;

-(void)adjustCurrentIndex:(NSUInteger)currentIndex;

-(void)handoverWithLeftPageIndex:(NSUInteger)leftPageIndex leftScale:(CGFloat)leftScale rightPageIndex:(NSUInteger)rightPageIndex rightScale:(CGFloat)rightScale;

-(void)reloadData;

@end
