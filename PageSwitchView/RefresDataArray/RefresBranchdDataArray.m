//
//  RefresBranchdDataArray.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/8.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "RefresBranchdDataArray.h"
@interface RefresDataArray()
- (instancetype)initSelf;
-(void)setRefSet:(RefreshSet)refSet;
@end

@implementation RefresBranchdDataArray

-(instancetype)initSelf {
    self = [super initSelf];
    if (self) {
        self.linkedEnabled = YES;
    }
    return self;
}

-(void)reloadData {
    [super reloadDataWithAnimate:NO];
}

-(void)setRefSet:(RefreshSet)refSet {
    refSet.header = NO;
    [super setRefSet:refSet];
}

@end
