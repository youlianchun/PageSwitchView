//
//  RefresBranchdDataArray.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/8.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "RefresBranchdDataArray.h"
#import "RefresBoleDataArray.h"

@interface RefresDataArray()
- (instancetype)initSelf;
-(void)setRefSet:(RefreshSet)refSet;
@end

@interface RefresBranchdDataArray ()
@property (nonatomic, copy) void(^didLoadData)(NSUInteger page, BOOL firstPage);
@property (nonatomic, weak) RefresBoleDataArray*boleDataArray;
@end

@implementation RefresBranchdDataArray

-(instancetype)initSelf {
    self = [super initSelf];
    if (self) {
        self.linkedEnabled = YES;
    }
    return self;
}

-(void)reloadDataFromBole {
    [super reloadDataWithAnimate:NO];
}

-(void)reloadData {
    if (self.boleDataArray) {
        if (!self.boleDataArray.willLoading) {
            [super reloadDataWithAnimate:NO];
        }
    }else{
        [super reloadDataWithAnimate:NO];
    }
}

-(void)setRefSet:(RefreshSet)refSet {
    refSet.header = NO;
    [super setRefSet:refSet];
}

-(void)didLoadDataWithPage:(NSUInteger)page firstPage:(BOOL)firstPage {
    if (self.didLoadData) {
        self.didLoadData(page,firstPage);
    }
}
@end
