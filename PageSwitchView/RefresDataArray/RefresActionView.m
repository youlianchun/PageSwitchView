//
//  RefresActionView.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/8.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "RefresActionView.h"

inline MJRefreshStateHeader *refreshHeader(void(^action)()) {
    //    NSMutableArray *idleImages = [NSMutableArray array];
    //    for (NSUInteger i = 1; i<=18; i++) {
    //        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%zd", i]];
    //        [idleImages addObject:image];
    //    }
    //    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
    //        if (action) {
    //            action();
    //         }
    //    }];
    //    // 设置普通状态的动画图片
    //    [header setImages:idleImages forState:MJRefreshStateIdle];
    //    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    //    [header setImages:idleImages forState:MJRefreshStatePulling];
    //    // 设置正在刷新状态的动画图片
    //    [header setImages:idleImages forState:MJRefreshStateRefreshing];
    //    // 设置header
    //    self.refresView.mj_header = header;
    //    // 隐藏时间
    //    header.lastUpdatedTimeLabel.hidden = YES;
    //    // 隐藏状态
    //    header.stateLabel.hidden = YES;

    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        if (action) {
            action();
        }
    }];
    return header;
}


inline MJRefreshAutoNormalFooter *refreshFooter(void(^action)()) {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (action) {
            action();
        }
    }];
    return footer;
}

