//
//  _PageSwitchView.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/5.
//  Copyright © 2016年 ylchun. All rights reserved.
//
#import "PageSwitchView.h"
@class HorizontalTableView;
@interface PageSwitchView()
@property (nonatomic) CGFloat titleHeight;
@property (nonatomic) CGFloat superTitleHeight;

@property (nonatomic) void(^didScrollCallBack)();
@property (nonatomic, readonly) HorizontalTableView *horizontalTableView ;

@end
