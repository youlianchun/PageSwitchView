//
//  SegmentTableView.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/14.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "SegmentTableView.h"
#import "GradientColor.h"

#pragma mark -
#pragma mark - _SegmentTableViewCell

static const CGFloat fontSize = 7;
static const CGFloat height = 8;

@interface _SegmentTableViewCell : UITableViewCell
{
    UILabel *_textLabel;
    UILabel *_markLabel;
}
@property (nonatomic) NSInteger number;
@property (nonatomic) UILabel *markLabel;
@property (nonatomic) NSLayoutConstraint *markLabel_CW;
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
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self.contentView  addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView  attribute:NSLayoutAttributeLeft multiplier:1 constant:7]];
        [self.contentView  addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView  attribute:NSLayoutAttributeRight multiplier:1 constant:-7]];
        
        [self markLabel];
    }
    return _textLabel;
}

-(UILabel*)markLabel {
    if (!_markLabel) {
        _markLabel = [[UILabel alloc]init];
        _markLabel.font = [UIFont systemFontOfSize:fontSize];
        _markLabel.textColor = [UIColor whiteColor];
        _markLabel.textAlignment = NSTextAlignmentCenter;
        _markLabel.backgroundColor = [UIColor redColor];
        _markLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _markLabel.layer.cornerRadius = height/2.0;
        _markLabel.layer.masksToBounds = YES;
        _markLabel.hidden = YES;
        [self.contentView addSubview:_markLabel];
        [_markLabel addConstraint:[NSLayoutConstraint constraintWithItem:_markLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height]];
        self.markLabel_CW = [NSLayoutConstraint constraintWithItem:_markLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
        [_markLabel addConstraint:self.markLabel_CW];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_markLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_markLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    }
    return _markLabel;
}

-(void)setNumber:(NSInteger)number {
    _number = number;
    self.markLabel.hidden = number == 0;
    CGFloat width = height;
    CGFloat unit = fontSize-1;
    NSString *text;
    if (number <= 0) {
        text = @"";
    }else
    if (number > 0 && number < 100) {
        width = unit+unit;
        text = [NSString stringWithFormat:@"%ld",number];
    }else {
        width = unit+unit+unit;
        text = @"99+";

    }
    self.markLabel_CW.constant = width;
    self.markLabel.text = text;
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

static const CGFloat bottomSpace = -5;
@interface SegmentTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView   *tableView;
@property (nonatomic) GradientColor *gradientColor;
//@property (nonatomic) GradientColor *gradientColor_bg;
@property (nonatomic) NSArray<NSString*> *titleArray;
@property (nonatomic) UIView *cellBgView;
@property (nonatomic) UIView *cellLineView;
@property (nonatomic) UIImageView *cellImageView;
@property (nonatomic) CAShapeLayer *cellImageView_layer;
@property (nonatomic) CGFloat titleLabelWidth;

@property (nonatomic) UIView *panelView;

@end

@implementation SegmentTableView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabelWidth = 0;
        _currentIndex = 0;
        self.selectedStyle = SegmentSelectedStyleNone;
    }
    return self;
}

#pragma mark - Get Set
-(void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    if (self.cellImageView_layer) {
        self.cellImageView_layer.fillColor = backgroundColor.CGColor;
    }
}
-(UIColor *)selectedTitleColor {
    if (!_selectedTitleColor) {
        _selectedTitleColor = [UIColor blackColor];
    }
    return _selectedTitleColor;
}
-(UIColor *)normalTitleColor {
    if (!_normalTitleColor) {
        _normalTitleColor = [UIColor lightGrayColor];
    }
    return _normalTitleColor;
}
-(UIColor *)selectColor {
    if (!_selectColor) {
        _selectColor = [UIColor orangeColor];
    }
    return _selectColor;
}
-(UIView *)cellBgView {
    if (!_cellBgView) {
        _cellBgView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, self.bounds.size.height+bottomSpace - 10, 20)];
        _cellBgView.backgroundColor = self.selectColor;
        _cellBgView.layer.cornerRadius = 4;
        _cellBgView.layer.masksToBounds = YES;
        _cellBgView.hidden = self.selectedStyle != SegmentSelectedStyleBackground;

    }
    return _cellBgView;
}
-(UIView *)cellLineView {
    if (!_cellLineView) {
        _cellLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 20)];
        _cellLineView.backgroundColor = self.selectColor;
        _cellLineView.hidden = self.selectedStyle != SegmentSelectedStyleUnderline;
    }
    return _cellLineView;
}

-(UIImageView *)cellImageView {
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 24)];
        CAShapeLayer *imgLayer = [[CAShapeLayer alloc]init];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, 0, 0);
        CGPathAddLineToPoint(path, nil, 8, 12);
        CGPathAddLineToPoint(path, nil, 0, 24);
        CGPathAddLineToPoint(path, nil, 0, 0);
        imgLayer.path = path;
        CGPathRelease(path);
        imgLayer.fillColor = self.backgroundColor.CGColor;
        [_cellImageView.layer addSublayer:imgLayer];
        _cellImageView.hidden = self.selectedStyle != SegmentSelectedStyleSubscript;
        self.cellImageView_layer = imgLayer;
    }
    return _cellImageView;
}

-(UIView *)panelView {
    if (!_panelView) {
        _panelView = [[UIView alloc]init];
        [self addSubview:_panelView];
        _panelView.backgroundColor = [UIColor blackColor];
        _panelView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_panelView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_panelView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_panelView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_panelView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:bottomSpace]];
    }
    return _panelView;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.panelView addSubview:_tableView];
        [_tableView insertSubview:self.cellBgView atIndex:0];
        [_tableView insertSubview:self.cellLineView atIndex:0];
        [_tableView addSubview:self.cellImageView];
        _tableView.transform = CGAffineTransformIdentity;//在设置frame前将transform重置
        _tableView.transform = CGAffineTransformMakeRotation(M_PI/-2);
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.panelView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.panelView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self.panelView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.panelView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self.panelView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.panelView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        [self.panelView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.panelView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
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
        _titleFont = [UIFont systemFontOfSize:(self.bounds.size.height+bottomSpace)/2.2];
    }
    return _titleFont;
}

-(GradientColor *)gradientColor {
    if (!_gradientColor) {
        _gradientColor = [[GradientColor alloc]initWithColorA:self.normalTitleColor colorB:self.selectedTitleColor];
    }
    return _gradientColor;
}
//-(GradientColor *)gradientColor_bg {
//    if (!_gradientColor_bg) {
//        _gradientColor_bg = [[GradientColor alloc]initWithColorA:self.normalBgColor colorB:self.selectedBgColor];
//    }
//    return _gradientColor_bg;
//}

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
    if (self.allowCellSpace) {
        if (section == 0) {
            return cellSpace_2+cellSpace_2;
        }else{
            return cellSpace_2;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.allowCellSpace) {
        if (section == self.titleArray.count-1) {
            return cellSpace_2+cellSpace_2;
        }else{
            return cellSpace_2;
        }
    }
    return 0;
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
//        cell.textLabel.backgroundColor = self.selectedBgColor;
    }else {
        cell.textLabel.textColor = self.normalTitleColor;
//        cell.textLabel.backgroundColor = self.normalBgColor;
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
    if (self.maxTitleCount>0) {
        NSUInteger titleCount = self.maxTitleCount;
        if (self.adaptFull_maxTitleCount) {
            titleCount = MIN(self.maxTitleCount, self.titleArray.count);
        }
        CGFloat offset = 0;
        if (self.allowCellSpace) {
            offset = (titleCount+1)*(cellSpace_2+cellSpace_2);
        }
        self.titleLabelWidth = (self.bounds.size.width - offset)/titleCount;
    }
    [self changeSelectWithW:self.titleLabelWidth cy:0];

    [self.tableView reloadData];
}


-(void)handoverWithLeftPageIndex:(NSUInteger)leftPageIndex leftScale:(CGFloat)leftScale rightPageIndex:(NSUInteger)rightPageIndex rightScale:(CGFloat)rightScale{
    _SegmentTableViewCell *leftCell;
    _SegmentTableViewCell *rightCell;
    if (leftPageIndex<self.titleArray.count) {
        leftCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:leftPageIndex]];
        CGFloat scale = leftScale <= 0.2 ? 0.0 : leftScale;
        scale = scale >= 0.8 ? 1.0 : scale;
        leftCell.textLabel.textColor = [self.gradientColor colorAChangeToColorB:scale];
    }
    if (rightPageIndex<self.titleArray.count) {
        rightCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:rightPageIndex]];
        CGFloat scale = rightScale <= 0.2 ? 0.0 : rightScale;
        scale = scale >= 0.8 ? 1.0 : scale;
        rightCell.textLabel.textColor = [self.gradientColor colorAChangeToColorB:scale];
    }
    if (leftScale >= 0.8) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:leftPageIndex] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    CGFloat w = 0;
    CGFloat cy = 0;
    if (leftCell && rightCell) {
        if (self.titleLabelWidth <= 0) {
            CGFloat wl = CGRectGetWidth(leftCell.bounds);
            CGFloat wr = CGRectGetWidth(rightCell.bounds);
            w = wl + (wr - wl) * rightScale;
        }
        CGFloat cyl = leftCell.center.y;
        CGFloat cyr = rightCell.center.y;
        cy = cyl + (cyr - cyl) * rightScale;
    }else {
        if (self.titleLabelWidth <= 0) {
            w = CGRectGetWidth(leftCell.bounds);
        }
        cy = leftCell.center.y;
    }
    [self changeSelectWithW:w cy:cy];
}

-(void)changeSelectWithW:(CGFloat)w cy:(CGFloat)cy {
    if (w>0) {
        CGRect frame = self.cellLineView.bounds;
        frame.size.height = w;
        self.cellLineView.frame = frame;
        frame = self.cellBgView.bounds;
        frame.size.height = w;
        self.cellBgView.frame = frame;
    }
    if (cy>0) {
        self.cellLineView.center = CGPointMake(self.cellLineView.center.x, cy);
        self.cellBgView.center = CGPointMake(self.panelView.bounds.size.height/2.0, cy);
        self.cellImageView.center = CGPointMake(self.cellImageView.center.x, cy);
    }
}

-(void)adjustCurrentIndex:(NSUInteger)currentIndex{
    _currentIndex = currentIndex;
}

@end

