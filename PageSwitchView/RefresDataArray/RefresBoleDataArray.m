//
//  RefresBoleDataArray.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/8.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "RefresBoleDataArray.h"
#import "RefresActionView.h"


@interface RefresBoleDataArray()
@property (nonatomic) RefresView *refresView;
@property (nonatomic, weak) id<RefresBoleDataArrayDelegate> delegate;
@property (nonatomic) NSMutableArray <RefresBranchdDataArray*>*branchdArray;
- (instancetype)initSelf;
@end

@implementation RefresBoleDataArray

+ (instancetype)arrayWithRefresView:(RefresView*)view delegate:(id<RefresBoleDataArrayDelegate>)delegate{
    RefresBoleDataArray *arr = [[RefresBoleDataArray alloc] initSelf];
    arr.delegate = delegate;
    arr.refresView = view;
    return arr;
}

- (instancetype)initSelf {
    self = [super initWithCapacity:0];
    if (self) {
        //        [self initialization];
    }
    return self;
}

- (void)ref_addRefreshHeader {
    __weak typeof(self) weakSelf = self;
    MJRefreshStateHeader *header = refreshHeader(^{
        [weakSelf loadNextPageData];
    });
    self.refresView.mj_header = header;
}

-(void)loadNextPageData {
    __weak typeof(self)wself = self;
    NSAssert(self.delegate, @"delegate unfind");
    
    for (RefresBranchdDataArray*branchd in self.branchdArray) {
        if (branchd.linkedEnabled) {
            [branchd reloadData];
        }
    }
    
    [self.delegate loadDataInRefresView:self.refresView res:^(NSArray *arr, BOOL isOK) {
        if (!arr) {
            arr = @[];
        }
        if (isOK) {
                [wself removeAllObjects];
            if (arr.count>0) {
                [wself addObjectsFromArray:arr];
            }
            if ([wself.refresView isKindOfClass:[UITableView class]]) {
                [((UITableView*)wself.refresView) reloadData];
            }
            if ([wself.refresView isKindOfClass:[UICollectionView class]]) {
                [((UICollectionView*)wself.refresView) reloadData];
            }
            if (wself.refresView.mj_header) {
                [wself.refresView.mj_header endRefreshing];
            }
        }
        if ([wself.delegate respondsToSelector:@selector(didLoadDataInRefresView:)]) {
            [wself.delegate didLoadDataInRefresView:wself.refresView];
        }
    }];
}

-(void)reloadDataWithAnimate:(BOOL)animate {
    if (animate){
        if (self.refresView.mj_header) {
            [self.refresView.mj_header beginRefreshing];
        }
    }else{
        [self loadNextPageData];
    }
}

-(void)setDelegate:(id<RefresBoleDataArrayDelegate>)delegate {
    _delegate = delegate;
}

-(void)setRefresView:(RefresView *)refresView {
    _refresView = refresView;
    if (refresView) {
        [self ref_addRefreshHeader];
    }
}
-(NSMutableArray<RefresBranchdDataArray *> *)branchdArray {
    if (!_branchdArray) {
        _branchdArray = [NSMutableArray array];
    }
    return _branchdArray;
}

-(void)addBranchd:(RefresBranchdDataArray*)branchd {
    [self.branchdArray addObject:branchd];
}

-(void)removeBranchd:(RefresBranchdDataArray*)branchd {
    [self.branchdArray removeObject:branchd];
}
@end
