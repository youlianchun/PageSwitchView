//
//  PageSwitchView.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/11/30.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "PageSwitchView.h"
#import "HorizontalTableView.h"
#import "_PageSwitchItem.h"
#import "UIGestureRecognizer+Group.h"
#import "SegmentTableView.h"
#import "StretchingHeaderView.h"
#import "_TwoScrollView.h"

@interface _PageSwitchView:UITableView
@property (nonatomic)UIScrollView *otherScrollView;
@end

@implementation _PageSwitchView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer.groupTag isEqualToString:otherGestureRecognizer.groupTag]) {
        if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
            self.otherScrollView = (UIScrollView*)otherGestureRecognizer.view;
        }else {
            self.otherScrollView = nil;
        }
        return true;
    }else{
        return false;
    }
}

@end

static NSString *kUIGestureRecognizer = @"kUIGestureRecognizer";
static const NSInteger kNull_PageIndex = 999999999;
@interface PageSwitchView ()< UIGestureRecognizerDelegate,
                            UITableViewDelegate, UITableViewDataSource,
                            SegmentTableViewDelegate, SegmentTableViewDataSource,
                            HorizontalTableViewDelegate, HorizontalTableViewDataSource >

@property (nonatomic) _PageSwitchView *pageTableView;

@property (nonatomic, retain) HorizontalTableView *hTableView ;

@property (nonatomic, strong) NSMutableArray<PageSwitchItem *>*pageSwitchItemArray;
@property (nonatomic) UIViewController *selfViewController;

@property (nonatomic) SegmentTableView *segmentTableView;
@property (nonatomic) NSUInteger initPageIndex;
@property (nonatomic) NSUInteger currentPageIndex;
@property (nonatomic) UIView *headerView;
@property (nonatomic) CGFloat topeSpace;
@property (nonatomic) BOOL isScrolling;
@property (nonatomic) StretchingHeaderView *stretchingHeaderView;
@end

@implementation PageSwitchView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _topeSpace = 40;
        self.initPageIndex = 0;
    }
    return self;
}

#pragma mark - Get Set
-(UIViewController *)selfViewController{
    if (!_selfViewController) {
        UIResponder *responder = self;
        while (responder) {
            if ([responder isKindOfClass: [UIViewController class]]) {
                _selfViewController =  (UIViewController *)responder;
                break;
            }
            responder = [responder nextResponder];
        }
    }
    return _selfViewController;
}
-(_PageSwitchView *)pageTableView {
    if (!_pageTableView) {
        _pageTableView = [[_PageSwitchView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _pageTableView.showsVerticalScrollIndicator = false;
        _pageTableView.delegate = self;
        _pageTableView.dataSource = self;
        _pageTableView.panGestureRecognizer.groupTag = kUIGestureRecognizer;
        [self addSubview:_pageTableView];
//        _pageTableView.rowHeight = CGRectGetHeight(self.bounds)-CGRectGetHeight(self.segmentTableView.bounds)-self.topeSpace;
        _pageTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, self.topeSpace)];
        _pageTableView.translatesAutoresizingMaskIntoConstraints = false;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageTableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageTableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_pageTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_pageTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    return _pageTableView;
}

-(HorizontalTableView *)hTableView {
    if (!_hTableView) {
        _hTableView = [[HorizontalTableView alloc]initWithFrame:CGRectZero];
        _hTableView.delegate = self;
        _hTableView.dataSource = self;
    }
    return _hTableView;
}
-(SegmentTableView *)segmentTableView {
    if (!_segmentTableView) {
        _segmentTableView = [[SegmentTableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
        _segmentTableView.titleLabelWidth = self.bounds.size.width/MIN(self.pageSwitchItemArray.count, 5);
        _segmentTableView.backgroundColor = [UIColor orangeColor];
        _segmentTableView.delegate = self;
        _segmentTableView.dataSource = self;
    }
    return _segmentTableView;
}

-(UIView *)headerView {
    if (!_headerView) {
        if ([self.dataSource respondsToSelector:@selector(viewForHeaderInPageSwitchView:)]) {
            _headerView = [self.dataSource viewForHeaderInPageSwitchView:self];
            if (_headerView) {
               CGFloat hh = _headerView.bounds.size.height;
                self.topeSpace = self.topeSpace <= hh ? self.topeSpace : hh;
            }else {
                self.topeSpace = 0;
            }
        }else {
            self.topeSpace = 0;
        }
    }
    return _headerView;
}


-(PageSwitchItem *)contentPageSwitchItem {
    NSUInteger currentPageIndex = self.hTableView.currentPageIndex;
    return  self.pageSwitchItemArray[currentPageIndex];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.hTableView];
        [self addConstraint:self.hTableView inserts:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    [self.hTableView reloadData];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  self.segmentTableView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  CGRectGetHeight(self.segmentTableView.bounds);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return  CGRectGetHeight(self.bounds)-CGRectGetHeight(self.segmentTableView.bounds)-self.topeSpace;
}

#pragma mark UITableViewDelegate_Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.pageTableView.scrollEnabled) {
        PageSwitchItem *item = self.contentPageSwitchItem;
        if (item.isScroll || item.is2Scroll) {//滚动视图
            UIScrollView *contentScrollView =  self.pageTableView.otherScrollView;//(UIScrollView*)item.contentView;
            
            if (scrollView == self.pageTableView) {//滚动外部视图
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.2];
                //NSLog(@"滑动中");
                self.isScrolling = YES ;
                
                //                    printf("...hhhhhhhhhhhh\n");
                static CGFloat lastContentOffset_y=0;
                if (scrollView.contentOffset.y<lastContentOffset_y) {//向下
                    if (contentScrollView && contentScrollView.contentOffset.y > 0) {
                        self.pageTableView.contentOffset = CGPointMake(0.0f, self.pageTableView.tableHeaderView.bounds.size.height);
                    }else{
                        CGFloat offsetY = scrollView.contentOffset.y;
                        if(offsetY <= self.pageTableView.tableHeaderView.bounds.size.height) {
                            contentScrollView.contentOffset = CGPointZero;
                        }
                    }
                } else if (scrollView.contentOffset.y>lastContentOffset_y) {//向上
                    if (self.pageTableView.contentOffset.y >= self.pageTableView.contentSize.height-self.pageTableView.bounds.size.height-self.topeSpace) {
                        self.pageTableView.contentOffset = CGPointMake(0.0f, self.pageTableView.contentSize.height-self.pageTableView.bounds.size.height-self.topeSpace);
                        
                    }
                }
                lastContentOffset_y = scrollView.contentOffset.y;
            }
            else if (scrollView == contentScrollView) {//滚动里面视图
                printf("...ccccccccccccc\n");
                if (self.pageTableView.contentOffset.y < self.pageTableView.tableHeaderView.bounds.size.height-self.topeSpace) {
                    scrollView.contentOffset = CGPointZero;
                    scrollView.showsVerticalScrollIndicator = NO;
                }else {
                    self.pageTableView.contentOffset = CGPointMake(0.0f, self.pageTableView.tableHeaderView.bounds.size.height);
                    scrollView.showsVerticalScrollIndicator = YES;
                }
            }
        }else{//普通视图
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.2];
            //NSLog(@"滑动中");
            self.isScrolling = YES ;
            static CGFloat lastContentOffset_y=0;
            if (scrollView.contentOffset.y<lastContentOffset_y) {//向下
                
            } else if (scrollView.contentOffset.y>lastContentOffset_y) {//向上
                if (self.pageTableView.contentOffset.y >= self.pageTableView.contentSize.height-self.pageTableView.bounds.size.height-self.topeSpace) {
                    self.pageTableView.contentOffset = CGPointMake(0.0f, self.pageTableView.contentSize.height-self.pageTableView.bounds.size.height-self.topeSpace);
                    
                }
            }
            lastContentOffset_y = scrollView.contentOffset.y;
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.isScrolling = NO ;
}

#pragma mark - HorizontalTableViewDataSource

-(NSUInteger)numberOfRowInTableView:(HorizontalTableView*)tableView {
    return self.pageSwitchItemArray.count;
}

#pragma mark - HorizontalTableViewDelegate
- (void)tableView:(HorizontalTableView*)tableView cellContentView:(UIContentView*)contentView atRowIndex:(NSUInteger )rowIndex isReuse:(BOOL)isReuse {
    if (!isReuse) {
        __weak UIContentView *wContentView = contentView;
        __weak PageSwitchItem * pageSwitchItem = self.pageSwitchItemArray[rowIndex];
        __weak typeof(self) wself = self;
        pageSwitchItem.didLoadBock = ^{
            if (pageSwitchItem.isScroll) {
                UIScrollView *scrollView =  (UIScrollView *)pageSwitchItem.contentView;
                scrollView.panGestureRecognizer.groupTag = kUIGestureRecognizer;
            }
            if (pageSwitchItem.is2Scroll) {
                TwoScrollView *twoScrollView = (TwoScrollView*)pageSwitchItem.contentView;
                twoScrollView.panGestureRecognizerGroupTag = kUIGestureRecognizer;
                twoScrollView.haveHeader = self.headerView != nil;
            }
            [wself.selfViewController addChildViewController:pageSwitchItem.contentViewController];
            pageSwitchItem.scrollDelegate = wself;
            
            [wContentView addSubview:pageSwitchItem.contentViewController.view];
            pageSwitchItem.contentViewController.view.frame = wContentView.bounds;
            if ([pageSwitchItem.contentViewController respondsToSelector:@selector(viewDidAdjustRect)]) {
                [pageSwitchItem.contentViewController viewDidAdjustRect];
            }
            if (pageSwitchItem.contentViewController.view != pageSwitchItem.contentView) {
                [((UIView *)pageSwitchItem.contentView) removeFromSuperview];
                [pageSwitchItem.contentViewController.view addSubview:pageSwitchItem.contentView];
            }
            if (pageSwitchItem.contentViewController.view != pageSwitchItem.contentView) {
                [wself addConstraint:pageSwitchItem.contentView inserts:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
        };
    }

}

-(CGFloat)cellSpaceInTableView:(HorizontalTableView*)tableView {
    return 50;
}

-(void)tableView:(HorizontalTableView *)tableView willDisplayCellView:(UIContentView *)contentView atRowIndex:(NSUInteger )rowIndex {
    PageSwitchItem * pageSwitchItem = self.pageSwitchItemArray[rowIndex];
    pageSwitchItem.isVisible = true;
    if (pageSwitchItem.didLoad) {
        if (pageSwitchItem.isScroll) {
            UIScrollView *scrollView = (UIScrollView*)pageSwitchItem.contentView;
            if (self.pageTableView.contentOffset.y < self.pageTableView.tableHeaderView.bounds.size.height-self.topeSpace) {
                [scrollView setContentOffset:CGPointZero animated:false];
            }
        }
        if (pageSwitchItem.is2Scroll) {
            TwoScrollView *twoScrollView = (TwoScrollView*)pageSwitchItem.contentView;
            if (self.pageTableView.contentOffset.y < self.pageTableView.tableHeaderView.bounds.size.height-self.topeSpace) {
                [twoScrollView.scrollView_l setContentOffset:CGPointZero animated:false];
                [twoScrollView.scrollView_r setContentOffset:CGPointZero animated:false];
            }
        }
    }
}

-(void)tableView:(HorizontalTableView *)tableView didEndDisplayingCellView:(UIContentView *)contentView atRowIndex:(NSUInteger )rowIndex {
    PageSwitchItem * pageSwitchItem = self.pageSwitchItemArray[rowIndex];
    pageSwitchItem.isVisible = false;
    pageSwitchItem.isCurrent = false;
}

-(void)tableView:(HorizontalTableView *)tableView didScrollWithLeftPageIndex:(NSUInteger)leftPageIndex leftScale:(CGFloat)leftScale rightPageIndex:(NSUInteger)rightPageIndex rightScale:(CGFloat)rightScale {
    [self.segmentTableView handoverWithLeftPageIndex:leftPageIndex leftScale:leftScale rightPageIndex:rightPageIndex rightScale:rightScale];
    if ([self.delegate respondsToSelector:@selector(pageSwitchView:movingAtPageIndex:)]) {
        [self.delegate pageSwitchView:self movingAtPageIndex:tableView.currentPageIndex];
    }
}

-(void)tableView:(HorizontalTableView *)tableView didScrollToPageIndex:(NSUInteger)index {
    [self.segmentTableView handoverWithLeftPageIndex:index leftScale:1.0 rightPageIndex:kNull_PageIndex rightScale:0.0];
    self.pageSwitchItemArray[index].isCurrent = true;
    [self.segmentTableView adjustCurrentIndex:index];
}


#pragma mark - SegmentTableViewDataSource
-(NSArray<NSString*>*)titlesOfRowInTableView:(SegmentTableView*)tableView {
    NSMutableArray *titleArray = [NSMutableArray array];
    for (PageSwitchItem *item in self.pageSwitchItemArray) {
        [titleArray addObject:item.title];
    }
    return titleArray;
}

#pragma mark - SegmentTableViewDelegate
-(void)segmentTableView:(SegmentTableView *)tableView didSelectAtIndex:(NSUInteger)index {
    [self.hTableView scrollToRowAtIndex:index animated:false];
    self.initPageIndex = index;
}

#pragma mark -

-(void)addConstraint:(UIView*)view inserts:(UIEdgeInsets)inserts {
    UIView *superview = view.superview;
    view.translatesAutoresizingMaskIntoConstraints = false;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1 constant:inserts.left]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1 constant:inserts.right]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1 constant:inserts.top]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1 constant:inserts.bottom]];
}







//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (self.isScrolling) {
//       CGRect segmentTableViewRect = [self.segmentTableView convertRect:self.segmentTableView.bounds toView:self];
//        if (point.y >= segmentTableViewRect.origin.y && point.y <= segmentTableViewRect.size.height+segmentTableViewRect.origin.y) {
//
//            [self.pageTableView.otherScrollView setContentOffset:self.pageTableView.otherScrollView.contentOffset animated:false];
//
//            CGPoint p = [self convertPoint:point toView:self.segmentTableView];
//            UIView *v = [self.segmentTableView hitTest:p withEvent:event];
//            while (![v isKindOfClass:[UITableViewCell class]]) {
//                v = v.superview;
//            }
//            UITableViewCell *cell = (UITableViewCell*)v;
//            NSIndexPath *indexPath = [self.segmentTableView.tableView indexPathForCell:cell];
//            NSIndexPath *indexPath2 = [self.segmentTableView.tableView indexPathForCell:self.hTableView.tableView.visibleCells[0]];
//            if (indexPath.row == indexPath2.row) {
//                return nil;
//            }
//            [self.hTableView.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
//            ;
////            [self.segmentTableView.tableView selectRowAtIndexPath:[self.segmentTableView.tableView indexPathForCell:cell] animated:false scrollPosition:UITableViewScrollPositionNone];
//            return v;
//        }
//    }
//    return [super hitTest:point withEvent:event];
//}

-(void)reloadData {
    self.pageSwitchItemArray = [[self.dataSource pageSwitchItemsInPageSwitchView:self] mutableCopy];
    self.segmentTableView.selectedTitleColor = [UIColor whiteColor];//[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1];
    self.segmentTableView.normalTitleColor =  [UIColor lightGrayColor];
    self.segmentTableView.selectedBgColor = [UIColor blueColor];
    self.segmentTableView.normalBgColor = [UIColor whiteColor];
    [self.segmentTableView reloadData];
    
    
    self.headerView = nil;
    if (self.headerView) {
        self.pageTableView.scrollEnabled = true;
        
        UIView *view = [[UIView alloc]initWithFrame:self.headerView.bounds];
        self.pageTableView.tableHeaderView = view;
        [view addSubview:self.headerView];
        StretchingHeaderView *sHeaderView = [[StretchingHeaderView alloc]initWithFrame:self.headerView.bounds];
        [view addSubview:sHeaderView];
        sHeaderView.translatesAutoresizingMaskIntoConstraints = false;
        [view addConstraint:[NSLayoutConstraint constraintWithItem:sHeaderView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:sHeaderView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:sHeaderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [view addConstraint: [NSLayoutConstraint constraintWithItem:sHeaderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        sHeaderView.contentView = self.headerView;
        
    }else {
        self.pageTableView.scrollEnabled = false;
    }
    
    [self.pageTableView reloadData];
}


-(void)switchNewPageWithNewIndex:(NSUInteger)newIndex {
    if (self.currentPageIndex == newIndex || newIndex >= self.pageSwitchItemArray.count) {
        return;
    }
    self.segmentTableView.currentIndex = newIndex;
}

-(void)setTopeSpace:(CGFloat)topeSpace {
    if (topeSpace < 0) {
        topeSpace = 0;
    }
    _topeSpace = topeSpace;
//        self.pageTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, self.topeSpace)];
}

@end

