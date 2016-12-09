//
//  HorizontalTableView.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/9.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "HorizontalTableView.h"
#import "UIGestureRecognizer+Group.h"
#import "UIScrollView+Other.h"
#import "UIContentViewCell.h"
#import "_PageSwitchViewStatic.h"

#pragma mark -
#pragma mark - _HorizontalTableView
@interface _HorizontalTableView:UITableView <UIGestureRecognizerDelegate>
//@property (nonatomic)UIScrollView *otherScrollView;
@end

@implementation _HorizontalTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.y == 0) {
            return YES;
        }
    }
    if (gestureRecognizer.groupTag.length>0 && [gestureRecognizer.groupTag isEqualToString:otherGestureRecognizer.groupTag]) {
        if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
            self.otherScrollView = (UIScrollView*)otherGestureRecognizer.view;
        }
//        else {
//            self.otherScrollView = nil;
//        }
        return YES;
    }else{
        return NO;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UITableViewWrapperView")] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint p = [otherGestureRecognizer locationInView:otherGestureRecognizer.view];
        if ( p.x >= CGRectGetWidth(otherGestureRecognizer.view.bounds)-30) {
            return YES;
        }
        return NO;
    }
    return NO;
}

@end

#pragma mark -
#pragma mark - HorizontalTableView
@interface HorizontalTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) _HorizontalTableView *tableView ;
@property (nonatomic, strong) NSLayoutConstraint *horizontalTableView_CL;
@property (nonatomic, strong) NSLayoutConstraint *horizontalTableView_CR;
@property (nonatomic, retain) UIView *panelView;

@property (nonatomic, assign) CGFloat cellSpace_2;
@property (nonatomic, assign) NSUInteger cellCount;
@property (nonatomic, assign) NSUInteger initPageIndex;
@property (nonatomic, assign) BOOL syncGestureRecognizer;//兼容内外水平滑动手势
@end

@implementation HorizontalTableView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

-(void)initialization {
    self.clipsToBounds = YES;
    self.initPageIndex = 0;
    self.tableView = [[_HorizontalTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = self.backgroundColor;
    self.tableView.opaque = self.opaque;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollsToTop = NO;
    self.tableView.bounces = NO;
    if (self.syncGestureRecognizer) {
        self.tableView.panGestureRecognizer.groupTag = kUIGestureRecognizer_H;
    }
    self.tableView.panGestureRecognizer.maximumNumberOfTouches = 1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addSubview:self.tableView];

    self.tableView.pagingEnabled = YES;
    self.tableView.transform = CGAffineTransformIdentity;//在设置frame前将transform重置
    self.tableView.transform = CGAffineTransformMakeRotation(M_PI/-2);
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.panelView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.panelView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
}

#pragma mark - Get Set

-(UIView *)panelView {
    if (!_panelView) {
        _panelView = [[UIView alloc]init];
        _panelView.hidden = YES;
        [self addSubview:_panelView];
        _panelView.translatesAutoresizingMaskIntoConstraints = NO;
        self.horizontalTableView_CL = [NSLayoutConstraint constraintWithItem:_panelView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        self.horizontalTableView_CR = [NSLayoutConstraint constraintWithItem:_panelView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_panelView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_panelView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self addConstraint:self.horizontalTableView_CL];
        [self addConstraint:self.horizontalTableView_CR];
    }
    return _panelView;
}

-(void)setCellSpace_2:(CGFloat)cellSpace_2 {
    _cellSpace_2 = cellSpace_2;
    self.horizontalTableView_CL.constant = -_cellSpace_2;
    self.horizontalTableView_CR.constant = _cellSpace_2;
}

-(NSUInteger)currentPageIndex {
    return (self.tableView.contentOffset.y+CGRectGetHeight(self.tableView.bounds)/2.0)/CGRectGetHeight(self.tableView.bounds);
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"HorizontalTableViewCellIdentifier_%ld",(long)indexPath.section];
    BOOL isReuse = YES;
    UIContentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UIContentViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        isReuse = NO;
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        cell.opaque = self.opaque;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformIdentity;
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        cell.layer.shadowOffset = CGSizeMake(0, 2);
        cell.layer.shadowOpacity = 0.50;
    }
    [self.dataSource tableView:self cellContentView:cell.view atRowIndex:indexPath.section isReuse:isReuse];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size.width;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.cellSpace_2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.cellSpace_2;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.hidden = YES;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.hidden = YES;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UIContentViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCellView:atRowIndex:)]) {
        [self.delegate tableView:self willDisplayCellView:cell.view atRowIndex:indexPath.section];
    }
    if (self.initPageIndex == indexPath.section) {
        [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:tableView afterDelay:0.001 inModes: [NSArray arrayWithObject:NSRunLoopCommonModes]];//延迟处理，等待界面显示完成,需要切换到应用主RunLoop
        self.initPageIndex = kNull_PageIndex;
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UIContentViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCellView:atRowIndex:)]) {
        [self.delegate tableView:self didEndDisplayingCellView:cell.view atRowIndex:indexPath.section];
    }
}

#pragma mark UITableViewDelegate_Scroll

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(tableView:didScrollToPageIndex:)]) {
        [self.delegate tableView:self didScrollToPageIndex:self.currentPageIndex];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(tableView:didScrollWithLeftPageIndex:leftScale:rightPageIndex:rightScale:)]) {
        CGFloat tempProgress = scrollView.contentOffset.y / scrollView.bounds.size.height;
        NSUInteger lIndex = floor(tempProgress);//左边页下标//只有一页时候为左边页
        NSUInteger rIndex = lIndex+1;//右边边页下标
        CGFloat rScale = tempProgress - lIndex;//左边页显示比例
        CGFloat lScale = 1 - rScale;//右边页显示
        [self.delegate tableView:self didScrollWithLeftPageIndex:lIndex leftScale:lScale rightPageIndex:rIndex rightScale:rScale];
    }
    
    if (self.syncGestureRecognizer) {
        //内外水平滑动兼容
        if (scrollView.isAncestorOfOtherScrollView) {
            //        外部
            if (scrollView.otherScrollView.contentOffset.y < 0 || scrollView.otherScrollView.contentOffset.y > scrollView.contentSize.height - CGRectGetHeight(scrollView.otherScrollView.bounds)) {
                NSUInteger index = [HorizontalTableView indexWithScrollView:scrollView];
                scrollView.contentOffset = CGPointMake(0, index*scrollView.bounds.size.height);
            }else{
                UIScrollView *descendantScrollView = scrollView.otherScrollView;
                NSUInteger index_descendant = [HorizontalTableView indexWithScrollView:descendantScrollView];
                if (descendantScrollView.contentOffset.y != index_descendant * descendantScrollView.bounds.size.height) {//内部处于滑动状态
                    NSUInteger index_ancestor = [HorizontalTableView indexWithScrollView:scrollView];
                    scrollView.contentOffset = CGPointMake(0, index_ancestor*scrollView.bounds.size.height);
                }
            }
        }else if (scrollView.isDescendantOfOtherScrollView) {
            //        内部
            if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds)) {
                UIScrollView *ancestorScrollView = scrollView.otherScrollView;
                NSUInteger index_ancestor = [HorizontalTableView indexWithScrollView:ancestorScrollView];
                ancestorScrollView.contentOffset = CGPointMake(0, index_ancestor*ancestorScrollView.bounds.size.height);
            }
        }
    }
}

#pragma mark -
- (void)scrollToRowAtIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < self.cellCount) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
        self.initPageIndex = index;
    }
}

- (void)reloadData {
    if ([self.dataSource respondsToSelector:@selector(cellSpaceInTableView:)]) {
        self.cellSpace_2 = ABS([self.dataSource cellSpaceInTableView:self])/2.0;
    }else {
        self.cellSpace_2 = 0;
    }
    self.cellCount = [self.dataSource numberOfRowInTableView:self];
    [self.tableView reloadData];
}

+(NSUInteger)indexWithScrollView:(UIScrollView*)scrollView {
    return  (scrollView.contentOffset.y+CGRectGetHeight(scrollView.bounds)/2.0)/CGRectGetHeight(scrollView.bounds);
}
@end


