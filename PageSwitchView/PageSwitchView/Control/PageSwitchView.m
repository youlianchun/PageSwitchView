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

#pragma mark -
#pragma mark - _PageSwitchView

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
        return YES;
    }else{
        return NO;
    }
}

@end

#pragma mark -
#pragma mark - PageSwitchView

static NSString *kUIGestureRecognizer_V = @"kUIGestureRecognizer_V";
static const NSInteger kNull_PageIndex = 999999999;
@interface PageSwitchView ()< UIGestureRecognizerDelegate,
                            StretchingHeaderViewDelegate,
                            UITableViewDelegate, UITableViewDataSource,
                            SegmentTableViewDelegate, SegmentTableViewDataSource,
                            HorizontalTableViewDelegate, HorizontalTableViewDataSource >

@property (nonatomic) _PageSwitchView *pageTableView;

@property (nonatomic) StretchingHeaderView *stretchingHeaderView;
@property (nonatomic, retain) HorizontalTableView *hTableView ;

@property (nonatomic, strong) NSMutableArray<PageSwitchItem *>*pageSwitchItemArray;
@property (nonatomic) UIViewController *selfViewController;

@property (nonatomic) SegmentTableView *segmentTableView;
@property (nonatomic) UIView *headerView;
@property (nonatomic) CGFloat topeSpace;
@property (nonatomic) CGFloat titleHeight;
//@property (nonatomic) BOOL isScrolling;
@property (nonatomic) UIView *navigationBar_placeholderView;
@property (nonatomic) void(^layoutBlock)(UIView *superView);

@property (nonatomic) NSMutableArray<NSString*> *titleArray;
@end

@implementation PageSwitchView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.topeSpace = 0;
        self.titleHeight = 44;
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
        _pageTableView.showsVerticalScrollIndicator = NO;
        _pageTableView.backgroundColor = [UIColor clearColor];
        _pageTableView.opaque = NO;
        _pageTableView.delegate = self;
        _pageTableView.dataSource = self;
        _pageTableView.panGestureRecognizer.groupTag = kUIGestureRecognizer_V;

        [self addSubview:_pageTableView];
        _pageTableView.translatesAutoresizingMaskIntoConstraints = NO;
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
        _segmentTableView = [[SegmentTableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.titleHeight)];
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
        }
    }
    return _headerView;
}


-(PageSwitchItem *)contentPageSwitchItem {
    NSUInteger currentPageIndex = self.hTableView.currentPageIndex;
    return  self.pageSwitchItemArray[currentPageIndex];
}

-(CGFloat)topeSpace {
    if (_topeSpace <0 ) {
        return -self.titleHeight;
    }
    if (self.headerView) {
            CGFloat h = CGRectGetHeight(self.headerView.bounds);
            if (_topeSpace > h) {
                return h;
            }
    }
    return _topeSpace;
}

-(UIView *)navigationBar_placeholderView {
    if (!_navigationBar_placeholderView) {
        _navigationBar_placeholderView = [[UIView alloc]init];
        [self insertSubview:_navigationBar_placeholderView atIndex:0];
        _navigationBar_placeholderView.backgroundColor = [UIColor whiteColor];
        _navigationBar_placeholderView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_navigationBar_placeholderView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_navigationBar_placeholderView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_navigationBar_placeholderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:-64]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_navigationBar_placeholderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        self.clipsToBounds = NO;
    }
    return _navigationBar_placeholderView;
}

#pragma mark - StretchingHeaderViewDelegate
-(void)stretchingHeaderView:(StretchingHeaderView*)stretchingHeaderView displayProgress:(CGFloat)progress{
    if ([self.delegate respondsToSelector:@selector(pageSwitchView:headerDisplayProgress:)]) {
        [self.delegate pageSwitchView:self headerDisplayProgress:progress];
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  self.segmentTableView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.segmentTableView) {
        return  CGRectGetHeight(self.segmentTableView.bounds);
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return  CGRectGetHeight(self.bounds)-CGRectGetHeight(self.segmentTableView.bounds)-self.topeSpace;
}

#pragma mark UITableViewDelegate_Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.pageTableView.scrollEnabled) {
        if (scrollView == self.pageTableView) {
            CGFloat sectionHeaderHeight = self.titleHeight;
            if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            }
        }
        PageSwitchItem *item = self.contentPageSwitchItem;
        if (item.isScroll || item.is2Scroll) {//滚动视图
            UIScrollView *contentScrollView =  self.pageTableView.otherScrollView;//(UIScrollView*)item.contentView;
            
            if (scrollView == self.pageTableView) {//滚动外部视图
                //                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                //                [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.2];
                //                self.isScrolling = YES ;
                
                static CGFloat lastContentOffset_y=0;
                if (scrollView.contentOffset.y<lastContentOffset_y) {//向下
                    if (contentScrollView && contentScrollView.contentOffset.y > 0) {
                        self.pageTableView.contentOffset = CGPointMake(0.0f, self.pageTableView.tableHeaderView.bounds.size.height-self.topeSpace);
                    }else{
                        CGFloat offsetY = scrollView.contentOffset.y;
                        if(offsetY <= self.pageTableView.tableHeaderView.bounds.size.height-self.topeSpace) {
                            contentScrollView.contentOffset = CGPointZero;
                        }
                    }
                } else if (scrollView.contentOffset.y>lastContentOffset_y) {//向上
                    if (self.pageTableView.contentOffset.y >= self.pageTableView.contentSize.height-self.pageTableView.bounds.size.height) {
                        self.pageTableView.contentOffset = CGPointMake(0.0f, self.pageTableView.contentSize.height-self.pageTableView.bounds.size.height);
                    }
                }
                lastContentOffset_y = scrollView.contentOffset.y;
            }
            else if (scrollView == contentScrollView) {//滚动里面视图
                if (self.pageTableView.contentOffset.y < self.pageTableView.tableHeaderView.bounds.size.height-self.topeSpace) {
                    scrollView.contentOffset = CGPointZero;
                    scrollView.showsVerticalScrollIndicator = NO;
                }else {
                    self.pageTableView.contentOffset = CGPointMake(0.0f, self.pageTableView.tableHeaderView.bounds.size.height-self.topeSpace);
                    scrollView.showsVerticalScrollIndicator = YES;
                }
            }
        }else{//普通视图
            //            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            //            [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.2];
            //            self.isScrolling = YES ;
            
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

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    self.isScrolling = NO ;
//}

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
                scrollView.panGestureRecognizer.groupTag = kUIGestureRecognizer_V;
            }
            if (pageSwitchItem.is2Scroll) {
                TwoScrollView *twoScrollView = (TwoScrollView*)pageSwitchItem.contentView;
                twoScrollView.panGestureRecognizerGroupTag = kUIGestureRecognizer_V;
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
                [pageSwitchItem.contentView removeFromSuperview];
                [pageSwitchItem.contentViewController.view addSubview:pageSwitchItem.contentView];
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
    pageSwitchItem.isVisible = YES;
    if (pageSwitchItem.didLoad) {
        if (pageSwitchItem.isScroll) {
            UIScrollView *scrollView = (UIScrollView*)pageSwitchItem.contentView;
            if (self.pageTableView.contentOffset.y < self.pageTableView.tableHeaderView.bounds.size.height-self.topeSpace) {
                [scrollView setContentOffset:CGPointZero animated:NO];
            }
        }
        if (pageSwitchItem.is2Scroll) {
            TwoScrollView *twoScrollView = (TwoScrollView*)pageSwitchItem.contentView;
            if (self.pageTableView.contentOffset.y < self.pageTableView.tableHeaderView.bounds.size.height-self.topeSpace) {
                [twoScrollView.scrollView_l setContentOffset:CGPointZero animated:NO];
                [twoScrollView.scrollView_r setContentOffset:CGPointZero animated:NO];
            }
        }
    }
}

-(void)tableView:(HorizontalTableView *)tableView didEndDisplayingCellView:(UIContentView *)contentView atRowIndex:(NSUInteger )rowIndex {
    PageSwitchItem * pageSwitchItem = self.pageSwitchItemArray[rowIndex];
    pageSwitchItem.isVisible = NO;
    pageSwitchItem.isCurrent = NO;
}

-(void)tableView:(HorizontalTableView *)tableView didScrollWithLeftPageIndex:(NSUInteger)leftPageIndex leftScale:(CGFloat)leftScale rightPageIndex:(NSUInteger)rightPageIndex rightScale:(CGFloat)rightScale {
    if (rightScale !=0 && leftScale!= 0) {
        PageSwitchItem *pageSwitchItem = self.pageSwitchItemArray[tableView.currentPageIndex];
        if (pageSwitchItem.didLoad && [pageSwitchItem.contentViewController respondsToSelector:@selector(pageScrolling)]) {
            [pageSwitchItem.contentViewController pageScrolling];
        }
    }
    [self.segmentTableView handoverWithLeftPageIndex:leftPageIndex leftScale:leftScale rightPageIndex:rightPageIndex rightScale:rightScale];
    if ([self.delegate respondsToSelector:@selector(pageSwitchView:movingAtPageIndex:)]) {
        [self.delegate pageSwitchView:self movingAtPageIndex:tableView.currentPageIndex];
    }
    
}

-(void)tableView:(HorizontalTableView *)tableView didScrollToPageIndex:(NSUInteger)index {
    [self.segmentTableView handoverWithLeftPageIndex:index leftScale:1.0 rightPageIndex:kNull_PageIndex rightScale:0.0];
    self.pageSwitchItemArray[index].isCurrent = YES;
    [self.segmentTableView adjustCurrentIndex:index];
}


#pragma mark - SegmentTableViewDataSource
-(NSArray<NSString*>*)titlesOfRowInTableView:(SegmentTableView*)tableView {
    NSMutableArray *titleArray = [NSMutableArray array];
    for (PageSwitchItem *item in self.pageSwitchItemArray) {
        [titleArray addObject:item.title];
    }
    self.titleArray = titleArray;
    return titleArray;
}

#pragma mark - SegmentTableViewDelegate
-(void)segmentTableView:(SegmentTableView *)tableView didSelectAtIndex:(NSUInteger)index {
    if (index == self.hTableView.currentPageIndex) {
        
    }
    PageSwitchItem *pageSwitchItem = self.pageSwitchItemArray[self.hTableView.currentPageIndex];
    if (pageSwitchItem.didLoad && [pageSwitchItem.contentViewController respondsToSelector:@selector(pageScrolling)]) {
        [pageSwitchItem.contentViewController pageScrolling];
    }
    [self.hTableView scrollToRowAtIndex:index animated:NO];
}

#pragma mark -

-(void)addConstraint:(UIView*)view inserts:(UIEdgeInsets)inserts {
    UIView *superview = view.superview;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1 constant:inserts.left]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1 constant:inserts.right]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1 constant:inserts.top]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1 constant:inserts.bottom]];
}

-(void)layoutWithinserts:(UIEdgeInsets)inserts {
    __weak typeof(self) wself = self;
    UIView *superview = wself.superview;
    self.layoutBlock = ^(UIView* superView){
        wself.translatesAutoresizingMaskIntoConstraints = NO;
        [superview addConstraint:[NSLayoutConstraint constraintWithItem:wself attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1 constant:inserts.left]];
        [superview addConstraint:[NSLayoutConstraint constraintWithItem:wself attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1 constant:inserts.right]];
        [superview addConstraint: [NSLayoutConstraint constraintWithItem:wself attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1 constant:inserts.top]];
        [superview addConstraint: [NSLayoutConstraint constraintWithItem:wself attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1 constant:inserts.bottom]];
        wself.layoutBlock = nil;
    };
    if (superview) {
        self.layoutBlock(superview);
    }
}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (self.isScrolling) {
//       CGRect segmentTableViewRect = [self.segmentTableView convertRect:self.segmentTableView.bounds toView:self];
//        if (point.y >= segmentTableViewRect.origin.y && point.y <= segmentTableViewRect.size.height+segmentTableViewRect.origin.y) {
//
//            [self.pageTableView.otherScrollView setContentOffset:self.pageTableView.otherScrollView.contentOffset animated:NO];
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
//            [self.hTableView.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
//            ;
////            [self.segmentTableView.tableView selectRowAtIndexPath:[self.segmentTableView.tableView indexPathForCell:cell] animated:NO scrollPosition:UITableViewScrollPositionNone];
//            return v;
//        }
//    }
//    return [super hitTest:point withEvent:event];
//}

-(void)reloadData {
    if ([self.delegate respondsToSelector:@selector(topeSpaceInPageSwitchView:)]) {
        self.topeSpace = [self.dataSource topeSpaceInPageSwitchView:self];
    }
    if ([self.dataSource respondsToSelector:@selector(titleHeightInPageSwitchView:)]) {
        self.titleHeight = MIN([self.dataSource titleHeightInPageSwitchView:self], 44);
    }
    self.pageSwitchItemArray = [[self.dataSource pageSwitchItemsInPageSwitchView:self] mutableCopy];
    self.segmentTableView.selectedTitleColor = [UIColor whiteColor];//[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1];
    self.segmentTableView.normalTitleColor =  [UIColor lightGrayColor];
    self.segmentTableView.selectedBgColor = [UIColor blueColor];
    self.segmentTableView.normalBgColor = [UIColor whiteColor];
    [self.segmentTableView reloadData];
    
    
    self.headerView = nil;
    if (self.headerView) {
        self.pageTableView.scrollEnabled = YES;
        BOOL stretching = NO;
        if ([self.dataSource respondsToSelector:@selector(stretchingHeaderInPageSwitchView:)]) {
            stretching = [self.dataSource stretchingHeaderInPageSwitchView:self];
        }
        StretchingHeaderView *sHeaderView = [[StretchingHeaderView alloc]initWithContentView:self.headerView stretching:stretching];
        self.pageTableView.tableHeaderView = sHeaderView;
        sHeaderView.delegate = self;
    }else {
        self.pageTableView.scrollEnabled = NO;
    }
    
    
    
    [self.pageTableView reloadData];
}


-(void)switchNewPageWithNewIndex:(NSUInteger)newIndex {
    if (self.hTableView.currentPageIndex == newIndex || newIndex >= self.pageSwitchItemArray.count) {
        return;
    }
    PageSwitchItem *pageSwitchItem = self.pageSwitchItemArray[self.hTableView.currentPageIndex];
    if (pageSwitchItem.didLoad && [pageSwitchItem.contentViewController respondsToSelector:@selector(pageScrolling)]) {
        [pageSwitchItem.contentViewController pageScrolling];
    }

    self.segmentTableView.currentIndex = newIndex;
}

-(void)switchNewPageWithTitle:(NSString*)title {
    if (self.titleArray && self.titleArray.count>0 && [self.titleArray containsObject:title]) {
        NSUInteger index = [self.titleArray indexOfObject:title];
        [self switchNewPageWithNewIndex:index];
    }
}

-(void)didMoveToSuperview {
    [super didMoveToSuperview]; 
//    self.selfViewController.edgesForExtendedLayout =  UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
//    self.selfViewController.extendedLayoutIncludesOpaqueBars = NO;
//    self.selfViewController.modalPresentationCapturesStatusBarAppearance = NO;
    self.selfViewController.automaticallyAdjustsScrollViewInsets = NO;
//    [self navigationBar_placeholderView];
    if (self.layoutBlock) {
        self.layoutBlock(self.superview);
    }
}

@end

