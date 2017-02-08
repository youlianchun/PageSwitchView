//
//  RefresActionView.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/8.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "RefresActionView.h"

inline MJRefreshHeader *refreshHeader(void(^action)()) {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:action];
    return header;
}


inline MJRefreshFooter *refreshFooter(void(^action)()) {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:action];
    return footer;
}

