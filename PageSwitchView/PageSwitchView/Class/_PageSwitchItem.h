//
//  PageSwitchItem.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/9/23.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "PageSwitchItem.h"

@interface PageSwitchItem()

@property (nonatomic, assign) BOOL isScroll;
@property (nonatomic, assign) BOOL is2Scroll;

@property (nonatomic, assign)BOOL didConfig;//标记滑动视图的显示样式是否处理完成

@property (nonatomic, weak)id<UIScrollViewDelegate> scrollDelegate;
@property (nonatomic) BOOL isVisible;
@property (nonatomic) BOOL isCurrent;

@property (nonatomic) void (^didLoadBock)();

@end
