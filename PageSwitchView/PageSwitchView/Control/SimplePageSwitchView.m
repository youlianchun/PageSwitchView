//
//  PageSwitchView.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/11/30.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "SimplePageSwitchView.h"
#import "HorizontalTableView.h"
#import "_PageSwitchItem.h"
#import "UIGestureRecognizer+Group.h"
#import "SegmentTableView.h"
#import "_TwoScrollView.h"
#import "UIContentViewCell.h"
#import "_PageSwitchView.h"
#import "_PageSwitchViewStatic.h"

#pragma mark -
#pragma mark - PageSwitchView


@interface SimplePageSwitchView ()< UIGestureRecognizerDelegate,
SegmentTableViewDelegate, SegmentTableViewDataSource,
HorizontalTableViewDelegate, HorizontalTableViewDataSource >

@property (nonatomic, retain) HorizontalTableView *hTableView ;

@property (nonatomic, strong) NSMutableArray<PageSwitchItem *>*pageSwitchItemArray;
@property (nonatomic) UIViewController *selfViewController;

@property (nonatomic) SegmentTableView *segmentTableView;
@property (nonatomic) NSLayoutConstraint *segmentTableView_CT;
@property (nonatomic) NSLayoutConstraint *segmentTableView_CH;

@property (nonatomic) CGFloat titleHeight;
//@property (nonatomic) BOOL isScrolling;
@property (nonatomic) UIView *navigationBar_placeholderView;
@property (nonatomic) void(^layoutBlock)(UIView *superView);
@property (nonatomic) NSUInteger sectionCount;
@property (nonatomic) NSMutableArray<NSString*> *titleArray;
@property (nonatomic) void(^titleBarDisplayProgress)(CGFloat progress);
@property (nonatomic, weak) NSLayoutConstraint *layout_CT;
@property (nonatomic, weak) NSLayoutConstraint *layout_CB;
@property (nonatomic, weak) NSLayoutConstraint *layout_CR;
@property (nonatomic, weak) NSLayoutConstraint *layout_CL;
@end

@implementation SimplePageSwitchView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleHeight = kMinTitleBarHeight;
        self.hoverTitleBar = NO;
        self.backgroundColor = [UIColor colorWithWhite:defauleBackgroungColor alpha:1];
    }
    return self;
}

#pragma mark - Get Set

-(id)pageContentView {
    if (self.hTableView.currentPageIndex < self.pageSwitchItemArray.count) {
        PageSwitchItem *item = self.pageSwitchItemArray[self.hTableView.currentPageIndex];
        if (item.didLoad) {
            return item.contentView;
        }
    }
    return nil;
}

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
-(HorizontalTableView *)horizontalTableView {
    return self.hTableView;
}
-(HorizontalTableView *)hTableView {
    if (!_hTableView) {
        _hTableView = [[HorizontalTableView alloc]initWithFrame:CGRectZero];
        _hTableView.delegate = self;
        _hTableView.dataSource = self;
        _hTableView.syncGestureRecognizer = YES;
        [self insertSubview:_hTableView atIndex:0];
        [self addConstraint:_hTableView inserts:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    return _hTableView;
}

-(SegmentTableView *)segmentTableView {
    if (!_segmentTableView) {
        _segmentTableView = [[SegmentTableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.titleHeight)];
        _segmentTableView.backgroundColor = self.backgroundColor;
        _segmentTableView.delegate = self;
        _segmentTableView.dataSource = self;
        _segmentTableView.titleFont = self.titleFont;
        _segmentTableView.selectedTitleColor = self.selectedTitleColor;
        _segmentTableView.normalTitleColor =  self.normalTitleColor;
        _segmentTableView.selectedStyle = self.titleSelectedStyle;
        
        [self addSubview:_segmentTableView];
        _segmentTableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_segmentTableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_segmentTableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        self.segmentTableView_CT = [NSLayoutConstraint constraintWithItem:_segmentTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self addConstraint: self.segmentTableView_CT];
        self.segmentTableView_CH = [NSLayoutConstraint constraintWithItem:_segmentTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.titleHeight];
        [_segmentTableView addConstraint: self.segmentTableView_CH];
    }
    return _segmentTableView;
}
-(UIViewController *)currentViewController {
    return self.pageSwitchItemArray[self.hTableView.currentPageIndex].contentViewController;
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


#pragma mark - HorizontalTableViewDataSource

-(NSUInteger)numberOfRowInTableView:(HorizontalTableView*)tableView {
    return self.pageSwitchItemArray.count;
}

#pragma mark - HorizontalTableViewDelegate
- (void)tableView:(HorizontalTableView*)tableView cellContentView:(UIContentView*)contentView atRowIndex:(NSUInteger )rowIndex isReuse:(BOOL)isReuse {
    __weak UIContentView *wContentView = contentView;
    __weak PageSwitchItem * pageSwitchItem = self.pageSwitchItemArray[rowIndex];
    __weak typeof(self) wself = self;
    pageSwitchItem.didLoadBock = ^{
        CGRect frame = wContentView.bounds;
        [wself.selfViewController addChildViewController:pageSwitchItem.contentViewController];
        if (pageSwitchItem.isPSView) {
            __weak PageSwitchView *pageSwitchView = (PageSwitchView*)pageSwitchItem.contentView;
            pageSwitchView.superTitleHeight = self.titleHeight;
            pageSwitchView.backgroundColor = self.backgroundColor;
            pageSwitchView.tableView.backgroundColor = self.backgroundColor;
            if (pageSwitchView.horizontalScrollEnabled) {
                pageSwitchView.horizontalTableView.syncGestureRecognizer = YES;
                pageSwitchView.didScrollCallBack = ^(){
                    [wself pageSwitchViewDidScroll:pageSwitchView];
                };
            }
        }else {
            frame.origin.y = self.titleHeight;
            frame.size.height -= self.titleHeight;
        }
        if (pageSwitchItem.isScroll) {
            pageSwitchItem.contentView.backgroundColor = self.backgroundColor;
        }
        if (pageSwitchItem.is2Scroll) {
            pageSwitchItem.contentView.backgroundColor = self.backgroundColor;
        }
        pageSwitchItem.contentViewController.view.frame = frame;
        
        if (pageSwitchItem.moveToSuperBock) {
            pageSwitchItem.moveToSuperBock();
        }
        
        if ([pageSwitchItem.contentViewController respondsToSelector:@selector(viewDidAdjustRect)]) {
            [pageSwitchItem.contentViewController viewDidAdjustRect];
        }
        if (pageSwitchItem.contentViewController.view != pageSwitchItem.contentView) {
            [pageSwitchItem.contentView removeFromSuperview];
            [pageSwitchItem.contentViewController.view insertSubview:pageSwitchItem.contentView atIndex:0];
            [wself addConstraint:pageSwitchItem.contentView inserts:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    };

    if (contentView.mountObject != pageSwitchItem) {
        contentView.mountObject = pageSwitchItem;
        [contentView clearSubviews];
        if (pageSwitchItem.didLoad) {
            contentView.content = pageSwitchItem.contentViewController.view;
        }else{
            pageSwitchItem.moveToSuperBock = ^{
                contentView.content = pageSwitchItem.contentViewController.view;
            };
        }
    }
}

-(CGFloat)cellSpaceInTableView:(HorizontalTableView*)tableView {
    return 50;
}

-(void)tableView:(HorizontalTableView *)tableView willDisplayCellView:(UIContentView *)contentView atRowIndex:(NSUInteger )rowIndex {
    PageSwitchItem * pageSwitchItem = self.pageSwitchItemArray[rowIndex];
    pageSwitchItem.isVisible = YES;
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
    if ([self.delegate respondsToSelector:@selector(pageSwitchView:movedToPageIndex:)]) {
        [self.delegate pageSwitchView:self movedToPageIndex:index];
    }
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
    if ([self.delegate respondsToSelector:@selector(pageSwitchView:movedToPageIndex:)]) {
        [self.delegate pageSwitchView:self movedToPageIndex:index];
    }
}

-(UIView*)bgViewInTableView:(SegmentTableView*)tableView atIndex:(NSUInteger)index {
    if ([self.dataSource respondsToSelector:@selector(viewForPageTitleViewInPageSwitchView:atPageIndex:)]) {
        return [self.dataSource viewForPageTitleViewInPageSwitchView:self atPageIndex:index];
    }
    return nil;
}

#pragma mark -
//子page是PageSwitchView时候子page标题显示比例
-(void)pageSwitchViewDidScroll:(PageSwitchView*)pageSwitchView {
    CGFloat maxOffsetY = pageSwitchView.tableView.contentSize.height-pageSwitchView.tableView.bounds.size.height;
    if (!self.hoverTitleBar) {
        CGFloat progress = (maxOffsetY - pageSwitchView.tableView.contentOffset.y) / pageSwitchView.titleHeight;
        progress = MIN(1.0, MAX(0.0, progress));
        self.segmentTableView_CT.constant = -self.titleHeight*(1-progress);
        self.hTableView.syncGestureRecognizer = progress == 1;
    }else {
        CGFloat progress = (maxOffsetY - pageSwitchView.tableView.contentOffset.y - pageSwitchView.titleHeight) / pageSwitchView.titleHeight;
        self.hTableView.syncGestureRecognizer = progress >= 0;
        pageSwitchView.horizontalTableView.tableView.scrollEnabled = progress >= 0;
    }
}


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
            wself.layoutBlock = nil;
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

-(void)reloadData {
    
    if ([self.dataSource respondsToSelector:@selector(titleHeightInPageSwitchView:)]) {
        self.titleHeight = MIN([self.dataSource titleHeightInPageSwitchView:self], kMinTitleBarHeight);
    }
    self.segmentTableView.selectColor = self.titleCellSelectColor;
    
    NSArray<PageSwitchItem*> *arr = [self.dataSource pageSwitchItemsInPageSwitchView:self] ;
    for (PageSwitchItem *item in self.pageSwitchItemArray) {
        if (![arr containsObject:item]) {
            if (item.didLoad) {
                [item.contentViewController removeFromParentViewController];
            }
        }
    }
    self.pageSwitchItemArray = [arr mutableCopy];
    
    self.segmentTableView.allowCellSpace = self.titleCellSpace;
    self.segmentTableView.maxTitleCount = self.maxTitleCount;
    self.segmentTableView.adaptFull_maxTitleCount = self.adaptFull_maxTitleCount;

    self.segmentTableView_CH.constant = self.titleHeight;
    [self.segmentTableView reloadData];
    
    [self.hTableView reloadData];
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

