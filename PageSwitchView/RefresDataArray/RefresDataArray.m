//
//  RefresDataArray.m
//  RefreshDataArray
//
//  Created by YLCHUN on 2016/9/30.
//  Copyright © 2016年 YLCHUN. All rights reserved.
//

#import "RefresDataArray.h"
#import "MJRefresh.h"
#import "RefresActionView.h"

@interface RefresDataArray()
@property (nonatomic) RefresView *refresView;
@property (nonatomic, weak) id<RefresDataArrayDelegate> delegate;

@property(nonatomic) RefreshSet refSet;
@property(nonatomic, assign) NSUInteger page;
@property(nonatomic, assign) BOOL loadingFirst;
- (instancetype)initSelf;
@end

@implementation RefresDataArray

inline RefreshSet RefreshSetMake(BOOL header, BOOL footer, NSUInteger startPage, NSUInteger pageSize) {
    RefreshSet refreshSet;
    refreshSet.header = header;
    refreshSet.footer = footer;
    refreshSet.pageSize = pageSize;
    refreshSet.startPage = startPage;
    return refreshSet;
}

+ (instancetype)arrayWithRefresView:(RefresView*)view delegate:(id<RefresDataArrayDelegate>)delegate{
    RefresDataArray *arr = [[self alloc] initSelf];
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
    MJRefreshHeader *header = refreshHeader(^{
        weakSelf.page = weakSelf.refSet.startPage;
        if (weakSelf.refresView.mj_footer) {
            weakSelf.refresView.mj_footer.hidden=YES;
        }
        [weakSelf loadNextPageData];
    });
    self.refresView.mj_header = header;
}

- (void)ref_addRefreshFooter {
    __weak typeof(self) weakSelf = self;
    MJRefreshFooter *footer = refreshFooter(^{
        [weakSelf loadNextPageData];
    });
    self.refresView.mj_footer = footer;
}

-(void)loadNextPageData {
    if (self.pageIsStartPageWhenEmpty && self.count == 0) {
        self.page = self.refSet.startPage;
    }
    if (self.loadingFirst) {//如果正在加载第一页则不加载其它页
        return;
    }
    __weak typeof(self)wself = self;
    NSAssert(self.delegate, @"delegate unfind");
    NSUInteger page = self.page;
    BOOL loadingFirst = self.page == self.refSet.startPage;
    
    [self.delegate loadDataInRefresView:self.refresView page:page firstPage:page == self.refSet.startPage res:^(NSArray *arr, BOOL isOK) {
        
        if (!arr) {
            arr = @[];
        }
        BOOL isFristPage = page == wself.refSet.startPage;
        
        if (isOK && (loadingFirst || (!loadingFirst && !wself.loadingFirst))) {
            if (isFristPage) {//加载第一页
                [wself removeAllObjects];
            }
            if (arr.count>0) {
                [wself addObjectsFromArray:arr];
            }
            if ([wself.refresView isKindOfClass:[UITableView class]]) {
                [((UITableView*)wself.refresView) reloadData];
            }
            if ([wself.refresView isKindOfClass:[UICollectionView class]]) {
                [((UICollectionView*)wself.refresView) reloadData];
            }
        }
        if (isFristPage) {//加载第一页
            if ([wself.delegate respondsToSelector:@selector(emptyDataArrayInRefresView:isEmpty:)]) {
                [wself.delegate emptyDataArrayInRefresView:wself.refresView isEmpty:arr.count == 0];
            }
            if (wself.refresView.mj_header) {
                [wself.refresView.mj_header endRefreshing];
            }
            if (wself.refSet.pageSize>1 && arr.count >= wself.refSet.pageSize) {//有多页
                if (isOK) {
                    wself.page = page + 1;
                }
                if (wself.refresView.mj_footer) {
                    wself.refresView.mj_footer.hidden = NO;
                }
            }
            else{//只有一页
                if (wself.hidenFooterAtFirstPageWhen1PageSize && wself.refSet.pageSize == 1) {
                    wself.refresView.mj_footer.hidden = wself.hidenFooterAtFirstPageWhen1PageSize(wself);
                }
            }
            wself.loadingFirst = NO;
        }else{
            if (wself.refresView.mj_footer) {
                if (arr.count >= wself.refSet.pageSize) {
                    [wself.refresView.mj_footer endRefreshing];
                    if (isOK) {
                        wself.page = page + 1;
                    }
                }else{
                    [wself.refresView.mj_footer endRefreshingWithNoMoreData];
                }
                wself.refresView.mj_footer.hidden = NO;
            }
        }
        
        if ([wself.delegate respondsToSelector:@selector(didLoadDataInRefresView:page:firstPage:)]) {
            [wself.delegate didLoadDataInRefresView:wself.refresView page:page firstPage:page == wself.refSet.startPage];
        }
        [wself didLoadDataWithPage:page firstPage:page == wself.refSet.startPage];
    }];
    self.loadingFirst = loadingFirst;
}


-(void)reloadDataWithAnimate:(BOOL)animate {
    if (self.refSet.header && animate){
        if (self.refresView.mj_header) {
            [self.refresView.mj_header beginRefreshing];
        }
    }else{
        self.page = self.refSet.startPage;
        [self loadNextPageData];
    }
}


-(void)setRefresView:(RefresView *)refresView {
    _refresView = refresView;
    if (self.refSet.header){
        [self ref_addRefreshHeader];
    }
    if (self.refSet.footer){
        [self ref_addRefreshFooter];
        if (self.refresView.mj_footer) {
            self.refresView.mj_footer.hidden = YES;
        }
    }
}

-(void)setDelegate:(id<RefresDataArrayDelegate>)delegate {
    _delegate = delegate;
    self.refSet = [self.delegate refreshSetWithRefresView:self.refresView];
}

-(void)setRefSet:(RefreshSet)refSet {
    if (!refSet.footer) {//没有下拉加载更多时候pageSize设为0
        refSet.pageSize = 0;
    }else if (refSet.pageSize < 1) {
        refSet.footer = NO;
    }
    _refSet = refSet;
}

-(void)didLoadDataWithPage:(NSUInteger)page firstPage:(BOOL)firstPage {
    
}
@end
