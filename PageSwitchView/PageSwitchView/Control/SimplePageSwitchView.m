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
#import "PageSwitchViewStatic.h"
#import "_PageSwitchView.h"

#pragma mark -
#pragma mark - PageSwitchView

static const NSUInteger kMaxTitleCount_unAdapt = 5;
static const CGFloat kMinTitleBarHeight = 44;

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
@property (nonatomic) BOOL adaptTitleWidth;
@property (nonatomic) void(^titleBarDisplayProgress)(CGFloat progress);
@end

@implementation SimplePageSwitchView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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

-(HorizontalTableView *)hTableView {
    if (!_hTableView) {
        _hTableView = [[HorizontalTableView alloc]initWithFrame:CGRectZero];
        _hTableView.delegate = self;
        _hTableView.dataSource = self;
        [self insertSubview:_hTableView atIndex:0];
        [self addConstraint:_hTableView inserts:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    return _hTableView;
}
-(SegmentTableView *)segmentTableView {
    if (!_segmentTableView) {
        _segmentTableView = [[SegmentTableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.titleHeight)];
        _segmentTableView.backgroundColor = [UIColor orangeColor];
        _segmentTableView.delegate = self;
        _segmentTableView.dataSource = self;
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



-(PageSwitchItem *)contentPageSwitchItem {
    NSUInteger currentPageIndex = self.hTableView.currentPageIndex;
    return  self.pageSwitchItemArray[currentPageIndex];
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
    if (!isReuse) {
        __weak UIContentView *wContentView = contentView;
        __weak PageSwitchItem * pageSwitchItem = self.pageSwitchItemArray[rowIndex];
        __weak typeof(self) wself = self;
        pageSwitchItem.didLoadBock = ^{
//            if (pageSwitchItem.isScroll) {
//                UIScrollView *scrollView =  (UIScrollView *)pageSwitchItem.contentView;
//                scrollView.panGestureRecognizer.groupTag = kUIGestureRecognizer_V;
//            }
//            if (pageSwitchItem.is2Scroll) {
//                TwoScrollView *twoScrollView = (TwoScrollView*)pageSwitchItem.contentView;
//                twoScrollView.panGestureRecognizerGroupTag = kUIGestureRecognizer_V;
//                twoScrollView.haveHeader = self.headerView != nil;
//            }
            
            CGRect frame = wContentView.bounds;
            if (pageSwitchItem.isPSView) {
                PageSwitchView *pageSwitchView = (PageSwitchView*)pageSwitchItem.contentView;
                pageSwitchView.titleBarDisplayProgress = ^(CGFloat progress){
                    [wself subPageTitleDisplayProgressIfIsPageSwitchView:progress];
                };
            }else {
                frame.origin.y = self.titleHeight;
                frame.size.height -= self.titleHeight;
            }
            [wself.selfViewController addChildViewController:pageSwitchItem.contentViewController];
//            pageSwitchItem.scrollDelegate = wself;
            
            [wContentView addSubview:pageSwitchItem.contentViewController.view];
            pageSwitchItem.contentViewController.view.frame = frame;
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
//子page是PageSwitchView时候子page标题显示比例
-(void)subPageTitleDisplayProgressIfIsPageSwitchView:(CGFloat)progress {
    printf("%f\n",progress);
    self.segmentTableView_CT.constant = -self.titleHeight*(1-progress);
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

-(void)reloadData {
    if ([self.dataSource respondsToSelector:@selector(adaptTitleWidthInPageSwitchView:)]) {
        self.adaptTitleWidth = [self.dataSource adaptTitleWidthInPageSwitchView:self];
    }

    if ([self.dataSource respondsToSelector:@selector(titleHeightInPageSwitchView:)]) {
        self.titleHeight = MIN([self.dataSource titleHeightInPageSwitchView:self], kMinTitleBarHeight);
    }
    self.pageSwitchItemArray = [[self.dataSource pageSwitchItemsInPageSwitchView:self] mutableCopy];
    self.segmentTableView.selectedTitleColor = [UIColor whiteColor];//[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1];
    self.segmentTableView.normalTitleColor =  [UIColor lightGrayColor];
    self.segmentTableView.selectedBgColor = [UIColor blueColor];
    self.segmentTableView.normalBgColor = [UIColor whiteColor];
    
        
    if (self.adaptTitleWidth) {
        self.adaptTitleWidth = 0;
    }else {
        self.segmentTableView.titleLabelWidth = self.bounds.size.width/MIN(self.pageSwitchItemArray.count, kMaxTitleCount_unAdapt);
    }
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

