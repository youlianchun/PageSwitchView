//
//  PageSwitchView.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/11/30.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "_PageSwitchView.h"
#import "HorizontalTableView.h"
#import "_PageSwitchItem.h"
#import "UIGestureRecognizer+Group.h"
#import "SegmentTableView.h"
#import "StretchingHeaderView.h"
#import "_TwoScrollView.h"
#import "UIContentViewCell.h"
#import "_PageSwitchViewStatic.h"

#pragma mark -
#pragma mark - _PageSwitchView

@interface _PageSwitchView:UITableView
@property (nonatomic)UIScrollView *otherScrollView;
@property (nonatomic)CGPoint velocity;
@end

@implementation _PageSwitchView

-(void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self.panGestureRecognizer addTarget:self action:@selector(__handlePan:)];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.groupTag.length>0 && [gestureRecognizer.groupTag isEqualToString:otherGestureRecognizer.groupTag]) {
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

-(void)setTableHeaderView:(UIView *)tableHeaderView {
    BOOL b = [tableHeaderView isKindOfClass:[StretchingHeaderView class]];
    NSAssert(b, @"请采用代理设置header，不能另外设置");
    [super setTableHeaderView:tableHeaderView];
}

-(void)__handlePan:(UIPanGestureRecognizer*)gestureRecognizer{
    CGPoint p = [gestureRecognizer velocityInView:self];
    self.velocity = p;
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        self.velocity = CGPointZero;
    }
}

@end

#pragma mark -
#pragma mark - PageSwitchView


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
//@property (nonatomic) BOOL isScrolling;
@property (nonatomic) UIView *navigationBar_placeholderView;
@property (nonatomic) void(^layoutBlock)(UIView *superView);
@property (nonatomic) NSUInteger sectionCount;
@property (nonatomic) NSMutableArray<NSString*> *titleArray;
@property (nonatomic, weak) NSLayoutConstraint *layout_CT;
@property (nonatomic, weak) NSLayoutConstraint *layout_CB;
@property (nonatomic, weak) NSLayoutConstraint *layout_CR;
@property (nonatomic, weak) NSLayoutConstraint *layout_CL;
@end

@implementation PageSwitchView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.topeSpace = 0;
        self.titleHeight = kMinTitleBarHeight;
        self.backgroundColor = [UIColor colorWithWhite:defauleBackgroungColor alpha:1];
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
-(HorizontalTableView *)horizontalTableView {
    return self.hTableView;
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
        _segmentTableView.delegate = self;
        _segmentTableView.dataSource = self;
        _segmentTableView.titleFont = self.titleFont;
        _segmentTableView.selectedTitleColor = self.selectedTitleColor;
        _segmentTableView.normalTitleColor =  self.normalTitleColor;
        _segmentTableView.selectedStyle = self.titleSelectedStyle;
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

-(UITableView *)tableView {
    return self.pageTableView;
}

#pragma mark - StretchingHeaderViewDelegate
-(void)stretchingHeaderView:(StretchingHeaderView*)stretchingHeaderView displayProgress:(CGFloat)progress{
    if ([self.delegate respondsToSelector:@selector(pageSwitchView:headerDisplayProgress:)]) {
        [self.delegate pageSwitchView:self headerDisplayProgress:progress];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionCount = self.pageSwitchItemArray.count > 0 ? 2 : 1;//2;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sectionCount += [self.dataSource numberOfSectionsInTableView:self];
    }
    self.sectionCount = sectionCount;
    return sectionCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger sectionCount = self.sectionCount;
    if (self.pageSwitchItemArray.count > 0) {
        if (section >= sectionCount - 2) {
            return  1;
        }
    }else{
        if (section >= sectionCount - 1) {
            return  1;
        }
    }
    if ([self.dataSource respondsToSelector:@selector(pageSwitchView:numberOfRowsInSection:)]) {
        return [self.dataSource pageSwitchView:self numberOfRowsInSection:section];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sectionCount = self.sectionCount;
    if (self.pageSwitchItemArray.count > 0) {
        if (indexPath.section == sectionCount-1) {
            static NSString *identifier = @"CellIdentifier_PageSwitch";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:self.hTableView];
                [self addConstraint:self.hTableView inserts:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
            [self.hTableView reloadData];
            return cell;
        }
        if (indexPath.section == sectionCount-2) {
            static NSString *identifier = @"CellIdentifier_Placeholder";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.alpha = 0;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
    }else{
        if (indexPath.section == sectionCount-1) {
            static NSString *identifier = @"CellIdentifier_Empty";
            BOOL isReuse = YES;
            UIContentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UIContentViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                isReuse = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                CGRect bounds = self.bounds;
                bounds.size.height -= self.superTitleHeight;
                cell.view.bounds = bounds;
            }
            if ([self.dataSource respondsToSelector:@selector(pageSwitchView:cellContentView:atIndexPath:isReuse:)]) {
                [self.dataSource pageSwitchView:self emptyPageContentView:cell.view isReuse:isReuse];
            }
            return cell;
        }
    }
    static NSString *identifier = @"CellIdentifier_Other";
    BOOL isReuse = YES;
    UIContentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UIContentViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        isReuse = NO;
        cell.backgroundColor = self.backgroundColor;
    }
    if ([self.dataSource respondsToSelector:@selector(pageSwitchView:cellContentView:atIndexPath:isReuse:)]) {
        [self.dataSource pageSwitchView:self cellContentView:cell.view atIndexPath:indexPath isReuse:isReuse];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSInteger sectionCount = self.sectionCount;
    if (self.pageSwitchItemArray.count > 0) {
        if (section >= sectionCount - 2) {
            if (self.topeSpace < 0 && section == sectionCount - 2) {//标题不悬停
                return  self.segmentTableView;
            }
            if (self.topeSpace >= 0 && section == sectionCount - 1) {//标题悬停
                return  self.segmentTableView;
            }
            return nil;
        }
    }else {
        if (section >= sectionCount - 1) {
            UIView *view = [[UIView alloc]init];
            view.alpha = 0;
            return view;
        }
    }
    if ([self.dataSource respondsToSelector:@selector(pageSwitchView:viewForHeaderInSection:)]) {
        return [self.dataSource pageSwitchView:self viewForHeaderInSection:section];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger sectionCount = self.sectionCount;
    if (self.pageSwitchItemArray.count > 0) {
        if (section >= sectionCount - 2) {
            if (self.topeSpace < 0 && section == sectionCount - 2) {//标题不悬停
                return  self.titleHeight;
            }
            if (self.topeSpace >= 0 && section == sectionCount - 1) {//标题悬停
                return  self.titleHeight;
            }
            return 0;
        }
    }else{
        if (section >= sectionCount - 1) {
            return 5;
        }
    }
    if ([self.dataSource respondsToSelector:@selector(pageSwitchView:heightForHeaderInSection:)]) {
        return [self.dataSource pageSwitchView:self heightForHeaderInSection:section];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sectionCount = self.sectionCount;
    if (self.pageSwitchItemArray.count > 0) {
        if (indexPath.section >= sectionCount - 2) {
            if (indexPath.section == sectionCount-2) {
                return  0;
            }
            if (indexPath.section == sectionCount-1) {
                return  CGRectGetHeight(self.bounds)-CGRectGetHeight(self.segmentTableView.bounds)-self.topeSpace;
            }
            return 0;
        }
    }else{
        if (indexPath.section >= sectionCount - 1) {
            return  CGRectGetHeight(self.bounds)-self.superTitleHeight;
        }
    }
    if ([self.dataSource respondsToSelector:@selector(pageSwitchView:heightForRowAtIndexPath:)]) {
        CGFloat h = [self.dataSource pageSwitchView:self heightForRowAtIndexPath:indexPath];
        if (h>0) {
            self.pageTableView.scrollEnabled = true;
        }
        return h;
    }
    return 0;
}

#pragma mark UITableViewDelegate_Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.pageSwitchItemArray.count > 0) {
        //    if (self.pageTableView.scrollEnabled) {
        PageSwitchItem *item = self.contentPageSwitchItem;
        CGFloat maxOffsetY = self.pageTableView.contentSize.height-self.pageTableView.bounds.size.height;
        if (item.isScroll || item.is2Scroll) {//滚动视图
            UIScrollView *contentScrollView =  self.pageTableView.otherScrollView;//(UIScrollView*)item.contentView;
            
            if (scrollView == self.pageTableView) {//滚动外部视图
                //                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                //                [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.2];
                //                self.isScrolling = YES ;
                
                static CGFloat lastContentOffset_y=0;
                if (scrollView.contentOffset.y<lastContentOffset_y) {//向下
                    if (contentScrollView && contentScrollView.contentOffset.y > 0) {
                        self.pageTableView.contentOffset = CGPointMake(0.0f, maxOffsetY);
                    }else{
                        CGFloat offsetY = scrollView.contentOffset.y;
                        if(offsetY <= maxOffsetY) {
                            contentScrollView.contentOffset = CGPointZero;
                        }
                    }
                } else if (scrollView.contentOffset.y>lastContentOffset_y) {//向上
                    if (self.pageTableView.contentOffset.y >= maxOffsetY) {
                        self.pageTableView.contentOffset = CGPointMake(0.0f, maxOffsetY);
                    }
                }
                if (self.didScrollCallBack) {
                    self.didScrollCallBack();
                }
                lastContentOffset_y = scrollView.contentOffset.y;
                
            }
            else if (scrollView == contentScrollView) {//滚动里面视图
                if (self.pageTableView.contentOffset.y < maxOffsetY) {
                    
                    scrollView.contentOffset = CGPointZero;
                    scrollView.showsVerticalScrollIndicator = NO;
                }else {
                    self.pageTableView.contentOffset = CGPointMake(0.0f, maxOffsetY);
                    scrollView.showsVerticalScrollIndicator = YES;
                }
            }
        }else{//普通视图
            //            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            //            [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.2];
            //            self.isScrolling = YES ;
            
            //            static CGFloat lastContentOffset_y=0;
            //            if (scrollView.contentOffset.y<lastContentOffset_y) {//向下
            //
            //            } else if (scrollView.contentOffset.y>lastContentOffset_y) {//向上
            //                if (self.pageTableView.contentOffset.y >= maxOffsetY) {
            //                    self.pageTableView.contentOffset = CGPointMake(0.0f, maxOffsetY);
            //                }
            //            }
            //            lastContentOffset_y = scrollView.contentOffset.y;
        }
        //    }
    }
        static CGFloat offset_Y_last = 0;
        CGFloat offset_Y = self.pageTableView.contentOffset.y;
        if (self.pageTableView.otherScrollView) {
            CGFloat offset_y = self.pageTableView.otherScrollView.contentOffset.y;
            offset_Y += MAX(offset_y, 0);
        }
        if (offset_Y_last != offset_Y) {
            if ([self.delegate respondsToSelector:@selector(pageSwitchViewDidScroll:contentOffset:velocity:)]) {
                [self.delegate pageSwitchViewDidScroll:self contentOffset:CGPointMake(0, offset_Y) velocity:self.pageTableView.velocity];
            }
        }
        offset_Y_last = offset_Y;
    
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
            [wself.selfViewController addChildViewController:pageSwitchItem.contentViewController];
            if (pageSwitchItem.isScroll) {
                UIScrollView *scrollView =  (UIScrollView *)pageSwitchItem.contentView;
                scrollView.panGestureRecognizer.groupTag = kUIGestureRecognizer_V;
                scrollView.backgroundColor = self.backgroundColor;
            }
            if (pageSwitchItem.is2Scroll) {
                TwoScrollView *twoScrollView = (TwoScrollView*)pageSwitchItem.contentView;
                twoScrollView.panGestureRecognizerGroupTag = kUIGestureRecognizer_V;
                twoScrollView.haveHeader = self.headerView != nil;
                twoScrollView.backgroundColor = self.backgroundColor;
            }
            pageSwitchItem.scrollDelegate = wself;
            
            [wContentView addSubview:pageSwitchItem.contentViewController.view];
            pageSwitchItem.contentViewController.view.frame = wContentView.bounds;
            if ([pageSwitchItem.contentViewController respondsToSelector:@selector(viewDidAdjustRect)]) {
                [pageSwitchItem.contentViewController viewDidAdjustRect];
            }
            if (pageSwitchItem.contentViewController.view != pageSwitchItem.contentView) {
                [pageSwitchItem.contentView removeFromSuperview];
                [pageSwitchItem.contentViewController.view insertSubview:pageSwitchItem.contentView atIndex:0];
//                [pageSwitchItem.contentViewController.view addSubview:pageSwitchItem.contentView];
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
        if (wself.layout_CT) {
            wself.layout_CT.constant = inserts.top;
            wself.layout_CL.constant = inserts.left;
            wself.layout_CR.constant = inserts.right;
            wself.layout_CB.constant = inserts.bottom;
        }else{
            wself.translatesAutoresizingMaskIntoConstraints = NO;
            wself.layout_CT = [NSLayoutConstraint constraintWithItem:wself attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1 constant:inserts.top];
            wself.layout_CL = [NSLayoutConstraint constraintWithItem:wself attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1 constant:inserts.left];
            wself.layout_CR = [NSLayoutConstraint constraintWithItem:wself attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1 constant:inserts.right];
            wself.layout_CB =  [NSLayoutConstraint constraintWithItem:wself attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1 constant:inserts.bottom];
            [superview addConstraint:wself.layout_CT];
            [superview addConstraint:wself.layout_CL];
            [superview addConstraint:wself.layout_CR];
            [superview addConstraint:wself.layout_CB];
            wself.layoutBlock = nil;
        }
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
    self.pageSwitchItemArray = [[self.dataSource pageSwitchItemsInPageSwitchView:self] mutableCopy];
    if (self.pageSwitchItemArray.count > 0) {
        if ([self.delegate respondsToSelector:@selector(topeSpaceInPageSwitchView:)]) {
            self.topeSpace = [self.dataSource topeSpaceInPageSwitchView:self];
        }
        if ([self.dataSource respondsToSelector:@selector(titleHeightInPageSwitchView:)]) {
            self.titleHeight = MIN([self.dataSource titleHeightInPageSwitchView:self], kMinTitleBarHeight);
        }
        
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
        self.segmentTableView.selectColor = self.titleCellSelectColor;
        self.segmentTableView.allowCellSpace = self.titleCellSpace;
        self.segmentTableView.maxTitleCount = self.maxTitleCount;
        self.segmentTableView.adaptFull_maxTitleCount = self.adaptFull_maxTitleCount;
        [self.segmentTableView reloadData];
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

-(void)setNumber:(NSInteger)number atIndex:(NSUInteger)index {
    if (self.titleArray && self.titleArray.count>index) {
        if (index == self.hTableView.currentPageIndex && number != 0) {//当前页不添加红点
            return;
        }
        [self.segmentTableView setNumber:number atIndex:index];
    }
}

-(void)setNumber:(NSInteger)number atTitle:(NSString*)title {
    if ([self.titleArray containsObject:title]) {
        NSInteger index = [self.titleArray indexOfObject:title];
        if (index == self.hTableView.currentPageIndex && number != 0) {//当前页不添加红点
            return;
        }
        [self.segmentTableView setNumber:number atIndex:index];
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

