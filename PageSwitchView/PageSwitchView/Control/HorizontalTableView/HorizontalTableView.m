//
//  HorizontalTableView.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/9.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "HorizontalTableView.h"
#pragma mark - _HorizontalTableView
@interface _HorizontalTableView:UITableView
@end

@implementation _HorizontalTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.y == 0) {
            return YES;
        }
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

#pragma mark - _HorizontalTableViewCell
@interface _HorizontalTableViewCell : UITableViewCell
@property (nonatomic) UIContentView *view;
@end

@implementation _HorizontalTableViewCell
-(UIContentView *)view {
    if (!_view) {
        _view = [[UIContentView alloc]init];
        _view.backgroundColor = [UIColor clearColor];
        _view.opaque = false;
        [self.contentView addSubview:_view];
        _view.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    return _view;
}
@end

#pragma mark - HorizontalTableView
@interface HorizontalTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) _HorizontalTableView *tableView ;
@property (nonatomic, strong) NSLayoutConstraint *horizontalTableView_CL;
@property (nonatomic, strong) NSLayoutConstraint *horizontalTableView_CR;
@property (nonatomic, retain) UIView *panelView;

@property (nonatomic, assign) CGFloat cellSpace_2;
@property (nonatomic, assign) NSUInteger cellCount;
@property (nonatomic, assign) NSUInteger initPageIndex;
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
    self.clipsToBounds = true;
    self.initPageIndex = 0;
    self.tableView = [[_HorizontalTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = self.backgroundColor;
    self.tableView.opaque = self.opaque;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = false;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.scrollsToTop = false;
    self.tableView.bounces = false;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addSubview:self.tableView];

    self.tableView.pagingEnabled = true;
    self.tableView.transform = CGAffineTransformIdentity;//在设置frame前将transform重置
    self.tableView.transform = CGAffineTransformMakeRotation(M_PI/-2);
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.panelView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.panelView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
}


-(UIView *)panelView {
    if (!_panelView) {
        _panelView = [[UIView alloc]init];
        _panelView.hidden = true;
        [self addSubview:_panelView];
        _panelView.translatesAutoresizingMaskIntoConstraints = false;
        self.horizontalTableView_CL = [NSLayoutConstraint constraintWithItem:_panelView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        self.horizontalTableView_CR = [NSLayoutConstraint constraintWithItem:_panelView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_panelView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_panelView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self addConstraint:self.horizontalTableView_CL];
        [self addConstraint:self.horizontalTableView_CR];
    }
    return _panelView;
}

- (void)reloadData {
    if ([self.delegate respondsToSelector:@selector(cellSpaceInTableView:)]) {
        self.cellSpace_2 = [self.delegate cellSpaceInTableView:self]/2.0;
    }else {
        self.cellSpace_2 = 0;
    }
    self.cellCount = [self.dataSource numberOfRowInTableView:self];
    [self.tableView reloadData];
}

-(void)setCellSpace_2:(CGFloat)cellSpace_2 {
    _cellSpace_2 = cellSpace_2;
    self.horizontalTableView_CL.constant = -_cellSpace_2;
    self.horizontalTableView_CR.constant = _cellSpace_2;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"HorizontalTableViewCellIdentifier_%ld",(long)indexPath.section];
    BOOL isReuse = true;
    _HorizontalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[_HorizontalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        isReuse = false;
        cell.backgroundColor = self.backgroundColor;
        cell.opaque = self.opaque;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformIdentity;
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    [self.delegate tableView:self cellContentView:cell.view atRowIndex:indexPath.section isReuse:isReuse];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size.width;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.cellSpace_2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.cellSpace_2;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.hidden = true;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.hidden = true;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(_HorizontalTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCellView:atRowIndex:)]) {
        [self.delegate tableView:self willDisplayCellView:cell.view atRowIndex:indexPath.section];
    }
    if (self.initPageIndex == indexPath.section) {
        [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:tableView afterDelay:0.001];
        self.initPageIndex = 9999999999;
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(_HorizontalTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCellView:atRowIndex:)]) {
        [self.delegate tableView:self didEndDisplayingCellView:cell.view atRowIndex:indexPath.section];
    }
}

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
}

- (void)scrollToRowAtIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < self.cellCount) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
        self.initPageIndex = index;
    }
}

-(NSUInteger)currentPageIndex {
    return (self.tableView.contentOffset.y+CGRectGetHeight(self.tableView.bounds)/2.0)/CGRectGetHeight(self.tableView.bounds);
}

@end


