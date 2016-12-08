//
//  RefresActionView.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/8.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "MJRefresh.h"


extern MJRefreshStateHeader *refreshHeader(void(^action)());
extern MJRefreshAutoNormalFooter *refreshFooter(void(^action)());
