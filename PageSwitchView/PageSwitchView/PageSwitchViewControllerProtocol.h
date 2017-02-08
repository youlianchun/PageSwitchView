//
//  PageSwitchViewControllerProtocol.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/12.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageSwitchView.h"


@protocol SimplePageSwitchViewControllerProtocol <NSObject>
@required
- (NSArray<PageSwitchItem*> *)pageSwitchItems;
@optional
- (CGFloat)titleHeight;
- (void)movedToPageIndex:(NSUInteger)index;
- (void)movingAtPageIndex:(NSUInteger)index;
@end


@protocol PageSwitchViewControllerProtocol <SimplePageSwitchViewControllerProtocol>

@optional
- (void)emptyPageContentView:(UIContentView*)contentView isReuse:(BOOL)isReuse;
- (void)cellContentView:(UIContentView*)contentView atIndexPath:(NSIndexPath*)indexPath isReuse:(BOOL)isReuse;
-(NSUInteger)numberOfSections;
-(NSUInteger)numberOfRowsInSection:(NSInteger)section;
-(UIView *)viewForHeaderInSection:(NSInteger)section;
-(CGFloat)heightForHeaderInSection:(NSInteger)section;
-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)topeSpace;

- (void)headerDisplayProgress:(CGFloat)progress;

- (void)didScrollContentOffset:(CGPoint)contentOffset velocity:(CGPoint)velocity;

-(NSArray*)selectedImageInTitle;

-(UIColor*)bgColorInTitle;

@property (nonatomic, readonly) PageSwitchView *pageSwitchView;

@end
