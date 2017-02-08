//
//  RefresDataArray.m
//  RefreshDataArray
//
//  Created by YLCHUN on 2016/9/30.
//  Copyright © 2016年 YLCHUN. All rights reserved.
//

#import "RefresDataArray.h"
#import "RefresActionView.h"

@interface RefresDataArray()
@property (nonatomic) RefresView *refresView;
@property (nonatomic, weak) id<RefresDataArrayDelegate> delegate;

@property(nonatomic) RefreshSet refSet;
@property(nonatomic, assign) NSUInteger page;
@property(nonatomic, assign) BOOL isLast;
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
            weakSelf.refresView.mj_footer.hidden=true;
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
//        self.isLast = false;
    }
    
//    if (self.isLast && self.page != self.refSet.startPage){//最后一页且不是第一页时候
//        return;
//    }
    __weak typeof(self)wself = self;
    __block NSUInteger page = self.page;
    [self.delegate loadDataInRefresView:self.refresView page:page firstPage:page == self.refSet.startPage res:^(NSArray* arr, BOOL isOK) {
        if (!arr) {
            arr = @[];
        }
        wself.refresing = NO;
//        NSLog(@"___page_0______sp:%ld, p:%ld, %ld",self.page, page,arr.count);

        if (page == wself.refSet.startPage) {//加载第一页
            if (isOK) {
                [wself removeAllObjects];
            }
            if ([wself.delegate respondsToSelector:@selector(emptyDataArrayInRefresView:isEmpty:)]) {
                [wself.delegate emptyDataArrayInRefresView:wself.refresView isEmpty:wself.count == 0 && arr.count == 0];
            }
        }
        if (arr.count>0) {
            [wself addObjectsFromArray:arr];
        }
        if (page == wself.refSet.startPage) {//加载第一页
            if (self.count>0) {
              //  [wself.refresView setContentOffset:CGPointMake(0, -55) animated:YES];// 55需要再确认 v2.0.4备注
            }
        }
        if ([wself.refresView isKindOfClass:[UITableView class]]) {
            [((UITableView*)wself.refresView) reloadData];
        }
        if ([wself.refresView isKindOfClass:[UICollectionView class]]) {
            [((UICollectionView*)wself.refresView) reloadData];
        }
        [wself updateRefresViewWithArr:arr page:page];
    }];
    self.refresing = YES;
}

-(void)updateRefresViewWithArr:(NSArray*)arr page:(NSUInteger)page {
    if (page == self.refSet.startPage) {//加载第一页
        if (self.refresView.mj_header) {
            [self.refresView.mj_header endRefreshing];
        }
    }else{
        if (self.refresView.mj_footer) {
            [self.refresView.mj_footer endRefreshing];
        }
    }
    if (self.refSet.pageSize<1 || arr.count<self.refSet.pageSize) {//只有一页或者最后一页
//        self.isLast = true;
        if (self.refresView.mj_footer) {
            if (self.refSet.pageSize<1 || (page == self.refSet.startPage && arr.count<self.refSet.pageSize)) {//只有一页
                self.refresView.mj_footer.hidden = true;
            }else{//多页且最后一页
                self.refresView.mj_footer.hidden = YES;
//                self.refresView.mj_footer.hidden = false;
                [self.refresView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }else {
//        self.isLast = false;
        self.page = page + 1;
        if (self.refresView.mj_footer) {
            self.refresView.mj_footer.hidden = false;
            [self.refresView.mj_footer endRefreshing];
        }
    }
//    if (self.refresView.mj_footer) {
//        if ((self.refSet.startPage == page-1 || self.refSet.startPage == page)&&self.refSet.pageSize == 1) {
//            if (self.hidenFooterAtFirstPageWhen1PageSize && self.count>0) {
//                __weak RefresDataArray* wArr = self;
//                if (!isLastPage) {
//                    self.refresView.mj_footer.hidden = self.hidenFooterAtFirstPageWhen1PageSize(wArr);
//                }
//            }else {
//                self.refresView.mj_footer.hidden = self.count<=5;
//            }
//        }
//    }
    
    if ([self.delegate respondsToSelector:@selector(didLoadDataInRefresView:page:firstPage:lastPage:)]) {
        [self.delegate didLoadDataInRefresView:self.refresView page:page firstPage:page == self.refSet.startPage lastPage:arr.count<self.refSet.pageSize];
    }
    [self didLoadDataWithPage:page firstPage:page == self.refSet.startPage];

//    NSLog(@"___page_1______sp:%ld, p:%ld, %ld",self.page, page,arr.count);
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
            self.refresView.mj_footer.hidden = true;
        }
    }
}

-(void)setDelegate:(id<RefresDataArrayDelegate>)delegate {
    _delegate = delegate;
    self.refSet = [self.delegate refreshSetWithRefresView:self.refresView];
    self.isLast = false;
}

-(void)setRefSet:(RefreshSet)refSet {
    if (!refSet.footer) {//没有下拉加载更多时候pageSize设为0
        refSet.pageSize = 0;
    }else if (refSet.pageSize < 1) {
        refSet.footer = false;
    }
    _refSet = refSet;
}
-(void)didLoadDataWithPage:(NSUInteger)page firstPage:(BOOL)firstPage {
    
}
-(void)setIgnoredScrollViewContentInsetTop:(CGFloat)ignoredScrollViewContentInsetTop {
    _ignoredScrollViewContentInsetTop = ignoredScrollViewContentInsetTop;
    if (self.refresView.mj_header) {
        self.refresView.mj_header.ignoredScrollViewContentInsetTop = ignoredScrollViewContentInsetTop;
    }
}

-(void)setIgnoredScrollViewContentInsetBottom:(CGFloat)ignoredScrollViewContentInsetBottom {
    _ignoredScrollViewContentInsetBottom = ignoredScrollViewContentInsetBottom;
    if (self.refresView.mj_footer) {
        self.refresView.mj_footer.ignoredScrollViewContentInsetBottom = ignoredScrollViewContentInsetBottom;
    }
}
@end
