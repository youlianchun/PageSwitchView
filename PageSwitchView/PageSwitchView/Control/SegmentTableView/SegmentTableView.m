//
//  SegmentTableView.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/14.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "SegmentTableView.h"
#import "GradientColor.h"
#import "PageSwitchViewStatic.h"

#pragma mark -
#pragma mark - _SegmentTableViewCell

@interface _SegmentTableViewCell : UITableViewCell
{
    UILabel *_textLabel;
}
@end

@implementation _SegmentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = self.backgroundColor;
    }
    return self;
}

-(UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.layer.cornerRadius = 2;
        _textLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_textLabel];
        [self addConstraint:_textLabel inserts:UIEdgeInsetsMake(5, 0, -5, 0)];
    }
    return _textLabel;
}

-(void)addConstraint:(UIView*)view inserts:(UIEdgeInsets)inserts {
    UIView *superview = view.superview;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1 constant:inserts.left]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1 constant:inserts.right]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1 constant:inserts.top]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1 constant:inserts.bottom]];
}

@end

#pragma mark -
#pragma mark - SegmentTableView

@interface SegmentTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView   *tableView;
@property (nonatomic) GradientColor *gradientColor;
@property (nonatomic) GradientColor *gradientColor_bg;
@property (nonatomic) NSArray<NSString*> *titleArray;
@property (nonatomic) UIView *cellBgView;
@end

@implementation SegmentTableView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabelWidth = 0;
        _currentIndex = 0;
    }
    return self;
}

#pragma mark - Get Set

-(UIView *)cellBgView {
    if (!_cellBgView) {
        _cellBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 20)];
        _cellBgView.backgroundColor = [UIColor greenColor];
    }
    return _cellBgView;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.backgroundColor = [UIColor grayColor];
        [self addSubview:_tableView];
        [_tableView insertSubview:self.cellBgView atIndex:0];
        _tableView.transform = CGAffineTransformIdentity;//在设置frame前将transform重置
        _tableView.transform = CGAffineTransformMakeRotation(M_PI/-2);
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    }
    return _tableView;
}

-(NSArray<NSString *> *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}

-(UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:self.bounds.size.height/2.2];
    }
    return _titleFont;
}

-(GradientColor *)gradientColor {
    if (!_gradientColor) {
        _gradientColor = [[GradientColor alloc]initWithColorA:self.normalTitleColor colorB:self.selectedTitleColor];
    }
    return _gradientColor;
}
-(GradientColor *)gradientColor_bg {
    if (!_gradientColor_bg) {
        _gradientColor_bg = [[GradientColor alloc]initWithColorA:self.normalBgColor colorB:self.selectedBgColor];
    }
    return _gradientColor_bg;
}

-(void)setCurrentIndex:(NSUInteger)currentIndex {
    if (currentIndex == _currentIndex) {
        return;
    }
    _currentIndex = currentIndex;
    if ([self.delegate respondsToSelector:@selector(segmentTableView:didSelectAtIndex:)]) {
        [self.delegate segmentTableView:self didSelectAtIndex:currentIndex];
    }
    if (currentIndex < self.titleArray.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:currentIndex] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.titleLabelWidth>0) {
        return self.titleLabelWidth;
    }
    NSString *title = self.titleArray[indexPath.section];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName : self.titleFont}];
    return titleSize.width+20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else{
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.titleArray.count-1) {
        return 10;
    }else{
        return 5;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.hidden = YES;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.hidden = YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"SegmentTableViewCellIdentifier_%ld",(long)indexPath.section];
    _SegmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[_SegmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.transform = CGAffineTransformIdentity;
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.titleArray[indexPath.section];
        cell.textLabel.font = self.titleFont;
    }
    if (indexPath.section == self.currentIndex) {
        cell.textLabel.textColor = self.selectedTitleColor;
        cell.textLabel.backgroundColor = self.selectedBgColor;
    }else {
        cell.textLabel.textColor = self.normalTitleColor;
        cell.textLabel.backgroundColor = self.normalBgColor;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL canSelect = YES;
    if ([self.delegate respondsToSelector:@selector(segmentTableView:willSelectAtIndex:)]) {
        canSelect = [self.delegate segmentTableView:self willSelectAtIndex:indexPath.section];
    }
    if (canSelect) {
        //        SegmentTableViewCell *lastCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
        //        lastCell.titleLabel.textColor = [self.gradientColor colorAChangeToColorB:0.0];
        
        self.currentIndex = indexPath.section;
    }
}

#pragma mark -

-(void)reloadData {
    self.titleArray = [self.dataSource titlesOfRowInTableView:self];
    CGRect frame = self.cellBgView.bounds;
    frame.size.height = self.titleLabelWidth;
    self.cellBgView.frame = frame;
    [self.tableView reloadData];
}


-(void)handoverWithLeftPageIndex:(NSUInteger)leftPageIndex leftScale:(CGFloat)leftScale rightPageIndex:(NSUInteger)rightPageIndex rightScale:(CGFloat)rightScale{
    _SegmentTableViewCell *leftCell;
    _SegmentTableViewCell *rightCell;
    CGFloat leftCell_w = 0;
    CGFloat rightCell_w = 0;
    if (leftPageIndex<self.titleArray.count) {
        leftCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:leftPageIndex]];
        CGFloat scale = leftScale <= 0.2 ? 0.0 : leftScale;
        scale = scale >= 0.8 ? 1.0 : scale;
        leftCell.textLabel.textColor = [self.gradientColor colorAChangeToColorB:scale];
        leftCell.textLabel.backgroundColor = [self.gradientColor_bg colorAChangeToColorB:scale];
        leftCell_w = CGRectGetHeight(leftCell.bounds);
    }
    if (rightPageIndex<self.titleArray.count) {
        rightCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:rightPageIndex]];
        CGFloat scale = rightScale <= 0.2 ? 0.0 : rightScale;
        scale = scale >= 0.8 ? 1.0 : scale;
        rightCell.textLabel.textColor = [self.gradientColor colorAChangeToColorB:scale];
        rightCell.textLabel.backgroundColor = [self.gradientColor_bg colorAChangeToColorB:scale];
        rightCell_w = CGRectGetHeight(rightCell.bounds);
    }
    if (leftScale >= 0.8) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:leftPageIndex] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    if (leftCell && rightCell) {
        if (self.titleLabelWidth <= 0) {
            CGFloat wl = CGRectGetWidth(leftCell.bounds);
            CGFloat wr = CGRectGetWidth(rightCell.bounds);
            CGFloat w = wl + (wr - wl) * rightScale;
            CGRect frame = self.cellBgView.bounds;
            frame.size.height = w;
            self.cellBgView.frame = frame;
        }
        CGFloat cyl = leftCell.center.y;
        CGFloat cyr = rightCell.center.y;
        CGFloat cy = cyl + (cyr - cyl) * rightScale;
        self.cellBgView.center = CGPointMake(self.cellBgView.center.x, cy);
    }else {
        if (self.titleLabelWidth <= 0) {
            CGRect frame = self.cellBgView.bounds;
            frame.size.height = CGRectGetWidth(leftCell.bounds);
            self.cellBgView.frame = frame;
        }
        self.cellBgView.center = CGPointMake(self.cellBgView.center.x, leftCell.center.y);
    }
}

-(void)adjustCurrentIndex:(NSUInteger)currentIndex{
    _currentIndex = currentIndex;
}

@end

